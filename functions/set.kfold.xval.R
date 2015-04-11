set.kfold.xval <- function(dataset,k=10L,block=ncol(dataset)){
  stopifnot(is.data.frame(dataset),block %in% 1L:ncol(dataset),k%%1==0,is.factor(dataset[[block]]))
  y <- dataset[[block]]
  dataset <- cbind(xval.fold=NA,dataset)
  for(i in levels(y)){
    n <- sum(y==i)
    dataset[y==i,'xval.fold'] <- sample(rep(sample(1L:k),ceiling(n/k))[1L:n])
  }    
  dataset$xval.fold <- as.factor(dataset$xval.fold)
  dataset
}
