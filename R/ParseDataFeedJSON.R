#' This function will parse the json response and checks if the reponse 
#' is contains an error, if found it will promt user with the related 
#' error message.
#' 
#' @keywords internal 
#' 
#' @param GA.Data The json reponse returned by the Google analytics Data feed API.             
#' 
#' @return GA.list.param GA.list.param list object obtained from this json argument GA.Data.
ParseDataFeedJSON <- function(GA.Data) {
  
  GA.list.param <- ParseApiErrorMessage(GA.Data)
    return(GA.list.param)
}