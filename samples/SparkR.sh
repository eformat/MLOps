
rm -rf namesAnd*
rm -rf people.parquet
export SPARK_HOME=/home/spicozzi/spark-2.1.0
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_LD_LIBRARY_PATH

# Rscript dataframe.R
Rscript data-manipulation.R http://s3-us-west-2.amazonaws.com/sparkr-data/flights.csv
# Rscript RSparkSQLExample.R
