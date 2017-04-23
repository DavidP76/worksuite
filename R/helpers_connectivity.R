## helpers_connectivity.R
## Set of helper functions to address issues around internet connectivity and server connectivity

hasIP <- function() {
  ## Tests to ensure whether internet connection is established (based on having valid IP address)
  ## Returns TRUE if internet connection, FALSE if no internet connection
  ## From <https://stackoverflow.com/questions/5076593/how-to-determine-if-you-have-an-internet-connection-in-r>

  if (.Platform$OS.type == "windows") {
    ipmessage <- system("ipconfig", intern = TRUE)
  } else {
    ipmessage <- system("ifconfig", intern = TRUE)
  }
  validIP <- "((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)[.]){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)"
  any(grep(validIP, ipmessage))
}
