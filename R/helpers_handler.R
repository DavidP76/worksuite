## helpers_handler.R
## Scripts for handling common scripting challenges

localize <- function(tag = NULL) {
  ## Provides paths to common file locations, depending on computer and account
  
  result = list()

  ## Check that computer and account is in a known set
  known.accounts = data.frame(computer.name = character(0)
                              ,account.name = character(0))
  known.accounts = rbind(known.accounts
                         ,data.frame(computer.name = "ELSPHIL-7006805"     , account.name = "PHILLIPSD")     ## DP Elsevier Dell
                         ,data.frame(computer.name = "DESKTOP-12K9V71"     , account.name = "LEIGHD")        ## LD Personal ASUS
  )
  
  computer.name = toupper(clean_values(Sys.info()["nodename"]))
  account.name = toupper(clean_values(Sys.info()["user"]))
  
  browser()
  if(computer.name %in% c("ELSPHIL-7006805"               ## DP Elsevier Dell
                          ,"DESKTOP-12K9V71"              ## LD Personal ASUS
  ) == FALSE) stop("Unable to localize: unknown computer/account")

  ## Define localized parameters depending on the computer and user account
  if(computer.name == "DESKTOP-12K9V71" & account.name == "LEIGHD") {
    result[["computer.name"]] = computer.name
    result[["account.name"]] = account.name
  }

  invisible(result)
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