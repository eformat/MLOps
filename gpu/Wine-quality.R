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
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"  
red_df   <- read.csv(file=url, header=TRUE, sep=";", stringsAsFactors=FALSE)
red_df$type <- 1
wine_df <- rbind(white_df, red_df)
wine_df$quality.no <- wine_df$quality
#wine_df <- cbind(wine_df, quality.no = 1)
#wine_df$quality.no[wine_df$quality < 6] <- 0
#wine_df$quality.no[wine_df$quality > 6] <-  2
drops <- c("quality")
wine_df <- wine_df[ , !(names(wine_df) %in% drops)]
head(wine_df)
str(wine_df)
dim(wine_df)

## Quick exploratory analysis
M <- cor(wine_df[,1:13])
corrplot(M, method="circle")

## Split this into training (70%) and test (30%) datasets
set.seed(101)
train_df <- sample_frac(wine_df, 0.7)
sid <- as.numeric(rownames(train_df)) # because rownames() returns character
test_df <- wine_df[-sid,]

## Separate independent and depnendent observations
drops <- c("quality.no")
X_train <- train_df[ , !(names(train_df) %in% drops) ]
X_test <- test_df[ , !(names(test_df) %in% drops) ]
keeps <- c("quality.no")
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
dimnames(y_train) <- NULL
y_trainLabels <- to_categorical(y_train)

X_test <- as.matrix(X_test)
dimnames(X_test) <- NULL
summary(X_test)
y_test <- as.matrix(y_test)
dimnames(y_test) <- NULL
y_testLabels <- to_categorical(y_test)

## Defining the Model
model <- keras_model_sequential() 
model %>% 
  layer_dense( units = 24, activation = 'relu', input_shape = c(12) ) %>% 
  layer_dense( units = 8, activation = 'relu' ) %>%
  layer_dense( units = 10, activation = 'sigmoid' )

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
    epochs = 20, 
    batch_size = 1,
    validation_split = 0.2,
    verbose = 1
  )
)

plot(history)

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