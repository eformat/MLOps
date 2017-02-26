#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# For this example, we shall use the "flights" dataset
# The dataset consists of every flight departing Houston in 2011.
# The data set is made up of 227,496 rows x 14 columns.

# To run this example use
# ./bin/spark-submit examples/src/main/r/data-manipulation.R <path_to_csv>

Sys.setenv(SPARK_HOME = "/home/guest/spark-2.1.0")
Sys.setenv(SPARK_MASTER = "local[*]")
Sys.setenv(GIT_HOME = "/home/guest/MLOps")
setwd(file.path(Sys.getenv("GIT_HOME"), "/samples"))
getwd()

# Load SparkR library into your R session
# library(SparkR)
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# args <- commandArgs(trailing = TRUE)
# if (length(args) < 1 ) {
#   print("Usage: data-manipulation.R <path-to-flights.csv>")
#   print("The data can be downloaded from: http://s3-us-west-2.amazonaws.com/sparkr-data/flights.csv")
#   q("no")
# }

## Initialize SparkSession
sparkR.session(master = Sys.getenv("SPARK_MASTER"), appName = "SparkR-data-manipulation-example", sparkConfig = list(spark.driver.memory = "4g"))

# flightsCsvPath <- args[[1]]
flightsCsvPath <- "http://s3-us-west-2.amazonaws.com/sparkr-data/flights.csv"
flightsCsvPathlocal <- file.path(Sys.getenv("GIT_HOME"), "/samples/flights.csv")

# Create a local R dataframe
flights_df <- read.csv(flightsCsvPath, header = TRUE)
flights_df$date <- as.Date(flights_df$date)
head(flights_df)

## Filter flights whose destination is San Francisco and write to a local data frame
SFO_df <- flights_df[flights_df$dest == "SFO", ]
head(SFO_df)

# Convert the local data frame into a SparkDataFrame
SFO_DF <- createDataFrame(SFO_df)
head(SFO_DF)

#  Directly create a SparkDataFrame from the source data
# flightsDF <- read.df(flightsCsvPath, source = "csv", header = "true")
flightsDF <- read.df(flightsCsvPathlocal, source = "csv", header = "true")
head(flightsDF)

# Print the schema of this SparkDataFrame
printSchema(flightsDF)

# Cache the SparkDataFrame
cache(flightsDF)

# Print the first 6 rows of the SparkDataFrame
showDF(flightsDF, numRows = 6) ## Or
head(flightsDF)

# Show the column names in the SparkDataFrame
columns(flightsDF)

# Show the number of rows in the SparkDataFrame
count(flightsDF)

# Select specific columns
destDF <- select(flightsDF, "dest", "cancelled")
head(destDF)

# Using SQL to select columns of data
# First, register the flights SparkDataFrame as a table
createOrReplaceTempView(flightsDF, "flightsTable")
destDF <- sql("SELECT dest, cancelled FROM flightsTable")
head(destDF)

# Use collect to create a local R data frame
local_df <- collect(destDF)

# Print the newly created local data frame
head(local_df)

# Filter flights whose destination is JFK
jfkDF <- filter(flightsDF, "dest = \"JFK\"") ##OR
jfkDF <- filter(flightsDF, flightsDF$dest == "JFK")

# If the magrittr library is available, we can use it to
# chain data frame operations
if("magrittr" %in% rownames(installed.packages())) {
  library(magrittr)

  # Group the flights by date and then find the average daily delay
  # Write the result into a SparkDataFrame
  groupBy(flightsDF, flightsDF$date) %>%
    summarize(avg(flightsDF$dep_delay), avg(flightsDF$arr_delay)) -> dailyDelayDF

  # Print the computed SparkDataFrame
  head(dailyDelayDF)
}

# Stop the SparkSession now
sparkR.session.stop()
