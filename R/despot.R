#' despot
#'
#' despot wraps the tasks of writing the pomdpx file defining the problem, running the DESPOT algorithm in C++,
#' and then reading the resulting simulation file back into R.
#' @param transition Transition matrix, dimension n_s x n_s x n_a
#' @param observation Observation matrix, dimension n_s x n_z x n_a
#' @param reward reward matrix, dimension n_s x n_a
#' @param discount the discount factor
#' @param state_prior initial belief state, optional, defaults to uniform over states
#' @param ... additional arguments to \code{\link{despot}}.
#' @param log_dir pomdpx and simulation csv files will be saved here, along with a metadata file
#' @return a dataFrame containing the result of the simulation
#' @export
#' @examples
#' \dontrun{ ## Takes > 5s
#' ## Use example code to generate matrices for pomdp problem:
#' source(system.file("examples/fisheries-ex.R", package = "despot"))
#' alpha <- despot(transition, observation, reward, discount, precision = 10)
#' compute_policy(alpha, transition, observation, reward)
#' }
#'
despot <- function(transition, observation, reward, discount,
                   state_prior = rep(1, dim(observation)[[1]]) / dim(observation)[[1]],
                  log_dir = tempdir(), ...){
  ## Consider more robust normalization.  Check write-out precision in write_pomdp
  initial = normalize(state_prior)
  log_data = NULL
  ## Use ID given in log_data, if provided
  if(is.null(log_data) | is.null(log_data$id)){
    id <- gsub("/", "", tempfile("", tmpdir = ""))
  } else {
    id <- log_data$id
    log_data$id <- NULL
  }



  infile <- paste0(log_dir, "/", id,  ".pomdpx")
  outfile <-  paste0(log_dir, "/", id,  ".policyx")
  stdout <-  paste0(log_dir, "/", id,  ".log")
  write_pomdpx(transition, observation, reward, discount, initial, file = infile)
  result <- solver(infile, outfile, stdout = stdout, ...)
  return(result)
}
