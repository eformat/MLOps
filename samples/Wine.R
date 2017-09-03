# Adapted from http://blog.learningtree.com/machine-learning-using-spark-r/

# Prepare data
library(readr)  
library(dplyr)  
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"  
df <-  
  read_delim(url, delim = ";") %>%  
  dplyr::mutate(taste = as.factor(ifelse(quality < 6, "bad", ifelse(quality > 6, "good", "average")))) %>%  
  dplyr::select(-quality)  
df <- dplyr::mutate(df, id = as.integer(rownames(df)))

# Connect to Spark cluster
Sys.setenv(SPARK_HOME="/opt/spark")
library(SparkR, lib.loc=c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master="local[*]")

# Create Spark distributed dataframe
ddf <- createDataFrame(df)

# Split this into training (70%) and test (30%) datasets
seed <- 12345  
training_ddf <- sample(ddf, withReplacement=FALSE, fraction=0.7, seed=seed)  
test_ddf <- except(ddf, training_ddf)

# Train model to predict "taste"
model <- spark.randomForest(training_ddf, taste ~ ., type="classification", seed=seed)

# Examine model
summary(model)

# Use model to make predictions
predictions <- predict(model, test_ddf)  
prediction_df <- collect(select(predictions, "id", "prediction"))

# Test accuracy by comparing to actuals
actual_vs_predicted <-  
 dplyr::inner_join(df, prediction_df, "id") %>%  
 dplyr::select(id, actual = taste, predicted = prediction)

mean(actual_vs_predicted$actual == actual_vs_predicted$predicted)

table(actual_vs_predicted$actual, actual_vs_predicted$predicted)

# Save model for future use
model_file_path <- "home/andrew/wine_random_forest_model"  
write.ml(model, model_file_path)  
saved_model <- read.ml(model_file_path)  
summary(saved_model)

sparkR.session.stop()





