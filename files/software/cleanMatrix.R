cleanMatrix <- function(matrix, vars) {
  remove <- vars
  dropC <- colnames(matrix) %in% remove #removes from columns
  dropR <- rownames(matrix) %in% remove #removes from rows
  
  matrix[!dropR,!dropC]
}