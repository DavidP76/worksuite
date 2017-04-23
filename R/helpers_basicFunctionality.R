## helpers_basicFunctionality
## Functions for simple but commonplace manipulations

clean.values = function(x                           # target input
                        ,toClass = NULL             # reclass the vector
                        ,delNames = NULL            # remove names from vector
                        ,tableCols = NULL           # column names for table params
                        ){
  ## Cleans an input object, with defaults based on the class() of the input

  input.class = class(x)
  result = x

  ## Check to ensure input is a known type
  stopifnot(input.class %in% c("character", "vector", "table"))

  if(input.class == "character") {
    ## toClass - by default: keep as character
    if(is.null(toClass)) toClass = "character"
    stopifnot(toClass %in% c("character", "numeric"))

    ## delNames - by default: remove character names
    if(is.null(delNames)) delNames = TRUE
    stopifnot(delNames %in% c(FALSE, TRUE))

    if(delNames) names(result) = NULL
    if(toClass == "numeric") result = as.numeric(result)
  }

  if(input.class == "table") {
    ## toClass - by default: convert to freq table
    if(is.null(toClass)) toClass = "data.frame"
    stopifnot(toClass %in% c("table", "data.frame", "integer"))

    num.dims = length(attributes(x)$dim)
    if(is.null(tableCols)) tableCols = paste("col",seq(num.dims),sep=".")
    stopifnot(length(tableCols) == num.dims)

    if(toClass == "table") result = result

    if(toClass == "integer") {
      stopifnot(num.dims == 1)
      result = c(result)
    }

    if(toClass == "data.frame") {
      result = as.data.frame(result)
      colnames(result) = c(tableCols, "Num")
      result$Freq = result$Num/sum(result$Num)
    }
  }

  else {
    browser()
  }

  result
}
