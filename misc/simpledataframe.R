
Sys.setenv(SPARK_HOME = "/home/guest/spark-2.1.0")
# Sys.setenv(SPARK_MASTER = "local[*]")
Sys.setenv(SPARK_MASTER = "spark://172.17.0.8:7077")
Sys.setenv(GIT_HOME = "/home/guest/MLOps")
setwd(file.path(Sys.getenv("GIT_HOME"), "/samples"))
getwd()

library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session.stop()
sparkR.session(master = Sys.getenv("SPARK_MASTER"), appName="RStudio Simple Spark DF")

# Spark DateFrame from Local DataFrame Test
faithfulDF <- createDataFrame(faithful)
head(faithfulDF)
printSchema(faithfulDF)

# SQL statements can be run by using the sql methods
createOrReplaceTempView(faithfulDF, "faithful")
waiting <- sql("SELECT eruptions, waiting FROM faithful WHERE waiting <= 60")
head(waiting)

# Local DateFrame from Spark DataFrame Test
localFaithfulDF <- collect(waiting)
head(localFaithfulDF)

sparkR.session.stop()





