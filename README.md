## SMOGN: a Pre-processing Approach for Imbalanced Regression - LIDTA 2017

This repository has all the code used in the experiments carried out in the paper *"SMOGN: a Pre-processing Approach for Imbalanced Regression"* [1].


This repository is organized as follows:

* **R_Code** folder - contains all the code for reproducing the experiments described in the paper;
* **Figures** folder - contains all the figures obtained from the experimental evaluation on 20 real world data sets;
* **Data** folder - contains the 20 regression data sets used in the experiments carried out;


### Requirements

The experimental design was implemented in R language. Both code and data are in a format suitable for R environment.

In order to replicate these experiments you will need a working installation
  of R. Check [https://www.r-project.org/] if you need to download and install it.

In your R installation you also need to install the following additional R packages:

  - DMwR
  - performanceEstimation
  - UBL
  - uba
  - e1071
  - randomForest
  - earth
  - nnet


  All the above packages, with the exception of uba package, can be installed from CRAN Repository directly as any "normal" R package. Essentially you need to issue the following command within R:

```r
install.packages(c("DMwR", "performanceEstimation", UBL", "e1071", "randomForest", "earth", "nnet"))
```

Additionally, you will need to install uba package from a tar.gz file that you can download from [http://www.dcc.fc.up.pt/~rpribeiro/uba/]. 

For installing this package issue the following command within R:
```r
install.packages("uba_0.7.7.tar.gz",repos=NULL,dependencies=T)
```


To replicate the figure in this repository you will also need to install the package:

  - ggplot2

As with any R package, we only need to issue the following command:

```r
install.packages("ggplot2")
```

Check the other README files in each folder to see more detailed instructions on how to run the experiments.

*****

### References
[1] Branco, P. and Torgo, L. and Ribeiro R.P. (2017) *"SMOGN: a Pre-processing Approach for Imbalanced Regression"*  Procedings of Machine Learning Research, LIDTA 2017, Full Paper, Skopje, Macedonia. (to appear).
