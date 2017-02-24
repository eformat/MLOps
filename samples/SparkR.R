# http://spark.apache.org/docs/latest/sparkr.html

Sys.setenv(SPARK_HOME ="/home/guest/spark-2.1.0")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session.stop()
sparkR.session(master = "spark://172.17.0.5:7077", appName="RStudio")




