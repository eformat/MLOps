# Adapted from https://www.codementor.io/jadianes/spark-r-data-frame-operations-sql-du1080rl5

# Edit to reflect your AWS S3 credentials
Sys.setenv("AWS_ACCESS_KEY_ID" = "***")
Sys.setenv("AWS_SECRET_ACCESS_KEY" = "***")

Sys.setenv(SPARK_HOME ="/opt/spark")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
library(ggplot2)

# Edit to reflect your Spark master end point
sc <- sparkR.session(master = "spark://172.30.253.81:7077",
                     appName = "Housing",
                     sparkConfig = list(spark.driver.memory="2g"),
                    )

# Edit to reflect you AWS S3 Bucket file locations
housing_a_file_path <- file.path('s3a://stefanopicozzi.blog', 'csv_hus', 'ss13husa.csv')
housing_b_file_path <- file.path('s3a://stefanopicozzi.blog', 'csv_hus', 'ss13husb.csv')

system.time (
  housing_a_df <- read.df(housing_a_file_path, source = "csv", header="true", inferSchema = "true")
)
system.time (
  housing_b_df <- read.df(housing_b_file_path, source = "csv", header="true", inferSchema = "true")
)

system.time (
  housing_df <- rbind(housing_a_df, housing_b_df)
)

system.time (
  nrow(housing_df)
)
head(housing_df)

housing_region_df_local <- collect(select(housing_df,"REGION"))
str(housing_region_df_local)

housing_region_df_local$REGION <- factor(
        x=housing_region_df_local$REGION, 
        levels=c(1,2,3,4,9),
        labels=c('Northeast', 'Midwest','South','West','Puerto Rico')
)

c <- ggplot(data=housing_region_df_local, aes(x=factor(REGION)))
c + geom_bar() + xlab("Region")
print(c)

collect(select(housing_df, "REGION", "VALP"))

system.time(
  collect(select(housing_df, housing_df$VALP))
)

system.time(
  collect(select(housing_df, "VALP"))
)

head(selectExpr(housing_df, "(VALP / 100) as VALP_by_100"))

system.time(
  housing_valp_1000 <- collect(filter(select(housing_df, "REGION", "VALP"), "VALP > 1000"))
)

housing_valp_1000

registerTempTable(housing_df, "housing")

system.time(
  housing_valp_1000_sql <- collect(sql(sc, "SELECT REGION, VALP FROM housing WHERE VALP >= 1000"))
)

housing_valp_1000_sql

system.time(
  housing_valp_1000_subset <- collect(subset(
    housing_df, housing_df$VALP>1000, c("REGION","VALP"))
  )
)

housing_valp_1000_subset

system.time(
  housing_valp_1000_bracket <- collect(
    housing_df[housing_df$VALP>1000, c("REGION","VALP")]
  )
)

housing_valp_1000_bracket
housing_valp_1000_bracket$REGION <- factor(
        x=housing_valp_1000_bracket$REGION, 
        levels=c(1,2,3,4,9),
        labels=c('Northeast', 'Midwest','South','West','Puerto Rico')
)

c <- ggplot(data=housing_region_df_local, aes(x=factor(REGION)))
c + geom_bar() + ggtitle("Samples with VALP>1000") + xlab("Region")
print(c)

collect(select(housing_df, avg(housing_df$VALP)))

housing_avg_valp <- collect(agg(
        groupBy(housing_df, "REGION"), 
        NUM_PROPERTIES=n(housing_df$REGION),
        AVG_VALP = avg(housing_df$VALP), 
        MAX_VALUE=max(housing_df$VALP),
        MIN_VALUE=min(housing_df$VALP)
))
housing_avg_valp$REGION <- factor(
        housing_avg_valp$REGION, 
        levels=c(1,2,3,4,9), 
        labels=c('Northeast', 'Midwest','South','West','Puerto Rico')
)
housing_avg_valp

housing_avg_valp <- collect(agg(
        groupBy(housing_df, "REGION", "BDSP"), 
        NUM_PROPERTIES=n(housing_df$REGION),
        AVG_VALP = avg(housing_df$VALP), 
        MAX_VALUE=max(housing_df$VALP),
        MIN_VALUE=min(housing_df$VALP)
))
housing_avg_valp$REGION <- factor(
        housing_avg_valp$REGION, 
        levels=c(1,2,3,4,9), 
        labels=c('Northeast', 'Midwest','South','West','Puerto Rico')
)
housing_avg_valp

head(arrange(select(housing_df, "REGION", "VALP"), desc(housing_df$VALP)))
housing_avg_agg <- agg(
            groupBy(housing_df, "REGION", "BDSP"), 
            NUM_PROPERTIES=n(housing_df$REGION),
            AVG_VALP = avg(housing_df$VALP), 
            MAX_VALUE=max(housing_df$VALP),
            MIN_VALUE=min(housing_df$VALP)
)
housing_avg_sorted <- head(arrange(
           housing_avg_agg,   
           desc(housing_avg_agg$AVG_VALP)
))
    
housing_avg_sorted$REGION <- factor(
        housing_avg_sorted$REGION, 
        levels=c(1,2,3,4,9), 
        labels=c('Northeast', 'Midwest','South','West','Puerto Rico')
)
housing_avg_sorted

sparkR.session.stop()



