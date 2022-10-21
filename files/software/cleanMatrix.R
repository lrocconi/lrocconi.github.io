dropMatrix <- function(matrix, vars) {
  remove <- vars
  dropC <- colnames(matrix) %in% remove #removes from columns
  dropR <- rownames(matrix) %in% remove #removes from rows
  
  matrix[!dropR,!dropC]
}

keepMatrix <- function(matrix, vars) {
  keep <- vars
  keepC <- colnames(matrix) %in% keep #columns
  keepR <- rownames(matrix) %in% keep #rows
  
  matrix[keepR,keepC]
}