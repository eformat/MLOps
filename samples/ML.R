Sys.setenv(SPARK_HOME ="/home/guest/spark-2.1.0")
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "spark://172.17.0.6:7077", sparkConfig = list(spark.driver.memory = "1g"))
install.packages("magrittr")

# 1.
df <- createDataFrame(iris)
head(df)

# 2.
head(select(df, df$Sepal_Length, df$Species))

head(filter(df, df$Sepal_Length >5.5))
head(select(filter(df, df$Sepal_Length >5.5), df$Sepal_Length, df$Species)) 

#3.
df2 <- summarize(groupBy(df, df$Species), mean=mean(df$Sepal_Length), count=n(df$Sepal_Length))
head(df2)

head(arrange(df2, desc(df2$mean)))

#4.
library(magrittr)
finaldf <- filter(df, df$Sepal_Length >5.5) %>%
  group_by(df$Species) %>%
  summarize(mean=mean(df$Sepal_Length))
arrange(finaldf, desc(finaldf$mean)) %>% head

#5.
createOrReplaceTempView(df,"df")
dfSQL<-sql("SELECT * FROM df WHERE Sepal_Length > 5.5")

dflocal <- collect(dfSQL)
print(dflocal[1:10,])

#1.
iris$ID<-c(1:nrow(iris))
df <- createDataFrame(iris)
nrow(df)
df_test<-sample(df, FALSE, 0.2)
nrow(df_test)  

testID <- collect(select(df_test, "ID"))$ID
df$istest <- df$ID %in% testID
df_train <- subset(df, df$istest==FALSE)
nrow(df_train)

#2.
model <- glm(Sepal_Length ~ . - ID - istest , data=df_train, family="gaussian")
summary(model)

#3.
prediction <- predict(model, newData=df_test)
head(select(prediction, "Sepal_Length", "prediction"))

smean <- collect(agg(df_train, mean=mean(df_train$Sepal_Length)))$mean
smean

prediction <- transform(
prediction,
s_res=(prediction$Sepal_Length - prediction$prediction)**2,
s_tot=(prediction$Sepal_Length - smean)**2)
head(select(prediction, "Sepal_Length", "prediction", "s_res", "s_tot"))

res <- collect(agg(prediction, 
  ss_res=sum(prediction$s_res),
  ss_tot=sum(prediction$s_tot)))
res

R2=1-(res$ss_res/res$ss_tot)
R2

sparkR.session.stop()
