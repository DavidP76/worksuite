# Initialize --------------------------------------------------------------

cat("Loading required package: 'worksuite'")
loadWorksuite = suppressWarnings(suppressMessages(require(worksuite)))
if(!loadWorksuite) {
  loadDevtools = suppressWarnings(suppressMessages(require(devtools)))
  if(!loadDevtools) {
    cat("Loading required package: 'devtools' (may take a while)\n")
    install.packages("devtools", verbose = FALSE, quiet = TRUE)
    loadDevtools = suppressWarnings(suppressMessages(require(devtools)))
    if(!loadDevtools) { stop("'devtools' package not successfully loaded. Please retry") }
  }
  repo = "DavidP76/worksuite"
  ref = "master"
  cat(paste("Downloading package contents: '"
            ,repo
            ,"' ("
            ,ref
            ,")\n"
            , sep = ""))
  supporessWarnings(suppressMessages(install_github(repo = repo, ref = ref, quiet = TRUE)))
  loadWorksuite = suppressWarnings(suppressMessages(require(worksuite)))
  if(!loadWorksuite) { stop("'worksuite' package not successfully loaded. Please retry") }
}
rm(list = intersect(c("loadWorksuite", "loadDevtools", "ref", "repo"), ls()))


# Locate Code -------------------------------------------------------------

script.folder = ""
script.file = ""
script.name = ""
script.timestamp = Sys.time()


# Execute Code ------------------------------------------------------------

worksuite_execute(file = script.file
                  ,folder = script.folder
                  ,log.title = script.name)
