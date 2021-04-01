poolR2 <- function(x){
  
  n <- x$call1[[3]]
  r <- 1:n
  ar <- 1:n
  
  for (i in 1:n) {
    r[i] <-  summary(x$analyses[[i]])$r.squared
    ar[i] <- summary(x$analyses[[i]])$adj.r.squared
  }
  ave = mean(r)
  min = min(r)
  max = max(r)
  median = median(r)
  arave = mean(ar)
  armin = min(ar)
  armax = max(ar)
  armedian = median(ar)
  
  rresults <- data.frame(min, max, ave, median)
  arresults <- data.frame(armin, armax, arave, armedian)
  names(arresults)[1] <- "min"
  names(arresults)[2] <- "max"
  names(arresults)[3] <- "ave"
  names(arresults)[4] <- "median"
  returnlist <- list(r.squared = round(rresults, 3), adj.r.squared= round(arresults, 3))
  
  return(returnlist)
  
}