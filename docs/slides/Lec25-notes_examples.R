#* Return "hello world"
#* @get /hello
function() {
  "hello world"
}

#* Echo the parameter that was sent in
#*
#* @get /echo/<msg>
#*
#* @param msg:string The message to echo back.
#*
function(msg) {
  list(
    msg = paste0("The message is: '", msg, "'")
  )
}

#* Fake search query endpoint ala DuckDuckGo
#* 
#* @get /
#* 
#* @query q:string The search query
#* @query pretty:int Whether to pretty-print the results (1) or not (0)
#* 
function(query) {
  paste0("The q parameter is '", query$q %||% "", "'. ",
         "The pretty parameter is '", query$pretty %||% 0, "'.")
}

#* Plot out data from the palmer penguins dataset
#*
#* @get /plot
#*
#* @query spec:string If provided, filter the data to only this species
#* (e.g. 'Adelie')
#*
#* @serializer png
#*
function(query) {
  myData <- penguins
  title <- "All Species"
  
  # Filter if the species was specified
  if (!is.null(query$spec)){
    title <- paste0("Only the '", query$spec, "' Species")
    myData <- subset(myData, species == query$spec)
  }
  
  plot(
    myData$flipper_len,
    myData$bill_len,
    main=title,
    xlab="Flipper Length (mm)",
    ylab="Bill Length (mm)"
  )
}

#* Example of capturing a request
#* 
#* @get /request
#*
function(request) {
  list(
    url = request$url,
    method = request$method,
    headers = request$headers,
    body_raw = request$body_raw
  )
}


#* Example of throwing an error
#* 
#* @get /simple
function() {
  stop("I'm an error!")
}

#* Generate a friendly error
#* 
#* @get /friendly
function() {
  abort_bad_request(
    "Your request could not be parsed"
  )
}
