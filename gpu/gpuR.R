# Ripped from
# https://rpubs.com/christoph_euler/gpuR_examples

library("gpuR")
detectGPUs()
str(gpuInfo(platform_idx = 1L, device_idx = 1L))
# str(gpuInfo(platform_idx = 2L, device_idx = 1L))

result <- data.frame()

for (exponent in seq(2,24,2)){
  A = matrix(rnorm(2^exponent), nrow=sqrt(2^exponent))
  B = matrix(rnorm(2^exponent), nrow=sqrt(2^exponent))
  
  now <- Sys.time()
  gpuA = gpuMatrix(A, type="double")
  gpuB = gpuMatrix(B, type="double")
  gpuC = gpuA %*% gpuB
  gpu <- Sys.time()-now
  
  now <- Sys.time()
  C = A%*%B
  classic <- Sys.time()-now
  
  now <- Sys.time()
  vclA = vclMatrix(A, type="double")
  vclB = vclMatrix(B, type="double")
  vclC = vclA %*% vclB
  vcl <- Sys.time()-now
  
  result <- rbind(result,c(nrow(A), classic, gpu, vcl)) 
}

colnames(result) <- c("nrow", "time_classic", "time_gpu", "time_vcl")
result

library(ggplot2)
library("reshape2")

melted = melt(result, id.vars="nrow")
ggplot(data=melted, aes(x=nrow, y=value, group=variable)) + geom_line()
