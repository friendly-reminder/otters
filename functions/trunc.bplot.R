trunc.bplot <- function(dataset,p=1,pause=T){
  stopifnot(is.data.frame(dataset),0<p & p<=1,is.logical(pause))
  k <- ncol(dataset)
  for(i in 1L:k){
    x <- dataset[[i]]
    main <- names(dataset)[i]
    tbl <- prop.table(table(x))
    if(inherits(x,c('integer','numeric','complex','Date','POSIXct','ordered'))){
      lt.p <- cumsum(tbl)<p
      if(sum(!lt.p)>1L){
        tbl.names <- c(names(tbl)[lt.p],paste(names(tbl[!lt.p])[1L],'+',sep=''))
        tbl <- as.table(c(tbl[lt.p],sum(tbl[!lt.p])))
        names(tbl) <- tbl.names
      }
    }
    plot(tbl,ylab='',main=paste('Probability Distribution of ',main,sep=''),xlab='')
    if(pause){
      readline(prompt=paste(main,', plot ',i,' of ',k,'. Press enter to continue ... ',sep=''))
    }
  }
}