% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/despot.R
\name{despot}
\alias{despot}
\title{despot}
\usage{
despot(transition, observation, reward, discount, state_prior = rep(1,
  dim(observation)[[1]])/dim(observation)[[1]], log_dir = tempdir(), ...)
}
\arguments{
\item{transition}{Transition matrix, dimension n_s x n_s x n_a}

\item{observation}{Observation matrix, dimension n_s x n_z x n_a}

\item{reward}{reward matrix, dimension n_s x n_a}

\item{discount}{the discount factor}

\item{state_prior}{initial belief state, optional, defaults to uniform over states}

\item{log_dir}{pomdpx and simulation csv files will be saved here, along with a metadata file}

\item{...}{additional arguments to \code{\link{despot}}.}
}
\value{
a dataFrame containing the result of the simulation
}
\description{
despot wraps the tasks of writing the pomdpx file defining the problem, running the DESPOT algorithm in C++,
and then reading the resulting simulation file back into R.
}
\examples{
\dontrun{ ## Takes > 5s
## Use example code to generate matrices for pomdp problem:
source(system.file("examples/fisheries-ex.R", package = "despot"))
alpha <- despot(transition, observation, reward, discount, precision = 10)
compute_policy(alpha, transition, observation, reward)
}

}
