# Load SparkR library into your R session
library(SparkR)

# Connect to Spark cluster
Sys.setenv(SPARK_HOME="/opt/spark")
library(SparkR, lib.loc=c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master="local[*]",  
               # master="spark://172.30.117.179:7077",   
               appName = "SparkR-ML-example",
               sparkConfig = list(spark.driver.memory="2g")
)

############################ model read/write ##############################################
# $example on:read_write$
irisDF <- suppressWarnings(createDataFrame(iris))
# Fit a generalized linear model of family "gaussian" with spark.glm
gaussianDF <- irisDF
gaussianTestDF <- irisDF
gaussianGLM <- spark.glm(gaussianDF, Sepal_Length ~ Sepal_Width + Species, family = "gaussian")

# Save and then load a fitted MLlib model
modelPath <- tempfile(pattern = "ml", fileext = ".tmp")
write.ml(gaussianGLM, modelPath)
#gaussianGLM2 <- read.ml(modelPath)

# Check model summary
# summary(gaussianGLM2)
summary(gaussianGLM)

# Check model prediction
# gaussianPredictions <- predict(gaussianGLM2, gaussianTestDF)
gaussianPredictions <- predict(gaussianGLM, gaussianTestDF)
showDF(gaussianPredictions)

unlink(modelPath)
# $example off:read_write$

############################ fit models with spark.lapply #####################################
# Perform distributed training of multiple models with spark.lapply
costs <- exp(seq(from = log(1), to = log(1000), length.out = 5))
train <- function(cost) {
  stopifnot(requireNamespace("e1071", quietly = TRUE))
  model <- e1071::svm(Species ~ ., data = iris, cost = cost)
  summary(model)
}

model.summaries <- spark.lapply(costs, train)

# Print the summary of each model
print(model.summaries)

# Stop the SparkSession now
sparkR.session.stop()
