# Ripped from
# http://dsnotes.com/post/installing-cuda-toolkit-and-gputools/

options(encoding = "UTF-8")
library(gputools)
N <- 1e3
m <- matrix(sample(100, size = N*N, replace = T), nrow = N)
system.time(dist(m))
system.time(gpuDist(m))