# Function to calculate Relative Efficiency
# formula 10.4 Heymans, M. W. (2019). Applied Missing Data Analysis with SPSS and (R)Studio. 
# https://bookdown.org/mwheymans/bookmi/measures-of-missing-data-information.html
RE <- function(x) {
  
  fmi <- x$pooled[,11]
  var <- x$pooled[,1]
  dat <- data.frame(var, fmi)
  dat$re <- (1/(1+(dat$fmi/x$m)))
  print(dat[,c(1,3)])
}