# library(pryr) 
# if we wanted to look at addresses

nr <- 5000  

#lets be square
x <- matrix(rnorm(nr * nr, 0, 1), nrow = nr, ncol = nr)

# CPU bound version, we could optimize but lets stay vanilla
time1 <- system.time({
  mm1 <- x %*% x
})

library(gpuR)

# GPU version, GPU pointer to CPU memory!! (gpuMatrix is simply a pointer)
gpuX = gpuMatrix(x, type = "float")  
#point GPU to matrix
time2 <- system.time({
  mm2 <- gpuX %*% gpuX
})

# GPU version, in GPU memory!! (vclMatrix formation is a memory transfer)
vclX = vclMatrix(x, type = "float")  

#push matrix to GPU
time3 <- system.time({
  mm3 <- vclX %*% vclX
})
detach("package:gpuR", unload = TRUE)

time1
time2
time3

set.seed(123456)
np <- 30 #number of predictors
nr <- 1e+05 #number of observations
X <- cbind(5, 1:nr, matrix(rnorm((np - 1) * nr, 0, 0.01), nrow = nr, ncol = (np -
                                                                               1)))
beta <- matrix(c(1, 3, runif(np - 1, 0, 0.2)), ncol = 1)
y <- X %*% beta + matrix(rnorm(nr, 0, 1), nrow = nr, ncol = 1)
# CPU bound version, slight optimize via crossprod but otherwise vanilla
time2 <- system.time({
  ms2 <- solve(crossprod(X), crossprod(X, y))
})

library(gpuR)

# GPU version, GPU pointer to CPU memory!! (gpuMatrix is simply a pointer)
gpuX = gpuMatrix(X, type = "float") 

#point GPU to matrix
gpuy = gpuMatrix(y, type = "float")
time4 <- system.time({
  ms4 <- gpuR::solve(gpuR::crossprod(gpuX), gpuR::crossprod(gpuX, gpuy))
})

# GPU version, in GPU memory!! (vclMatrix formation is a memory transfer)
vclX = vclMatrix(X, type = "float") 

#push matrix to GPU
vcly = vclMatrix(y, type = "float")
time5 <- system.time({
  ms5 <- gpuR::solve(gpuR::crossprod(vclX), gpuR::crossprod(vclX, vcly))
})

detach("package:gpuR", unload = TRUE)

time1
time2
time3
time4
time5
