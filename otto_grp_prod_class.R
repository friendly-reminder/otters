##################
##Set up workspace
##################
setwd('C:/Users/Jaime/Desktop/Kaggle/Otto Group Prduct Classifcation Challenge')

###################
##Get train dataset
###################
train <- read.table(file='./data/train.csv',header=T,sep=',',na.string='',quote='\"')

#############################
##Run a data quality analysis
#############################
source('./functions/dqa.R')
train.dqa <- dqa(train)
print(train.dqa,digits=2)

##Dropping first row of IDs (just row number, non-informative, recoverable)
train <- train[,-1L]
train.dqa <- train.dqa[-1L,]
print(train.dqa,digits=2)

sink(file='./outputs/data quality analysis.txt')
cat('Data Quality Analysis\n\n')
print(train.dqa,digits=2)
sink()

#############################
##Run a univariate analysis
#############################
##All variable seem discrete, run barplots truncated at the 0.999 quantile
source('./functions/trunc.bplot.R')

pdf(file='./plots/empirical pmf.pdf',height=8.5,width=11)
trunc.bplot(train,p=.999,pause=F)
dev.off()

#####################################################
##Run a bivariate analysis of response vs. predictors
#####################################################
##Response is 9-level nominal, get log(odds) vs. binned predictors plots
source('./functions/mlogit.binplot.R')

pdf(file='./plots/logits vs binned feats.pdf',height=8.5,width=11)
par(mfrow=c(3L,3L),oma=c(0,0,0,0),mar=c(4,4,1,1))
mlogit.binplot(train,resp=which(names(train)=='target'),nbins=20L,pause=F)
dev.off()

############################################
##Set train data for k-fold cross validation
############################################
source('./functions/set.kfold.xval.R')
#10-fold cross validation
train.xval <- set.kfold.xval(train,k=10L,block=which(names(train)=='target'))

sink(file='./outputs/cross validation layout.txt')
cat('Cross Validation Layout\n\n')
with(train.xval,table(xval.fold,target,useNA='ifany'))
sink()

##############################################
##Save train data with cross validation labels
##############################################
save(train.xval,file='./data/train.xval.Rdata')
rm(list=ls())

#####################
##Load checkpoint
#####################
load('./data/train.xval.Rdata')

###################
##Get loss function
###################
source('./functions/logloss.R')

####################
##Uniform Allocation
####################
source('./methods/unif.alloc.R')
unif.alloc.fit <- unif.alloc(train.xval,resp=which(names(train.xval)=='target'))
attributes(unif.alloc.fit)
