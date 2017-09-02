
rm -rf namesAnd*
rm -rf people.parquet
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_LD_LIBRARY_PATH

export SPARK_MASTER=local[*]
export SPARK_HOME=/home/spicozzi/spark-2.1.0

# Rscript dataframe.R
# Rscript --verbose data-manipulation.R 
Rscript RSparkSQLExample.R
