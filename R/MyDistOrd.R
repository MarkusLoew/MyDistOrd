#' Function to re-order an additive relationship matrix (created by, for example, *sommer::A.mat()*) following the algorithm in *heatmap()*.
#'
#' @param x Symmetric additive relationship matrix (as created by, for example \code{sommer::A.mat}). Function was tested with a additive relationship matrix created by \code{sommer::A.mat()} only. No guarantee on compatibility with other functions.
#' @param parallel Optional use of \code{amap::Dist} and \code{amap::hcluster} for parallel processing. However, testing showed that using this, makes the calculation actually slower. Defaults to FALSE. Not available on Windows OS.
#' @return Provides the sorted matrix.
#' @export
#' @examples
#' require(sommer)
#' x <- matrix(rnorm(50), 10, 10, 
#'            dimnames = list(paste("g", 1:10, sep=""), 
#'                            paste("t", 1:10, sep=""))) 
#' ## convert to additive relationship matrix
#' x <- sommer::A.mat(x)
#' hv <- heatmap(x)
#' heatmap.sorted <- x[rev(hv$rowInd), rev(hv$colInd)]
#' sorted <- MyDistOrd(x)
#' ## to show that the result of heatmap() and this function are the same
#' heatmap.sorted == sorted
#' identical(heatmap.sorted, sorted)

MyDistOrd <- function(x, parallel = FALSE) {
  # Markus Loew, Aug 25, 2017
  # only works for a symmetric matrix - see comment below
    
  stopifnot(class(x) == "matrix")
  stopifnot(nrow(x) == ncol(x))

  Rowv   <- rowMeans(x, na.rm = TRUE)
  if (parallel) {
    # parallel processing makes it actually slower!
    hcr    <- amap::hcluster(amap::Dist(x, nbproc = 4), method = "maximum", 
                                                        nbproc = 4,
                                                        doubleprecision = FALSE)
  } else {
    hcr    <- stats::hclust(stats::dist(x))
  }
  ddr    <- stats::as.dendrogram(hcr)
  ddr    <- stats::reorder(ddr, Rowv)
  rowInd <- stats::order.dendrogram(ddr)

  # columns (A needs to be symmetric!)
  # this whole bit is pretty much redundant, as the sorting only works
  # when x is symmetric - still here for comparison with heatmap()
  Colv   <- Rowv  # see Colv = if (symm) "Rowv" else NULL in heatmap
  #hcc    <- stats::hclust(stats::dist(x))
  #hcc    <- hcr
  #ddc    <- stats::as.dendrogram(hcc)
  #ddc    <- ddr
  #ddc    <- stats::reorder(ddc, Colv)
  # colInd <- stats::order.dendrogram(ddc)
  colInd <- rowInd

  # sort
  my.sorted <- x[rev(rowInd), rev(colInd)]
  return(my.sorted)
}
