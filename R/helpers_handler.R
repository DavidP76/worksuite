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
