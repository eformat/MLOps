# Ripped from
# https://goatoftheplague.com/2016/12/08/installing-r-package-gputools-and-cuda-8-0-on-ubuntu-16-04/

options(encoding = "UTF-8")
library(gputools)

magnitude <- 10
dimA <- 2*magnitude;dimB <- 3*magnitude;dimC <- 4*magnitude
matA <- matrix(runif(dimA*dimB), dimA, dimB)
matB <- matrix(runif(dimB*dimC), dimB, dimC)

system.time(matA%*%matB);
system.time(gpuMatMult(matA, matB))

magnitude <- 1000
dimA <- 2*magnitude;dimB <- 3*magnitude;dimC <- 4*magnitude
matA <- matrix(runif(dimA*dimB), dimA, dimB)
matB <- matrix(runif(dimB*dimC), dimB, dimC)

system.time(matA%*%matB);
system.time(gpuMatMult(matA, matB))
