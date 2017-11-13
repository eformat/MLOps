# Ripped from
# http://angrystatistician.blogspot.com.au/2015/02/short-notes-get-cuda-and-gputools.html

options(encoding = "UTF-8")
library(gputools)

set.seed(5446)
p <- 20
X <- matrix(rnorm(2^p),ncol = 2^(p/2))

dtime <- system.time(d <- dist(X))
gputime <- system.time(gpud <- gpuDist(X))

dtime
gputime
dtime/gputime
max(abs(c(d) - c(gpud)))