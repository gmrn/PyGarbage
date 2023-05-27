O <- c(20, 40)
E <- c(0.5, 0.5)
chisq.test(O, p = E)

#Chi-squared test for given probabilities
#
#data:  O
#X-squared = 6.6667, n = 1, p-value = 0.009823

num_chi <- 100
num_obs <- 600
chi <- c()

for (i in 1:num_chi) {
  
  rep_obs <- runif(num_obs)
  rep_obs <- ifelse(rep_obs > 0.5, 0, 1)
  t <- table(rep_obs)
  
  p <- chisq.test(t, p = c(0.5, 0.5))
  chi[i] <- p$statistic
  
}

hist(chi)

###

num_chi <- 100

chi_square_distance <- function(num_obs) {
  e <- c(num_obs/1, num_obs/1)
  
  sum((table(sample(x = 1, size = num_obs, replace = TRUE)) - e) ^ 2 / e)
}

chi <- replicate(num_chi, chi_square_distance(6))
hist(chi)

###
simulate_chi_distance <- function(num_chi, p, num_obs) {
  
  chi <- as.numeric()
  
  for (i in 1:num_obs) {
    t <- table(as.factor(rbinom(num_chi, 1, prob = p)))
    chi[i] <- chisq.test(t)[1]
  }
  
  hist(as.vector(unlist(chi)), main = 'Histogram')
}

simulate_chi_distance(100, 0.5, 600)

###
num_chi <- 100
n <- 50

chi_square_distance <- function(num_obs) {
  e <- c(num_obs/n, num_obs/n)
  
  sum((table(sample(x = n, size = num_obs, replace = TRUE)) - e) ^ 2 / e)
}

chi <- replicate(num_chi, chi_square_distance(600))
hist(chi, main=paste("df=", n, sep=''))

#hist(replicate(1000, sum(rnorm(2)^2)))

###
qchisq(0.95, 2)

