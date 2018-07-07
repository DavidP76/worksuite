execute <- function(expr = NULL, script = NULL
                    ,logger.settings = list(log = TRUE
                                            ,path.home = ".")) {
  
  ## check for valid expression or script to execute
  if(missing(expr) && missing(script)) stop("Execute requires a single 'expr' or 'script' argument")
  if(!missing(expr) && !missing(script)) stop("Execute requires a single 'expr' or 'script' argument")
  execute.class <- ifelse(missing(expr), "script", "expr")
  
  if(execute.class == "script") {
    rm(expr)
    ## extract strings to describe the script (for logging purposes)
    script <- try(normalizePath(script, mustWork = TRUE), silent = TRUE)
    if(class(script) == "try-error") stop("The system cannot find the file specified")
    
    execute.desc <- gsub(".*\\\\", "", script)
    execute.script.ext <- tools::file_ext(execute.desc)
    if(!execute.script.ext %in% c("txt", "R")) stop("Execute requires script filename ending in *.R or *.txt")
    execute.title <- gsub(paste(".", execute.script.ext, sep = ""),"", execute.desc, fixed = TRUE)
    rm(execute.script.ext)
  }
  
  if(execute.class == "expr") {
    rm(script)
    ## extract strings to describe the expression (for logging purposes)
    expr <- as.list(match.call())$expr
    execute.desc <- deparse(expr)
    execute.title <- deparse(as.list(expr)[[1]])
    
    if(length(grep("[:alpha:]", execute.title)) == 0) execute.title <- "expr"
    if(execute.title == "") stop("Execute expression title is resulting in missing string")
    if(length(grep("[\\<\\>\\:\\\"\\/\\|\\?\\*\\]", execute.title)) > 0) stop("Execute expression title is resulting in invalid character")
  }
  
  cat(paste("Executing controlled "
            ,switch(execute.class, expr = "expression", script = "script")
            ,": "
            ,execute.desc
            ,"\n"
            ,sep = ""))

  initial.wd <- getwd()
  
  ## Execute the given script
  if(execute.class == "script") {
    result <- FALSE
    source(script)
    result <- TRUE
  }
  
  ## Execute the given expression
  if(execute.class == "expr") {
    result <- eval(expr)
  }
  
  setwd(initial.wd)
  
  cat("\n")
  
  if(execute.class == "script") invisible(result)
  if(execute.class == "expr") return(result)
}