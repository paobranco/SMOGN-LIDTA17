
library(e1071)                 # where the svm is
library(performanceEstimation) # exps framework
library(randomForest)          # randomForest
library(earth)                 # MARS reimplementation
library(UBL)                   # smoteR
library(uba)                   # utility-based evaluation framework
library(nnet)                  # neural networks

source("Auxs.R")
source("DIBSRegress.R")
##############################################################
# THE USED DATA SETS
# ============================================================
load("AllDataSets.RData")
#########################################################################
# to generate information about the data sets for a given threshold
#########################################################################
PCSall <- list()

for(d in 1:20)
{
  y <- resp(DSs[[d]]@formula,DSs[[d]]@data)
  pc <- phi.control(y, method="extremes")
  lossF.args <- loss.control(y)
  PCSall[[d]] <- list(pc, lossF.args)
}

thr.rel <- 0.8
for(d in 1:20){
  form <- DSs[[d]]@formula
  data <- DSs[[d]]@data
  y <- resp(form,data)
  pc <- list()
  pc$method <- PCSall[[d]][[1]][[1]]
  pc$npts <- PCSall[[d]][[1]][[2]]
  pc$control.pts <- PCSall[[d]][[1]][[3]]
  both <- all(pc$control.pts[c(2,8)] == c(1,1))
  y.relev <- phi(y,pc)
  total <- 0
  if (both) {  # we have both low and high extrs
    rare.low <- which(y.relev > thr.rel & y < pc$control.pts[4])
    rare.high <- which(y.relev > thr.rel & y > pc$control.pts[4])
    rare.cases <- c(rare.low,rare.high)
    total <- length(rare.cases)
  } else {
    # the indexes of the cases with rare target variable values
    rare.cases <- if (pc$control.pts[2] == 1)  which(y.relev > thr.rel & y < pc$control.pts[4]) else which(y.relev > thr.rel & y > pc$control.pts[4])
    total <- length(rare.cases)
    
  }
  
  if(both){
    b <- 2
  }else {b <- 1 } 
  #  cat("index: ", d, " Data: ", DSs[[d]]@name," both: ",both,"\n")
  #cat("Data:",  DSs[[d]]@name, "nr rare: ", total,  "  perc.Rare: ", round(total/length(y),3), "\n")
}

# data set 4 and 6 (a4 and a6) have a bad formed control.pts entry which must be corrected

PCSall[[4]][[1]][[2]] <- 2
PCSall[[6]][[1]][[2]] <- 2

PCSall[[4]][[1]][[3]] <- PCSall[[4]][[1]][[3]][4:9]
PCSall[[6]][[1]][[3]] <- PCSall[[6]][[1]][[3]][4:9]


PCS <- list(PCSall[[1]], PCSall[[2]],PCSall[[3]], PCSall[[4]],PCSall[[5]],
            PCSall[[6]],PCSall[[7]],PCSall[[8]], PCSall[[9]], PCSall[[10]], 
            PCSall[[11]], PCSall[[12]], PCSall[[13]], PCSall[[14]], PCSall[[15]],
            PCSall[[16]], PCSall[[17]], PCSall[[18]], PCSall[[19]], PCSall[[20]])

myDSs <- list(PredTask(a1~., DSs[[1]]@data, "a1"), PredTask(a2~., DSs[[2]]@data, "a2"),
              PredTask(a3~., DSs[[3]]@data, "a3"), PredTask(a4~., DSs[[4]]@data, "a4"),
              PredTask(a5~., DSs[[5]]@data, "a5"),
              PredTask(a6~., DSs[[6]]@data, "a6"), PredTask(a7~., DSs[[7]]@data, "a7"),
              PredTask(Rings~., DSs[[8]]@data, "Abalone"),
              PredTask(acceleration~., DSs[[9]]@data, "acceleration"),
              PredTask(available.power~., DSs[[10]]@data, "availPwr"),
              PredTask(rej~., DSs[[11]]@data, "bank8FM"), 
              PredTask(usr~., DSs[[12]]@data, "cpuSm"),
              PredTask(fuel.consumption.country~., DSs[[13]]@data, "fuelCons"),
              PredTask(HousValue~., DSs[[14]]@data, "boston"),
              PredTask(maximal.torque~.,DSs[[15]]@data, "maxTorque"),
              PredTask(class~.,DSs[[16]]@data, "machineCpu"),
              PredTask(class~.,DSs[[17]]@data, "servo"),
              PredTask(ScaledSoundPressure~.,DSs[[18]]@data, "airfoild"),
              PredTask(ConcreteCompressiveStrength~.,DSs[[19]]@data, "concreteStrength"),
              PredTask(Sa~.,DSs[[20]]@data, "dAiler")
)

# weight for penalizing FP ot FN
#p <- 0.5
##########################################################################
# learners and estimation procedure
##########################################################################

WFs <- list()

WFs$svm <- list(learner.pars=list(cost=c(10,150,300), gamma=c(0.01,0.001)))
WFs$randomForest <- list(learner.pars=list(mtry=c(5,7),ntree=c(500,750,1500)))
WFs$earth <- list(learner.pars=list(nk=c(10,17),degree=c(1,2),thresh=c(0.01,0.001)))
WFs$nnet <- list(learner.pars=list(size=c(1,2,5,10), decay=c(0, 0.01)))

# exps with 2 times 10 fold CV

source("EstTasks.R")
##########################################################################
# exps
##########################################################################

for(d in 1:20){
  for(w in names(WFs)) {
    resObj <- paste(myDSs[[d]]@taskName,w,'Res',sep='')
    assign(resObj,
           try(
             performanceEstimation(
               myDSs[d],         
               c(
                 do.call('workflowVariants',
                         c(list('WFnone', learner=w),
                           WFs[[w]],
                           varsRootName=paste('WFnone',w,sep='.')
                         )),
                 do.call('workflowVariants',
                         c(list('WFRandUnder',learner=w,
                                rel=matrix(PCS[[d]][[1]][[3]], nrow=3, ncol=3, byrow=TRUE),
                                thr.rel=thr.rel,
                                C.perc="balance",
                                repl=FALSE),
                           WFs[[w]],
                           varsRootName=paste('WFRandUnder',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFGN',learner=w,
                                rel=matrix(PCS[[d]][[1]][[3]], nrow=3, ncol=3, byrow=TRUE),
                                thr.rel=thr.rel,
                                C.perc="balance",pert=0.01,
                                repl = TRUE),
                           WFs[[w]],
                           varsRootName=paste('WFGN',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFsmote',learner=w,
                                rel=matrix(PCS[[d]][[1]][[3]], nrow=3, ncol=3, byrow=TRUE),
                                thr.rel=thr.rel,
                                C.perc="balance",
                                k=5, repl=FALSE,
                                dist="HEOM", p=2),
                           WFs[[w]],
                           varsRootName=paste('WFsmote',w,sep='.'),
                           as.is="rel"
                         )),
                 do.call('workflowVariants',
                         c(list('WFDIBS',learner=w,
                                method=PCSall[[d]][[1]][[1]],
                                npts=PCSall[[d]][[1]][[2]],
                                control.pts=PCSall[[d]][[1]][[3]],
                                thr.rel=thr.rel,
                                C.perc="balance",
                                k=5, repl=FALSE,
                                dist="HEOM", p=2, pert=0.01),
                           WFs[[w]],
                           varsRootName=paste('WFDIBS',w,sep='.'),
                           as.is="control.pts"
                         ))
               ),
               CVsetts[[d]])
           )
    )
    if (class(get(resObj)) != 'try-error') save(list=resObj,file=paste(myDSs[[d]]@taskName,w,'Rdata',sep='.'))
  }
}


