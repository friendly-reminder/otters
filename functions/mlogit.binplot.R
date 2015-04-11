 mlogit.binplot<- function(dataset,resp=ncol(dataset),nbins=20L,pause=T){
  stopifnot(is.data.frame(dataset),resp %in% 1L:ncol(dataset),nbins%%1==0,is.factor(dataset[[resp]]),is.logical(pause))
  y <- dataset[[resp]]
  dataset <- dataset[-resp]
  k <- ncol(dataset)
  nlvls <- nlevels(y)
  for(i in 1L:k){
    x <- dataset[[i]]
    xlab <- names(dataset)[i]
    breaks <- unique(quantile(x,probs=seq(from=0,to=1,length.out=(nbins+1L))))
    bins <- cut(x,breaks,ordered_result=T,right=F,include.lowest=T)
    x <- tapply(x,bins,median)
    n.tbl <- table(bins,y)
    p.tbl <- prop.table(n.tbl,1)
    logit.tbl <- log(p.tbl/(1-p.tbl))
    for(j in 1L:nlvls){
      plot(x,logit.tbl[,j],xlab=xlab,ylab=paste('logit(',levels(y)[j],')',sep=''),type='b')
    }
    if(pause){
      readline(prompt=paste(xlab,', set ',i,' of ',k,'. Press enter to continue ... ',sep='')) 
    }
  }
}