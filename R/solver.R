#' APPL wrappers
#'
#' Wrappers for the APPL executables. The \code{pomdpsol} function solves a model
#' file and returns the path to the output policy file.
#'
#' @export
#' @rdname despot
#' @aliases despot DESPOT
#' @param model file/path to the \code{pomdp} model file
#' @param stdout a filename where pomdp run data will be stored
#' @param stderr where output to 'stderr', see \code{\link{system2}}. Use \code{FALSE}
#' to suppress output.
#' @param timout despot search time per move, in seconds (default 1)
#' @param simlen despot number of steps to simulate (default 90)
#' @param max-policy-simlen number of steps to simulate the default policy (default 90)
#' @param depth maximum depth to simulate (default 90)
#' @param discount discount factor for the POMDP model (default from the model file)
#' @examples
#' \donttest{
#' model <- system.file("models/example.pomdp", package = "sarsop")
#' policy <- tempfile()
#' pomdpsol(model, output = policy, timeout = 1)
#'
#' # Other tools
#' evaluation <- pomdpeval(model, policy, stdout = FALSE)
#' graph <- polgraph(model, policy, stdout = FALSE)
#' simulations <- pomdpsim(model, policy, stdout = FALSE)
#' }
pomdpsol <- function(model, output = tempfile(), runs=2,
                     stdout = tempfile(),
                     stderr = tempfile(),
                     timeout=NULL,
                     simlen=NULL,
                     max_policy_simlen=NULL,
                     depth=NULL,
                     discount=NULL){

  model <- normalizePath(model, mustWork = TRUE)
  args <- paste("-m", model, "--runs", runs)

  if(!is.null(timeout)) args <- paste(args, "--timeout", timeout)
  if(!is.null(simlen)) args <- paste(args, "--simlen", simlen)
  if(!is.null(max_policy_simlen)) args <- paste(args, "--max-policy-simlen", max_policy_simlen)
  if(!is.null(depth)) args <- paste(args, "--depth", depth)
  if(!is.null(discount)) args <- paste(args, "--discount", discount)


  # args <- paste(args)
  print(stdout)
  exec_program("pomdpx", args, stdout = stdout, stderr = stderr)
  # parse_despot_messages(readLines(stdout))
  # Read back simulation CSV into R
  result <- read.csv(file=stdout, header=TRUE, sep=";")

  #formatting the output
  result$State = as.integer(gsub("[a-z]", "\\", result$State))
  result$Action = as.integer(gsub("[a-z]", "\\", result$Action))
  result$Observation = as.integer(gsub("[a-z]", "\\", result$Observation))

  return(result)
}

exec_program <- function(program, args, stdout, stderr = "") {
  if(identical(.Platform$OS.type, "windows")){
    program <- paste0(.Platform$r_arch, "/", program, ".exe")
  }
  binpath <- system.file("inst/bin", package = "despot")
  path <- normalizePath(file.path(binpath, program), mustWork = TRUE)
  res <- system2(path, args, stdout = stdout, stderr = stderr)
  if(res != 0) stop("Call to ", program, " failed with error: ", res)
  return(res)
}


# parse_key_value <- function(key, txt){
#   i <- grep(key, txt)
#   value <- strsplit(txt[i], " : ")[[1]][2]
#   as.numeric(gsub( "(\\d+)[a-zA-Z\\s]", "\\1", value))
# }

parse_despot_messages <- function(txt){

  # final_i <- grep("Time   |#Trial |#Backup |LBound    |UBound    |Precision  |#Alphas |#Beliefs", txt)[2] + 2
  # final <- as.numeric(strsplit(txt[final_i], "\\s+")[[1]])[-1]
  # names(final) <- c("Time", "#Trial", "#Backup", "LBound", "UBound", "Precision", "#Alphas", "#Beliefs")
  #
  # final_precision <- final[["Precision"]]
  # run_time <- final[["Time"]]
  #
  # load_time <- parse_key_value("loading time",txt) # in seconds
  # init_time <- parse_key_value("initialization time", txt)
  #
  # n <- grep("SARSOP finishing", txt)
  # end_condition <- txt[n+1]
  #
  # target_precision_reached <- grepl("target precision reached", end_condition)
  # timeout_reached <- grepl("Preset timeout reached", end_condition)
  # memory_limit_reached <- is.null(end_condition)
  # if(length(end_condition) == 0)
  #   end_condition <- NA
  #
  # list(load_time_sec = load_time,
  #   init_time_sec = init_time,
  #   run_time_sec = run_time,
  #   final_precision = final_precision,
  #   end_condition = end_condition)
}
