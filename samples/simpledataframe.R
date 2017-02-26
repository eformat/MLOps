
Sys.setenv(SPARK_HOME = "/home/guest/spark-2.1.0")
# Sys.setenv(SPARK_MASTER = "local[*]")
Sys.setenv(SPARK_MASTER = "spark://172.17.0.4:7077")
Sys.setenv(GIT_HOME = "/home/guest/MLOps")
setwd(file.path(Sys.getenv("GIT_HOME"), "/samples"))
getwd()

library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session.stop()
sparkR.session(master = Sys.getenv("SPARK_MASTER"), appName="RStudio Simple Spark DF")

# Local DataFrame Test
df <- as.DataFrame(faithful)
head(df)

sparkR.session.stop()





