## Wine_Type: Classify Red versus White 

# Ripped and adapted from
# https://www.datacamp.com/community/tutorials/deep-learning-python
# https://www.datacamp.com/community/tutorials/keras-r-deep-learning
# http://blog.learningtree.com/machine-learning-using-spark-r/

# Install these packages
library(readr)  
library(dplyr)
library(keras)
library(corrplot)

## Prepare data
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"  
white_df <- read.csv(file=url, header=TRUE, sep=";", stringsAsFactors=FALSE)
white_df$type <- 0 
set.seed(101)
white_df <- sample_frac(white_df, 0.5)
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"  
red_df   <- read.csv(file=url, header=TRUE, sep=";", stringsAsFactors=FALSE)
red_df$type <- 1
wine_df <- rbind(white_df, red_df)
head(wine_df)
str(wine_df)
dim(wine_df)

## Quick exploratory analysis
M <- cor(wine_df[,1:13])
corrplot(M, method="circle")

## Split this into training (60%) and test (40%) datasets
set.seed(101)
train_df <- sample_frac(wine_df, 0.7)
sid <- as.numeric(rownames(train_df)) # because rownames() returns character
total_test_df <- wine_df[-sid,]

## Split 0.8 of for model creation and testing
## Reserve and export other 0.2 for saved model testing
test_df <- sample_frac(total_test_df, 0.8)
sid <- as.numeric(rownames(test_df)) 
test2_df <- test_df[-sid,]
save(test2_df,file="~/Wine-type-df.Rda")

## Separate independent and dependent observations
drops <- c("type")
X_train <- train_df[ , !(names(train_df) %in% drops)]
X_test <- test_df[ , !(names(test_df) %in% drops)]
keeps <- c("type")
y_train <- train_df[ keeps ]
y_test <- test_df[ keeps ]

## Standarise data
X_test <- scale(X_test)
X_train <- scale(X_train)

## Prepare as Keras inpus
X_train <- as.matrix(X_train)
dimnames(X_train) <- NULL
summary(X_train)
y_train <- as.matrix(y_train)
y_trainLabels <- to_categorical(y_train)

X_test <- as.matrix(X_test)
dimnames(X_test) <- NULL
summary(X_test)
y_test <- as.matrix(y_test)
y_testLabels <- to_categorical(y_test)

## Defining the Model
model <- keras_model_sequential() 
model %>% 
  layer_dense( units = 12, activation = 'relu', input_shape = c(12) ) %>% 
  layer_dense( units = 8, activation = 'relu' ) %>%
  layer_dense( units = 2, activation = 'sigmoid' )

# Print a summary of a model
summary(model)
get_config(model)
get_layer(model, index = 1)
model$layers
model$inputs
model$outputs

model %>% compile(
  loss = 'binary_crossentropy',
  optimizer = 'adam',
  metrics = 'accuracy'
)

## Training and evaluation
system.time(
  history <- model %>% fit(
    X_train, y_trainLabels, 
    epochs = 4, 
    batch_size = 1,
    validation_split = 0.2,
    verbose = 1
  )
)

#plot(history)

# Plot the model loss of the training data
plot(history$metrics$loss, main="Model Loss", xlab = "epoch", ylab="loss", col="blue", type="l")
# Plot the model loss of the test data
lines(history$metrics$val_loss, col="green")
# Add legend
legend("topright", c("train","test"), col=c("blue", "green"), lty=c(1,1))

# Plot the accuracy of the training data 
plot(history$metrics$acc, main="Model Accuracy", xlab = "epoch", ylab="accuracy", col="blue", type="l")
# Plot the accuracy of the validation data
lines(history$metrics$val_acc, col="green")
# Add Legend
legend("bottomright", c("train","test"), col=c("blue", "green"), lty=c(1,1))

# Predict the classes for the test data
classes <- model %>% predict_classes(X_test, batch_size = 128)
# Confusion matrix
table(y_test, classes)

# Evaluate on test data and labels
score <- model %>% evaluate(X_test, y_testLabels, batch_size = 128)
# Print the score
print(score)

# Save the model
save_model_hdf5(model, "~/Wine-type-model", overwrite = TRUE, include_optimizer = TRUE)

## Now repeat by loading the saved model and test using the saved test2_df

wine_type_model <- load_model_hdf5("~/Wine_type_model")
load("~/Wine-type-df.Rda")

X_test <- test2_df[ , !(names(test2_df) %in% drops)]
keeps <- c("type")
y_test <- test2_df[ keeps ]

X_test <- scale(X_test)
X_test <- as.matrix(X_test)
dimnames(X_test) <- NULL
y_test <- as.matrix(y_test)
y_testLabels <- to_categorical(y_test)

# Predict the classes for the test data
classes <- wine_type_model %>% predict_classes(X_test, batch_size = 128)
# Confusion matrix
table(y_test, classes)

# Evaluate on test data and labels
score <- wine_type_model %>% evaluate(X_test, y_testLabels, batch_size = 128)
# Print the score
print(score)

