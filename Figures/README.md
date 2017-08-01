## Figures 

This folder includes all the figures presented in the paper. It also includes some extra figures that were not included in the paper due to space costraints. All the figures represent the results of the paired comparison between the each resampling strategy and the baseline under consideration using the non-parametric **Wilcoxon paired test** for a significance level of 95\%. This folder is organized as follows:


* **F1** - contains all the figures regarding the $F_1^\phi$ metric;
* **precision** - contains all the figures regarding the $prec^\phi$ metric;
* **recall** - contains all the figures regarding the $rec^\phi$ metric.


Inside each of the previous folders you will have the following folder structure:

* **Global** - contains, for the metric selected, the aggregated results of all learners against each of the baseline considered (either no sampling, introduction of Gaussian Noise or SmoteR); 
* **NNET** - contains the results, for the metric selected, of the NNET learners against each of the baseline considered (either no sampling, introduction of Gaussian Noise or SmoteR);
* **SVM** - contains the results, for the metric selected, of the SVM learners against each of the baseline considered (either no sampling, introduction of Gaussian Noise or SmoteR);
* **RF** - contains the results, for the metric selected, of the randomForest learners against each of the baseline considered (either no sampling, introduction of Gaussian Noise or SmoteR);
* **MARS** - contains the results, for the metric selected, of the MARS learners against each of the baseline considered (either no sampling, introduction of Gaussian Noise or SmoteR);


