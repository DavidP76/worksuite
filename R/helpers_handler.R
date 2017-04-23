## helpers_handler.R
## Scripts for handling common scripting challenges

localize <- function() {
  ## Provides paths to common file locations, depending on computer and account
  result = list()

  computer.name = Sys.info()$nodename
  account.name = Sys.info()$user
  ## Check that computer and account is in a known set
  if(computer.name !%in% c("ELSPHIL-7006805")) stop("Unable to localize: unknown computer")
  if(account.name !%in% c("PHILLIPSD")) stop("Unable to localize: unknown user")

  if(computer.name = "ELSPHIL-7006805" & account.name = "PHILLIPSD") {

  }

  invisible(result)
}
