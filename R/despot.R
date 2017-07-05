#' despot
#'
#' despot wraps the tasks of writing the pomdpx file defining the problem, running the DESPOT algorithm in C++,
#' and then reading the resulting simulation file back into R.
#' @param transition Transition matrix, dimension n_s x n_s x n_a
#' @param observation Observation matrix, dimension n_s x n_z x n_a
#' @param reward reward matrix, dimension n_s x n_a
#' @param discount the discount factor
#' @param state_prior initial belief state, optional, defaults to uniform over states
#' @param verbose logical, should the function include a message with pomdp diagnostics (timings, final precision, end condition)
#' @param ... additional arguments to \code{\link{appl}}.
#' @param log_dir pomdpx and simulation csv files will be saved here, along with a metadata file
#' @return a matrix of alpha vectors. Column index indicates action associated with the alpha vector, (1:n_actions),
#'  rows indicate system state, x. Actions for which no alpha vector was found are included as all -Inf, since such actions are
#'  not optimal regardless of belief, and thus have no corresponding alpha vectors in alpha_action list.
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
                   verbose = TRUE, log_dir = tempdir(), log_data = NULL, ...){
  ## Consider more robust normalization.  Check write-out precision in write_pomdp
  initial = normalize(state_prior)

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
