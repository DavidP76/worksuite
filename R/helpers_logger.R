## helpers_logger.R
## Scripts for handling challenges around logging results

get_output_folder = function(log.title, log.folder, start.time) {
  ## Create the appropriate new folder to log actions, and set as the working directory
  
  log.folder = norm_path(log.folder)
  ## Check to see if the intended directory folder exists
  log.folder.dest = paste(log.folder
                          ,paste(format.Date(start.time, "%Y-%m-%d")
                                 ,tolower(log.title)
                                 ,sep = " ")
                          ,sep = "/")
  if(dir.exists(tolower(log.folder.dest))) {
    ## Rename the previous folder in this location
    prev.folder.ctime = file.info(log.folder.dest)$ctime
    if(is.na(prev.folder.ctime)) { prev.folder.ctime = "00:00:00" }
    else { prev.folder.ctime = format(prev.folder.ctime, "%H-%M-%S") }
    file.rename(from = log.folder.dest
                ,to = paste(log.folder.dest, " (", prev.folder.ctime, ")", sep = ""))
    log.folder.dest = paste(log.folder.dest, " (", format(start.time, "%H-%M-%S"), ")", sep = "")
  }
  ## Test to see if there are already multiple folders for the day
  
  dir.create(log.folder.dest)
  my.wd = c(log.folder.dest, my.wd)
  setwd(log.folder.dest)
}