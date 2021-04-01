# Monte Carlo Confidence Intervals for Indirect Effects by Louis M. Rocconi (2021). Based on Darlington & Hayes (2017, p. 463) sample syntax for Stata. 

mcci <- function(b1, se1, b2, se2, seed = 1234, digits = 4) {
  
  set.seed(seed)
  b1 <- rnorm(5000, 0, se1) + b1
  b2 <- rnorm(5000, 0, se2) + b2
  b3 <- b1*b2
  CI <- quantile(b3, probs = c(.025, .975))
  return(round(CI, digits))
  
}
