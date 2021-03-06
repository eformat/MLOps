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

Sys.setenv(SPARK_HOME = "/home/guest/spark-2.1.0")
Sys.setenv(REMOTE_SPARK_HOME = "/opt/spark")
# Sys.setenv(SPARK_MASTER = "local[*]")
Sys.setenv(SPARK_MASTER = "spark://172.17.0.8:7077")
Sys.setenv(GIT_HOME = "/home/guest/MLOps")
Sys.setenv(REMOTE_GIT_HOME = "/tmp/work/MLOps")
setwd(file.path(Sys.getenv("GIT_HOME"), "/samples"))
getwd()

# library(SparkR)
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Initialize SparkSession
sparkR.session(master = Sys.getenv("SPARK_MASTER"), appName = "SparkR DataFrame Example")

# Create a simple local data.frame
localDF <- data.frame(name=c("John", "Smith", "Sarah"), age=c(19, 23, 18))

# Convert local data frame to a SparkDataFrame
df <- createDataFrame(localDF)
head(df)

# Print its schema
printSchema(df)
# root
#  |-- name: string (nullable = true)
#  |-- age: double (nullable = true)

# Create a DataFrame from a JSON file
# path <- file.path(Sys.getenv("GIT_HOME"), "spark-2.1.0/examples/src/main/resources/people.json")
path <-'https://raw.githubusercontent.com/StefanoPicozzi/MLOps/master/spark-2.1.0/examples/src/main/resources/people.json'

require(RJSONIO)
require(readr)
jsonstring <- read_file(path)
jsonDF <- fromJSON(jsonstring)
jsonDF <- lapply(jsonDF, function(x) { 
  x[sapply(x, is.null)] <- NA 
  unlist(x)
})
jsonDF <- as.data.frame(do.call("rbind", jsonDF))

peopleDF <- createDataFrame(jsonDF)
printSchema(peopleDF)
head(peopleDF)

# root
#  |-- age: long (nullable = true)
#  |-- name: string (nullable = true)

# Register this DataFrame as a table.
createOrReplaceTempView(peopleDF, "people")

# SQL statements can be run by using the sql methods
teenagers <- sql("SELECT name FROM people WHERE age >= 13 AND age <= 19")
head(teenagers)

# Call collect to get a local data.frame
teenagersLocalDF <- collect(teenagers)

# Print the teenagers in our dataset
print(teenagersLocalDF)

# Stop the SparkSession now
sparkR.session.stop()
