##########################################################################
# Workflows
# define several workflows for applying the different resampling strategies for regression tasks
##########################################################################
WFnone <- function(form, train, test, learner, learner.pars){
  preds <- do.call(paste('cv', learner, sep='.'),
                   list(form, train, test, learner.pars))
  res <- list(trues=responseValues(form, test), preds=preds)
  return(res)
}


WFRandUnder <- function(form, train, test, learner, rel, thr.rel, C.perc, repl, learner.pars){
  newtr <- RandUnderRegress(form, train, rel, thr.rel, C.perc, repl)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}


WFGN <- function(form, train, test, learner, rel, thr.rel, C.perc, pert, repl,
                        learner.pars){
  newtr <- GaussNoiseRegress(form, train, rel, thr.rel, C.perc, pert, repl)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}

WFsmote <- function(form, train, test, learner, rel, thr.rel, C.perc, k, repl, dist, p, learner.pars){
  newtr <- SmoteRegress(form, train, rel, thr.rel, C.perc, k, repl, dist, p)
  preds <- do.call(paste('cv',learner,sep='.'),
                   list(form,newtr,test, learner.pars))
  res <- list(trues=responseValues(form,test),preds=preds)
  return(res)
}

WFDIBS <- function(form, train, test, learner, method, npts, control.pts,
                   thr.rel, C.perc, k, repl, dist, p, pert, learner.pars){
 newtr <- DIBSRegress(form, train, method, npts, control.pts, thr.rel,
                      C.perc, k, repl, dist, p, pert)
 preds <- do.call(paste('cv',learner,sep='.'),
                  list(form,newtr,test, learner.pars))
 res <- list(trues=responseValues(form,test),preds=preds)
 return(res)
}

# define the learn/test functions for the systems
cv.svm <- function(form,train,test,learner.pars) {
  cost <- learner.pars$cost
  gamma <- learner.pars$gamma
  m <- svm(form,train, cost=cost, gamma=gamma)
  predict(m,test)
}
cv.randomForest <- function(form,train,test,learner.pars) {
  mtry <- learner.pars$mtry
  ntree <- learner.pars$ntree
  m <- randomForest(form,train, ntree=ntree, mtry=mtry)
  predict(m,test)
}

cv.earth <- function(form,train,test,learner.pars) {
  nk <- learner.pars$nk
  degree <- learner.pars$degree
  thresh <- learner.pars$thresh
  m <- earth(form,train,nk=nk, degree=degree, thresh=thresh)
  predict(m,test)[,1]
}

cv.nnet <- function(form,train,test,learner.pars){
 size <- learner.pars$size 
 decay <- learner.pars$decay
 m <- nnet(form, train, size=size, decay=decay, linout=TRUE, trace=FALSE)
 predict(m, test)
}

# ============================================================
# EVALUATION STATISTICS
# metrics definition for the estimation task
# ============================================================

eval.stats <- function(trues, preds, train, metrics,
                       thr.rel, method,npts,control.pts,
                       ymin,ymax,tloss,epsilon,p) {
  pc <- list()
  pc$method <- method
  pc$npts <- npts
  pc$control.pts <- control.pts
  lossF.args <- list()
  lossF.args$ymin <- ymin
  lossF.args$ymax <- ymax
  lossF.args$tloss <- tloss
  lossF.args$epsilon <- epsilon
  
  MU <- util(preds, trues, pc, lossF.args, util.control(umetric="MU",p=0.5))
  NMU <- util(preds, trues, pc, lossF.args, util.control(umetric="NMU",p=0.5))
  ubaprec <- util(preds,trues,pc,lossF.args,util.control(umetric="P", event.thr=thr.rel, p=0.5))
  ubarec  <- util(preds,trues,pc,lossF.args,util.control(umetric="R", event.thr=thr.rel, p=0.5))
  ubaF1   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=1, event.thr=thr.rel, p=0.5))
  ubaF05   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=0.5, event.thr=thr.rel, p=0.5))
  ubaF2   <- util(preds,trues,pc,lossF.args,util.control(umetric="Fm",beta=2, event.thr=thr.rel, p=0.5))
  
  c(mad = mean(abs(trues-preds)),
    mse = mean((trues-preds)^2),
    mae_phi = mean(phi(trues,phi.parms=pc)*(abs(trues-preds))),
    mse_phi = mean(phi(trues,phi.parms=pc)*(trues-preds)^2),
    rmse_phi = sqrt(mean(phi(trues,phi.parms=pc)*(trues-preds)^2)),
    ubaF1 = ubaF1,
    ubaF05 = ubaF05,
    ubaF2 = ubaF2,
    ubaprec = ubaprec,
    ubarec = ubarec,
    MU = MU,
    NMU = NMU)
}
