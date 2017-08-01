# Regression Data Sets Used #

### Load the Data Sets in R ###
For loading all the 20 regression data sets in R you need to issue the following command:

```r
load("AllDataSets.RData")
```

This will load into R an object named `DSs` which contains a list with 20 objects of class `dataset` from package DMwR.


### Data Sets Description ###
The main characteristics of the 18 regression data sets included in this folder are as follows:


| Data Set   | N    | t.total| p.nom | p.num | nRare | % Rare |
|------------|------|-------|-------|-------|-------|--------|
| servo      | 167  | 4     | 2     | 2     | 34    | 20.4  |
| a6         | 198  | 11    | 3     | 8     | 33    | 16.7  |
| Abalone    | 4177 | 8     | 1     | 7     | 679   | 16.3  |
| machineCpu | 209  | 6     | 0     | 6     | 34    | 16.3  |
| a3         | 198  | 11    | 3     | 8     | 32    | 16.2  |
| a4         | 198  | 11    | 3     | 8     | 31    | 15.7  |
| a1         | 198  | 11    | 3     | 8     | 28    | 14.1  |
| a7         | 198  | 11    | 3     | 8     | 27    | 13.6  |
| boston     | 506  | 13    | 0     | 13    | 65    | 12.8  |
| a2         | 198  | 11    | 3     | 8     | 22    | 11.1  |   
| a5         |198   | 11    | 3     | 8     | 21    | 10.6  |
| fuelCons   | 1764 | 38    | 12    | 26    | 164   | 9.3  |
| availPwr   | 1802 | 16    | 7     | 9     | 157   | 8.7  |
| cpuSm      | 8192 | 13    | 0     | 13    | 713   | 8.7  |
| maxTorq    |1802  | 33    | 13    | 20    | 129   | 7.2  |
| bank8FM    | 4499 | 9     | 0     | 9     | 288   | 6.4  |
| dAiler     | 7129 | 5     | 0     | 5     | 450   | 6.3  |
| ConcrStr   | 1030 | 8     | 0     | 8     | 55    | 5.3  |
| Accel      | 1732 | 15    | 3     | 12    | 89    | 5.1  |
| airfoild   | 1503 | 5     | 0     | 5     | 62    | 4.1  |


where, N is the number of examples in the data set, 
t.total is the total number of features, 
t.nom is the number of nominal features, 
t.num is the number of numeric features, 
nRare is the number of rare cases and 
%Rare is the percentage of rare cases in the data set.
