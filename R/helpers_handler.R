## helpers_handler.R
## Scripts for handling common scripting challenges

localize <- function(tag = NULL) {
  ## Provides parameter information, depending on computer and account
  
  result = list()
  
  ## Check that computer and account is in a known set
  known.accounts = rbind(data.frame(computer.name = "ELSPHIL-7006805" , account.name = "PHILLIPSD")     ## DP Elsevier Dell
                         ,data.frame(computer.name = "DESKTOP-12K9V71", account.name = "LEIGHD")        ## LD Personal ASUS
  )
  
  computer.name = toupper(clean_values(Sys.info()["nodename"]))
  account.name = toupper(clean_values(Sys.info()["user"]))
  
  if(!any(account.name == known.accounts$account.name & computer.name == known.accounts$computer.name)) {
    stop("Unable to localize: unknown computer/account")
  }
  
  ## Load parameter files located on target machines
  ## These files must be saved as CSV, with first row as {Field.Name, Field.Type, Field.Value}
  ## Fields that contain filenames should be of the format "C:/EXAMPLE.csv" to refer to an absolute path or "./EXAMPLE.csv" for a path relative to the parameter file
  
  parameter.files = rbind(
    data.frame(computer.name = "DESKTOP-12K9V71", account.name = "LEIGHD", file.name = "Parameters.csv", file.path = "C:/Users/leighd/Documents/David Sabbatical/R Projects")
  )
  
  load.parameter.files = function(locs) {
    ## Function to read the CSV files
    
    result = list()
    
    ## Input locs can be nonexistant for this computer
    if(nrow(locs) == 0) { return(result) }
    
    for(i in seq(nrow(locs))) {
      file.name = clean_values(locs[i, "file.name"])
      file.path = clean_values(locs[i, "file.path"])
      
      if(!file.exists(paste(file.path, file.name, sep = "/"))) {
        file.path.name = strsplit(file.path, split = "/")[[1]]
        file.path.name = file.path.name[length(file.path.name)]
        stop(paste("File '", file.name, "' required in folder '", file.path.name, "'", sep = ""))
      }
      
      x = read.csv(paste(file.path, file.name, sep = "/")
                   ,header = TRUE
                   ,row.names = NULL
                   ,stringsAsFactors = FALSE)
      
      if(nrow(x) > 0) {
        if(any(duplicated(x$Field.Name))) { stop("Duplicated parameters found") }
        
        x$Field.Value = gsub(pattern = "./"
                             ,replacement = paste(file.path, "/", sep = "")
                             ,x = x$Field.Value
                             ,fixed = TRUE)
        
        result.i = list()
        for(j in seq(nrow(x))) {
          result.i[[x[j, "Field.Name"]]] = clean_values(x[j, "Field.Value"], toClass = x[j, "Field.Type"])
        }
        
        if(any(names(result.i) %in% names(result))) { stop("Duplicated parameters found") }
        result = c(result, result.i)
      }
    }
    
    return(result)
  } 
  
  results = load.parameter.files(parameter.files[parameter.files$computer.name == computer.name
                                                 & parameter.files$account.name == account.name,])
  
  if(!is.null(tag)) {
    missing.tags = setdiff(tag, names(results))
    if(length(missing.tags) > 0) stop(paste("Missing tag "
                                            ,paste("'", missing.tags, "'", sep = "", collapse = ",")
                                            ," from parameters file"
                                            ,sep = ""))
    results = results[tag]
  }
  
  return(results)
}

load_package <- function(pkg, github.repos = NULL) {
  ## Load the given package (update to most recent if GitHub repository)
  result = FALSE
  if(is.null(github.repos)) {
    if(!(pkg %in% installed.packages()[,"Package"])) {
      ## Package hasn't been installed, and needs to be installed
      message(paste("Installing package '", pkg, "'", sep = ""))
      suppressMessages(suppressWarnings(install.packages(pkg, verbose = FALSE, quiet = TRUE)))
    }
    ## Load the package
    result = suppressWarnings(suppressMessages(require(pkg, character.only = TRUE)))
  }
  
  else {
    ## Load the 'devtools' package (required functionality for installing packages from GitHub)
    load_package("devtools")
    repos.pkg = paste(github.repos, pkg, sep = "/")
    ## Install the package
    suppressWarnings(suppressMessages(install_github(repos.pkg, quiet = TRUE)))
    ## Load the package
    result = suppressWarnings(suppressMessages(require(pkg, character.only = TRUE)))
  }
  
  ## Stop the process if not successful
  if(!result) stop(paste("'", pkg, "' package not installed correctly", sep = ""))
  
}

worksuite_execute <- function(file
                              ,folder = NULL
                              ,log = NULL
                              ,log.title = "ad hoc"
                              ,log.folder = localize(tag = "Logs Folder")[[1]]
                              ,script.events = NULL
                              ,my.wd = NULL) {
  
  ## Execute the given file of R code with logging and error handling
  
  if(!is.null(folder)) { file = paste(folder, file, sep = "/") }
  file = normalizePath(file, winslash = "/")
  
  ## Construct working directory
  if(length(my.wd) == 0) my.wd = getwd()
  else my.wd = c(getwd(), my.wd)
  
  ## Determine the appropriate working directory folder
  ## Establish error handler
  ## Establish logger
  
  ## Execute code
  source(file)
  
  ## Evaluate success
  
  setwd(my.wd[1])
  my.wd = my.wd[-1]
  
}