[![Build Status](https://travis-ci.org/MarkusLoew/MyDistOrd.svg?branch=master)](https://travis-ci.org/MarkusLoew/MyDistOrd)



MyDistOrd
==============

R-package to re-order an additive relationship matrix (created by, for example, *sommer::A.mat()*) following the algorithm used in *stats::heatmap()* but without the overhead of creating a figure. Benefit over *heatmap()* is that it will handle large matrices.  
Was tested with a additive relationship matrix created by *sommer::A.mat()* only. Feedback appreciated in case there are issues with other functions.

See 

	help(package = "MyDistOrd") 

for details on the function provided by this package.

### Installation

To install this package straight from github, the "devtools" package is needed:

```r
install.packages("devtools")
```

Then, package installation via

```{r}
devtools::install_github("MarkusLoew/MyDistOrd")
```

Installation under Windows might require the installation of Rtools. There will be a prompt for it if needed.

### Example usage  
#### shows that this function results in the same ordering as heatmap()  

```{r}
require(sommer) # to create an additive relationship matrix

## create an example matrix
x <- matrix(rnorm(50), 10, 10, 
           dimnames = list(paste("a", 1:10, sep=""), 
           paste("b", 1:10, sep=""))) 

## convert to additive relationship matrix
x <- sommer::A.mat(x)

# do the ordering via heatmap()
hv <- heatmap(x)
heatmap.sorted <- x[rev(hv$rowInd), rev(hv$colInd)]

# now the ordering via MyDistOrd()
sorted <- MyDistOrd(x)

## to show that the result of heatmap() and this function are the same
heatmap.sorted == sorted
```
