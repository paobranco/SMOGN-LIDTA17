## Reproducing the Paper Experiments

## Contents

  This folder contains  all code that is necessary to replicate the
  experiments reported in the paper *"SMOGN: a Pre-processing Approach for Imbalanced Regression"*[1]. 

  The folder contains the following files:

  - **DIBSRegress.R** the code implementing the SMOGN strategy for regression

  - **ExpsDIBS.R** the script for obtaining the results for the different workflows (baseline with no sampling, smoteR, random under-sampling and the proposed SMOGN variant)

  - **EstTasks.R** the script with auxiliary functions for defining the estimation tasks
  
  - **Auxs.R** the script with auxiliary functions for defining the workflows and the evaluation procedure

  - **README.md** this file

## Necessary Software

To replicate these experiments you will need a working installation
  of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - e1071
  - randomForest
  - earth
  - nnet
  - DMwR
  - performanceEstimation
  - UBL
  - uba

  All the above packages with exception of uba, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("DMwR", "performanceEstimation", UBL", "e1071", "randomForest", "earth", "nnet"))
```

Additionally, you will need to install uba package from a tar.gz file that you can download from [http://www.dcc.fc.up.pt/~rpribeiro/uba/]. 

For installing this package issue the following command within R:
```r
install.packages("uba_0.7.7.tar.gz",repos=NULL,dependencies=T)
```

To replicate the figures in this repository you will also need to install the package:

  - ggplot2

As with any R package, we only need to issue the following command:

```r
install.packages("ggplot2")
```


## Running the experiences:

  Before running the experiments you need to load the data sets used in R. To obtain the 20 regression data sets and to see how you can load them, please check the README.md file in the **Data** folder. After having the necessary data sets, to run the experiments described in the paper you execute R in the folder with the code and then issue the command:
```r
source("ExpsDIBS.R")
```

Alternatively, you may run the experiments directly from a Linux terminal
  (useful if you want to logout because some experiments take a long
  time to run):

```bash
nohup R --vanilla --quiet < ExpsDIBS.R &
```

## Running a subset of the experiences:

  Given that the experiments take  long time to run, you may be interested in running only a partial set of experiments. To do this you must edit the ExpsDIBS.R file. 
  
  Lets say, for instance, that you want to run all the workflows in only one data set. To do this you can change the instruction *for(d in 1:20)* in line 113 of ExpsDIBS.R file. If the data set that you select is the fifth, the you need to change this instruction to *for(d in 5)*.
  
  You can also change the number and/or the values of the learning algorithms parameters. To achieve this edit the *WFs* list in lines 101 to 104. For instance, if you only want to run the experiments for the svm learner but with more values for the cost parameter, you should comment the lines with the other learners (randomForest, earth and nnet) and add the values you want in the cost. Lines 101 to 104 could be changed as follows:
  
```r

WFs$svm <- list(learner.pars=list(cost=c(10, 50, 100, 150, 200, 300), gamma=c(0.01,0.001)))
# WFs$randomForest <- list(learner.pars=list(mtry=c(5,7),ntree=c(500,750,1500)))
# WFs$earth <- list(learner.pars=list(nk=c(10,17),degree=c(1,2),thresh=c(0.01,0.001)))
# WFs$nnet <- list(learner.pars=list(size=c(1,2,5,10), decay=c(0, 0.01)))

```

  
  After making all the necessary changes run the experiments as previously explained.

### References
[1] Branco, P. and Torgo, L. and Ribeiro R.P. (2017) *"SMOGN: a Pre-processing Approach for Imbalanced Regression"*  Procedings of Machine Learning Research, LIDTA 2017, Full Paper, Skopje, Macedonia. (to appear).