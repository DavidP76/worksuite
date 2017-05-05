## helpers_handler.R
## Scripts for handling common scripting challenges

localize <- function(tag = NULL) {
  ## Provides paths to common file locations, depending on computer and account
  
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
  ## These files must be saved as CSV, with first row as {Field Name, Field Tyoe, Field Value}
  ## Fields that contain filenames should be of the format "C:/EXAMPLE.csv" to refer to an absolute path or "./EXAMPLE.csv" for a path relative to the parameter file
  
  parameter.files = rbind(
    data.frame(computer.name = "DESKTOP-12K9V71", account.name = "LEIGHD", file.name = "Parameters.csv", file.path = "C:\Users\leighd\Documents\David Sabbatical\R Projects")
  )
 
  load.parameter.files = function(locs) {
    browser()
  } 
  
  results = load.parameter.files(parameter.files[parameter.files$computer.name == computer.name
                                                 & account.files$computer.name == account.name,])
  
  browser()
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