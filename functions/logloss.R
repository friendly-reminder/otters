logloss <- function(y,p){
  p[p<10L^(-15L)] <- 10L^(-15L)
  n <- nrow(y)
  loss.mat <- -y*log(p)
  avg.logloss <- sum(loss.mat)/n
  list(avg.logloss=avg.logloss,n=n,loss.mat=loss.mat)
}