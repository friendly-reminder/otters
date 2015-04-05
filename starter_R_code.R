##Set up workspace
setwd('C:\\Users\\Jaime\\Desktop\\Kaggle\\Product Class')

##Get train and test datasets. Combine them for simpler scoring. Assume random sets
train <- read.table(file='train.csv',header=T,sep=',',na.string='',quote='\"')
test <- read.table(file='test.csv',header=T,sep=',',na.string='',quote='\"')
full <- rbind(train,data.frame(test,target=NA))

##Check data types, missingness, and unique levels
intro.tbl <- data.frame(
  type=unlist(lapply(full,class))
  ,nmiss=unlist(lapply(full,function(x) sum(is.na(x))))
  ,levels=unlist(lapply(full,function(x) length(unique(x))))
)
intro.tbl

##Drop ID (just row number in each dataset, non-informative, recoverable)
full <- full[-1L]

##All variable seem discrete, get frequency distributions
freq.dist.lst <- lapply(full,table)

##Store probability distribution charts in pdf, for visual inspection
pdf('raw_p_dist.pdf')

k <- length(freq.dist.lst)
for(i in 1L:k){
  main <- names(freq.dist.lst)[i]
  t1 <- prop.table(freq.dist.lst[[i]])
  subs <- cumsum(t1)<.9999
  plot(as.table(t1[subs]),ylab='',main=paste('Distribution of ',main,sep=''))  
}

dev.off()

##Assume count data, get descriptive statistics
class_stats <- array(dim=c(k-1L,nlevels(full[[k]]),4L),dimnames=list(names(full)[-k],levels(full[[k]]),c('mean','var','min','max')))
for(i in levels(full[[k]])){
  subs <- full[[k]] %in% i
  class_stats[,i,] <- matrix(unlist(lapply(full[subs,-k],function(x) c(mean(x),var(x),min(x),max(x)))),nrow=k-1L,byrow=T)
}

round(class_stats,2L)

