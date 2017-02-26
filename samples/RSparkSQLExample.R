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
Sys.setenv(SPARK_MASTER = "local[*]")
Sys.setenv(GIT_HOME = "/home/guest/MLOps")
Sys.setenv(DB_HOST = "172.30.93.75")
setwd(file.path(Sys.getenv("GIT_HOME"), "/samples"))
getwd()

# Remove outputs from previous attempt so can rerun
dir <- file.path(Sys.getenv("GIT_HOME"), "samples/namesAndFavColors.parquet")
unlink(dir, recursive = TRUE, force = TRUE)
dir <- file.path(Sys.getenv("GIT_HOME"), "samples/namesAndAges.parquet")
unlink(dir, recursive = TRUE, force = TRUE)
dir <- file.path(Sys.getenv("GIT_HOME"), "samples/people.parquet")
unlink(dir, recursive = TRUE, force = TRUE)
library(RPostgreSQL)
library("sqldf")
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname="dbserver", host="172.30.93.75", port = 5432, user="username", password="password")
sqldf("DROP TABLE people", host="172.30.93.75", dbname = "dbserver", user = "username", password = "password")
dbDisconnect(con)

# library(SparkR)
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# $example on:init_session$
  
sparkR.session(master = Sys.getenv("SPARK_MASTER"), appName = "R Spark SQL basic example", 
   sparkConfig = list(spark.driver.extraClassPath = file.path(Sys.getenv("GIT_HOME"), "samples/postgresql-9.4.1212.jar")))

#, sparkConfig = list(spark.some.config.option = "some-value"))

# $example off:init_session$

# $example on:create_df$
df <- read.json(file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/people.json"))

# Displays the content of the DataFrame
head(df)
##   age    name
## 1  NA Michael
## 2  30    Andy
## 3  19  Justin

# Another method to print the first few rows and optionally truncate the printing of long values
showDF(df)
## +----+-------+
## | age|   name|
## +----+-------+
## |null|Michael|
## |  30|   Andy|
## |  19| Justin|
## +----+-------+
## $example off:create_df$


# $example on:untyped_ops$
# Create the DataFrame
df <- read.json(file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/people.json"))

# Show the content of the DataFrame
head(df)
##   age    name
## 1  NA Michael
## 2  30    Andy
## 3  19  Justin


# Print the schema in a tree format
printSchema(df)
## root
## |-- age: long (nullable = true)
## |-- name: string (nullable = true)

# Select only the "name" column
head(select(df, "name"))
##      name
## 1 Michael
## 2    Andy
## 3  Justin

# Select everybody, but increment the age by 1
head(select(df, df$name, df$age + 1))
##      name (age + 1.0)
## 1 Michael          NA
## 2    Andy          31
## 3  Justin          20

# Select people older than 21
head(where(df, df$age > 21))
##   age name
## 1  30 Andy

# Count people by age
head(count(groupBy(df, "age")))
##   age count
## 1  19     1
## 2  NA     1
## 3  30     1
# $example off:untyped_ops$


# Register this DataFrame as a table.
createOrReplaceTempView(df, "table")
# $example on:run_sql$
df <- sql("SELECT * FROM table")
# $example off:run_sql$


# $example on:generic_load_save_functions$
df <- read.df(file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/users.parquet"))
write.df(select(df, "name", "favorite_color"), "namesAndFavColors.parquet")
# $example off:generic_load_save_functions$


# $example on:manual_load_options$
df <- read.df(file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/people.json"), "json")
namesAndAges <- select(df, "name", "age")
write.df(namesAndAges, "namesAndAges.parquet", "parquet")
# $example off:manual_load_options$


# $example on:direct_sql$
pfile <- file.path(Sys.getenv('SPARK_HOME'),'examples/src/main/resources/users.parquet')
df <- sql("SELECT * FROM parquet.`/home/guest/spark-2.1.0/examples/src/main/resources/users.parquet`")
# df <- sql("SELECT * FROM parquet.`pfile`")
# $example off:direct_sql$


# $example on:basic_parquet_example$
df <- read.df(file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/people.json"), "json")

# SparkDataFrame can be saved as Parquet files, maintaining the schema information.
write.parquet(df, "people.parquet")

# Read in the Parquet file created above. Parquet files are self-describing so the schema is preserved.
# The result of loading a parquet file is also a DataFrame.
parquetFile <- read.parquet("people.parquet")

# Parquet files can also be used to create a temporary view and then used in SQL statements.
createOrReplaceTempView(parquetFile, "parquetFile")
teenagers <- sql("SELECT name FROM parquetFile WHERE age >= 13 AND age <= 19")
head(teenagers)
##     name
## 1 Justin

# We can also run custom R-UDFs on Spark DataFrames. Here we prefix all the names with "Name:"
schema <- structType(structField("name", "string"))
teenNames <- dapply(df, function(p) { cbind(paste("Name:", p$name)) }, schema)
for (teenName in collect(teenNames)$name) {
  cat(teenName, "\n")
}
## Name: Michael
## Name: Andy
## Name: Justin
# $example off:basic_parquet_example$


# $example on:schema_merging$
df1 <- createDataFrame(data.frame(single=c(12, 29), double=c(19, 23)))
df2 <- createDataFrame(data.frame(double=c(19, 23), triple=c(23, 18)))

# Create a simple DataFrame, stored into a partition directory
write.df(df1, "data/test_table/key=1", "parquet", "overwrite")

# Create another DataFrame in a new partition directory,
# adding a new column and dropping an existing column
write.df(df2, "data/test_table/key=2", "parquet", "overwrite")

# Read the partitioned table
df3 <- read.df("data/test_table", "parquet", mergeSchema = "true")
printSchema(df3)
# The final schema consists of all 3 columns in the Parquet files together
# with the partitioning column appeared in the partition directory paths
## root
##  |-- single: double (nullable = true)
##  |-- double: double (nullable = true)
##  |-- triple: double (nullable = true)
##  |-- key: integer (nullable = true)
# $example off:schema_merging$


# $example on:json_dataset$
# A JSON dataset is pointed to by path.
# The path can be either a single text file or a directory storing text files.
path <- file.path(Sys.getenv("SPARK_HOME"),"examples/src/main/resources/people.json")
# Create a DataFrame from the file(s) pointed to by path
people <- read.json(path)

# The inferred schema can be visualized using the printSchema() method.
printSchema(people)
## root
##  |-- age: long (nullable = true)
##  |-- name: string (nullable = true)

# Register this DataFrame as a table.
createOrReplaceTempView(people, "people")

# SQL statements can be run by using the sql methods.
teenagers <- sql("SELECT name FROM people WHERE age >= 13 AND age <= 19")
head(teenagers)
##     name
## 1 Justin
# $example off:json_dataset$


# $example on:spark_hive$
# enableHiveSupport defaults to TRUE
sparkR.session(enableHiveSupport = TRUE)
sql("CREATE TABLE IF NOT EXISTS src (key INT, value STRING)")
kv1file <- file.path(Sys.getenv('HOME_SPARK'), 'examples/src/main/resources/kv1.txt') 
# sql("LOAD DATA LOCAL INPATH file.path(Sys.getenv('SPARK_HOME'),'examples/src/main/resources/kv1.txt') INTO TABLE src")
sql("LOAD DATA LOCAL INPATH '/home/guest/spark-2.1.0/examples/src/main/resources/kv1.txt' INTO TABLE src")
# sql("LOAD DATA LOCAL INPATH `kv1file`) INTO TABLE src")

# Queries can be expressed in HiveQL.
results <- collect(sql("FROM src SELECT key, value"))
head(results)
# $example off:spark_hive$

# Saving data to a JDBC source
# write.jdbc(df, "jdbc:postgresql:dbserver", "people", host="172.30.93.75", port = 5432, user = "username", password = "password")
dbConString <- paste("jdbc:postgresql://", Sys.getenv("DB_HOST"), ":5432/dbserver", sep="")
write.jdbc(df, dbConString, "people", user = "username", password = "password")
# $example off:jdbc_dataset$

# $example on:jdbc_dataset$
# Loading data from a JDBC source
df <- read.jdbc(dbConString, "people", user = "username", password = "password")
head(df)

# Stop the SparkSession now
sparkR.session.stop()
