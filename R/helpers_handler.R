## helpers_handler.R
## Scripts for handling common scripting challenges

localize <- function() {
  ## Provides paths to common file locations, depending on computer and account
  
  result = list()

  ## Check that computer and account is in a known set
  computer.name = clean.values(Sys.info()["nodename"])
  account.name = clean.values(Sys.info()["user"])
  if(computer.name %in% c("ELSPHIL-7006805") == FALSE) stop("Unable to localize: unknown computer")
  if(account.name %in% c("PHILLIPSD") == FALSE) stop("Unable to localize: unknown user")

  ## Define localized parameters depending on the computer and user account
  if(computer.name == "ELSPHIL-7006805" & account.name == "PHILLIPSD") {
    ## Elsevier laptop - David P's login
    result[["computer.info"]] = c(computer.name = computer.name
                                  ,account.name = account.name)
  }

  invisible(result)
}

load_package <- function(pkg
                         ,github.repos =               ## Name of the GitHub repository (NULL if CRAN package)
                           ifelse(pkg == "worksuite", "DavidP76", NULL)) {
  ## Load the given package (update to most recent if GitHub repository)
  browser()
  result = FALSE
  if(is.null(github.repos)) {
    if(!(pkg %in% installed.packages()[,"Package"])) {
      ## Package hasn't been installed, and needs to be installed
      message(paste("Installing package '", pkg, "'", sep = ""))
      suppressMessages(suppressWarnings(install.packages(pkg, verbose = FALSE, quiet = TRUE)))
    }
    ## Load the package
    result = suppressWarnings(suppressMessages(require(pkg)))
  }
  
  else {
    ## Load the 'devtools' package (required functionality for installing packages from GitHub)
    load_package("devtools")
    repos.pkg = paste(github.repos, pkg, sep = "/")
    ## Install the package
    suppressWarnings(suppressMessages(install_github(repos.pkg)))
    ## Load the package
    result = suppressWarnings(suppressMessages(require(pkg)))
  }
  
  ## Stop the process if not successful
  if(!result) stop(paste("'", pkg, "' package not installed correctly"))
  
}