vqa <- function(x){
  type <- class(x)
  pmiss <- mean(is.na(x))
  nlvls <- length(unique(x))
  maxp <- argmaxp <- x1 <- px1 <- xn <- pxn <- med <- avg <- mrange <- mhinge <- NA
  if(pmiss<1){
    tmp <- prop.table(table(x))
    maxp <- max(tmp)
    if(sum(tmp==maxp)<=5L){
      argmaxp <- paste(names(tmp[tmp==maxp]),collapse=',')
    } else{
      argmaxp <- paste(paste(names(tmp[tmp==maxp])[1L:5L],collapse=','),',...',sep='')
    }        
    if(type %in% c('integer','numeric','complex','Date','POSIXct','ordered')){
      x1 <- names(tmp[1L])
      px1 <- unname(tmp[1L])
      xn <- names(tail(tmp,1L))
      pxn <- unname(tail(tmp,1L))
      med <- paste(names(which(cumsum(tmp)>=0.5 & rev(cumsum(rev(tmp)))>=0.5)),collapse=',')
    }
    if(type %in% c('integer','numeric','complex')){
      avg <- mean(x,na.rm=T)
      mrange <- mean(c(min(x,na.rm=T),max(x,na.rm=T)))
      mhinge <- mean(quantile(x,c(.25,.75),na.rm=T))
    }
  }
  vqa <- data.frame(type,pmiss,nlvls,maxp,argmaxp,x1,px1,xn,pxn,med,avg,mrange,mhinge,stringsAsFactors=F)
  names(vqa) <- c('type','pmiss','nlvls','maxp','argmaxp','x1','px1','xn','pxn','med','avg','mrange','mhinge')
  vqa
}

dqa <- function(dataset){
  stopifnot(is.data.frame(dataset))
  do.call('rbind',lapply(dataset,vqa))
}
