
# Replace with your AWS S3 credentials
Sys.setenv("AWS_ACCESS_KEY_ID" = "***") 
Sys.setenv("AWS_SECRET_ACCESS_KEY" = "***")

# Replace with your Spark distribution location
Sys.setenv(SPARK_HOME ="/opt/spark")

# Jupyter r-notebook example requires this setting
# Sys.setenv(SPARK_HOME ="/home/jovyan/spark")

library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

# Replace master with your Spark cluster end point
sparkR.session(master = "local[*]", 
               sparkConfig = list(spark.driver.memory = "1g")
              )

df <- as.DataFrame(faithful)
head(df)

# Replace with your sample AWS S3 csv file
file <- "s3n://stefanopicozzi.blog/data.csv"

df <- read.df(file, source = "csv", header="true", inferSchema = "true")
head(df)

sparkR.session.stop()

