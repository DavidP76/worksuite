## helpers_basicFunctionality
## Functions for simple but commonplace manipulations

clean_values = function(x                           # target input
                        ,toClass = NULL             # reclass the vector
                        ,delNames = NULL            # remove names from vector
                        ,tableCols = NULL           # column names for table params
                        ){
  ## Cleans an input object, with defaults based on the class() of the input

  input.class = class(x)
  result = x

  ## Check to ensure input is a known type
  stopifnot(input.class %in% c("character", "factor", "table"))

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

  else if(input.class == "factor") {
    ## toClass - by default: convert to character
    if(is.null(toClass)) toClass = "character"
    stopifnot(toClass %in% c("factor", "character", "integer"))
    
    if(toClass == "character") result = as.character(result)
    if(toClass == "integer") result = as.numeric(result)
  }
  
  else if(input.class == "table") {
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

norm_path = function(x) {
  if(x == "") x = "."
  result = tryCatch(normalizePath(x, winslash = "/")
                    ,warning = function(w) {
                      file.name = strsplit(x, split = c("/", "\\"), fixed = TRUE)[[1]]
                      file.name = file.name[length(file.name)]
                      
                      if(length(w$message) == 1 & grep("The system cannot find the file specified", w$message) == 1) {
                        stop(paste("Cannot find path for '"
                                   ,file.name
                                   ,"'"
                                   ,sep = "")
                             ,call. = FALSE)
                      } else { browser() }
                    })
  return(result)  
}