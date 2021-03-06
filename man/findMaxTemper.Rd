
%%% $Id: findMaxTemper.Rd,v 1.15 2008/02/06 05:35:09 goswami Exp $

\name{findMaxTemper}

\alias{findMaxTemper}

\title{Find the maximum temperature for parallel MCMC chains}

\description{
  The evolutionary Monte Carlo clustering (EMCC) algorithm needs a
  temperature ladder. This function finds the maximum temperature for
  constructing the ladder.

  Below \code{sampDim} refers to the dimension of the sample space,
  \code{temperLadderLen} refers to the length of the temperature ladder,
  and \code{levelsSaveSampForLen} refers to the length of
  \code{levelsSaveSampFor}. Note, this function calls
  \code{\link{evolMonteCarloClustering}}, so some of the arguments below
  have the same name and meaning as the corresponding ones for
  \code{\link{evolMonteCarloClustering}}. \emph{See details below for
  explanation on the arguments}.
}
 
\usage{
findMaxTemper(nIters,
              statsFuncList,
              startingVals,
              logTarDensFunc,
              temperLadder      = NULL,
              temperLimits      = NULL,
              ladderLen         = 10,
              scheme            = 'exponential',
              schemeParam       = 0.5,
              cutoffDStats      = 1.96,
              cutoffESS         = 50,
              guideMe           = TRUE,
              levelsSaveSampFor = NULL,
              saveFitness       = FALSE,
              doFullAnal        = TRUE,
              verboseLevel      = 0,
              \dots)   
}

\arguments{
  \item{nIters}{\code{integer} \eqn{>} 0.}

  \item{statsFuncList}{\code{list} of functions of one argument
    each, which return the value of the statistic evaluated at
    one MCMC sample or draw.}

  \item{startingVals}{\code{double} matrix of dimension
    \code{temperLadderLen} \eqn{\times}{x} \code{sampDim} or vector of
    length \code{sampDim}, in which case the same starting values are
    used for every temperature level.}

  \item{logTarDensFunc}{\code{function} of two arguments
    \code{(draw, \dots)} that returns the target density evaluated in
    the log scale.}

  \item{temperLadder}{\code{double} vector with all \emph{positive}
    entries, in \emph{decreasing} order.}

  \item{temperLimits}{\code{double} vector with \emph{two positive}
    entries.}

  \item{ladderLen}{\code{integer} \eqn{>} 0.}

  \item{scheme}{\code{character}.}

  \item{schemeParam}{\code{double} \eqn{>} 0.}

  \item{cutoffDStats}{\code{double} \eqn{>} 0.}

  \item{cutoffESS}{\code{double} \eqn{>} 0.}

  \item{guideMe}{\code{logical}.}

  \item{levelsSaveSampFor}{\code{integer} vector with \emph{positive}
    entries.}

  \item{saveFitness}{\code{logical}.}

  \item{doFullAnal}{\code{logical}.}

  \item{verboseLevel}{\code{integer}, a value \eqn{\ge}{>=} 2 produces a
    lot of output.}

  \item{\dots}{optional arguments to be passed to \code{logTarDensFunc},
    \code{MHPropNewFunc} and \code{logMHPropDensFunc}.}

}

\details{
  This function is based on the method to find the temperature range
  introduced in section 4.1 of Goswami and Liu (2007).

  \describe{

    \item{\code{statsFuncList}}{The user specifies this list of
      functions, each of which is known to be sensitive to the presence
      of modes. For example, if both dimension 1 and 3 (i.e., objects 1
      and 3) are sensitive to presence of modes, then one could use:}

    \preformatted{
    coord1        <- function (xx) { xx[1] }
    }

    \preformatted{
    coord3        <- function (xx) { xx[3] }
    }
  
    \preformatted{
    statsFuncList <- list(coord1, coord3)
    }

    \item{\code{temperLadder}}{This is the temperature ladder needed for
      the first stage preliminary run. One can either specify a
      temperature ladder via \code{temperLadder} or specify
      \code{temperLimits}, \code{ladderLen}, \code{scheme} and
      \code{schemeParam}. For details on the later set of parameters,
      see below. Note, \code{temperLadder} overrides
      \code{temperLimits}, \code{ladderLen}, \code{scheme} and
      \code{schemeParam}.}
    
    \item{\code{temperLimits}}{\code{temperLimits = c(lowerLimit,
      upperLimit)} is a two-tuple of positive numbers, where the
      \code{lowerLimit} is usually 1 and \code{upperLimit} is a number
      in [100, 1000]. If stochastic optimization (via sampling) is the
      goal, then \code{lowerLimit} is taken to be in [0, 1].}

    \item{\code{ladderLen}, \code{scheme} and \code{schemeParam}}{These
      three parameters are required (along with \code{temperLimits}) if
      \code{temperLadder} \emph{is not} provided. We recommend taking
      \code{ladderLen} in [15, 30]. The allowed choices for
      \code{scheme} and \code{schemeParam} are:}

    \tabular{rl}{
      \code{scheme} \tab \code{schemeParam} \cr
      ======== \tab ============= \cr
      linear \tab NA \cr
      log \tab NA \cr
      geometric \tab NA \cr
      mult-power \tab NA \cr
      add-power \tab \eqn{\ge}{>=} 0 \cr
      reciprocal \tab NA \cr
      exponential \tab \eqn{\ge}{>=} 0 \cr
      tangent \tab \eqn{\ge}{>=} 0      
    }

    We recommended using \code{scheme = 'exponential'} and
    \code{schemeParam} in [0.3, 0.5].    
    
    \item{\code{cutoffDStats}}{This cutoff comes from \eqn{Normal_1(0,
      1)}, the standard normal distribution (Goswami and Liu, 2007); the
      default value 1.96 is a conservative cutoff. Note if you have more
      than one statistic in \code{statsFuncList}, which is usually the
      case, using this cutoff may result in different suggested maximum
      temperatures (as can be seen by calling the \code{print} function
      on the result of \code{findMaxTemper}). A conservative
      recommendation is that you choose the maximum of the suggested
      temperatures as the final maximum temperature for use in
      \code{placeTempers} and later in \code{parallelTempering} or
      \code{evolMonteCarlo}.}

    \item{\code{cutoffESS}}{a cutoff for the effective sample size (ESS)
      of the underlying Markov chain ergodic estimator and the
      importance sampling estimators.}
    
    \item{\code{guideMe}}{If \code{guideMe = TRUE}, then the function
      suggests different modifications to alter the setting towards a
      re-run, in case there are problems with the underlying MCMC run.}

    \item{\code{doFullAnal}}{If \code{doFullAnal = TRUE}, then the
      search for the maximum temperature is conducted among \emph{all}
      the levels of the \code{temperLadder}. In case this switch is
      turned off, the search for maximum temperature is done in a greedy
      (and faster) manner, namely, search is stopped as soon as all the
      statistic(s) in the \code{statsFuncList} find some maximum
      temperature(s). Note, the greedy search may result in much higher
      maximum temperature (and hence sub-optimal) than needed, so it is
      not recommended.}

    \item{\code{levelsSaveSampFor}}{This is passed to
      \code{evolMonteCarlo} for the underlying MCMC run.}

  }
}
  
\value{
  This function returns a list with the following components:

  \item{temperLadder}{the temperature ladder used for the underlying
    MCMC run.}

  \item{DStats}{the \emph{D}-statistic (Goswami and Liu, 2007) values
    used to find the maximum temperature.}

  \item{cutoffDStats}{the \code{cutoffDStats} argument.}

  \item{nIters}{the post burn-in \code{nIters}.}

  \item{levelsSaveSampFor}{the \code{levelsSaveSampFor} argument.}

  \item{draws}{\code{array} of dimension \code{nIters} \eqn{\times}{x}
      \code{sampDim} \eqn{\times}{x} \code{levelsSaveSampForLen}, if
      \code{saveFitness = FALSE}. If \code{saveFitness = TRUE}, then the
      returned array is of dimension \code{nIters} \eqn{\times}{x}
      \code{(sampDim + 1)} \eqn{\times}{x} \code{levelsSaveSampForLen};
      i.e., each of the \code{levelsSaveSampForLen} matrices contain the
      fitness values in their last column.}

  \item{startingVals}{the \code{startingVals} argument.}

  \item{intermediate statistics}{a bunch of intermediate statistics used
    in the computation of \code{DStats}, namely, \code{MCEsts},
    \code{MCVarEsts}, \code{MCESS}, \code{ISEsts}, \code{ISVarEsts},
    \code{ISESS}, each being computed for all the statistics provided by
    \code{statsFuncList} argument.}

  \item{time}{the time taken by the run.}

}

\note{
  The effect of leaving the default value \code{NULL} for some of the
  arguments above are as follows:

  \tabular{rl}{
    \code{temperLadder}
    \tab valid \code{temperLimits}, \code{ladderLen}, \code{scheme} and
    \code{schemeParam}
    \cr

    \tab
    are provided, which are used to construct the \code{temperLadder}.
    \cr
    
    \code{temperLimits}
    \tab a valid \code{temperLadder} is provided.
    \cr

    \code{levelsSaveSampFor}
    \tab \code{temperLadderLen}.

  }
}

\author{Gopi Goswami \email{goswami@stat.harvard.edu}}

\references{
  \cite{Gopi Goswami and Jun S. Liu (2007). On learning strategies for
    evolutionary Monte Carlo. \emph{Statistics and Computing
      17:1:23-38}.}

  \cite{Gopi Goswami, Jun S. Liu and Wing H. Wong (2007). Evolutionary
    Monte Carlo Methods for Clustering. \emph{Journal of Computational
    and Graphical Statistics, 16:4:855-876}.}  
}

\seealso{\code{\link{placeTempers}}, \code{\link{evolMonteCarloClustering}}}

\examples{
## The following example is a simple stochastic optimization problem,
## and thus it does not require any "heating up", and hence the
## maximum temperature turns out to be the coldest one, i.e, 0.5.
adjMatSum <-
    function (xx)
{
    xx     <- as.integer(xx)
    adjMat <- outer(xx, xx, function (id1, id2) { id1 == id2 })
    sum(adjMat)
}
modeSensitive1 <-
    function (xx)
{
    with(partitionRep(xx),
     {
         rr   <- 1 + seq_along(clusterLabels)
         freq <- sapply(clusters, length)
         oo   <- order(freq, decreasing = TRUE)
         sum(sapply(clusters[oo], sum) * log(rr))
     })
}
entropy <-
    function (xx)
{
    yy <- table(as.vector(xx, mode = "numeric"))
    zz <- yy / length(xx)
    -sum(zz * log(zz))
}
maxProp <- 
    function (xx)
{
    yy <- table(as.vector(xx, mode = "numeric"))
    oo <- order(yy, decreasing = TRUE)
    yy[oo][1] / length(xx)
}
statsFuncList  <- list(adjMatSum, modeSensitive1, entropy, maxProp)
KMeansObj      <- KMeansFuncGenerator1(-97531)
maxTemperObj   <-
    with(KMeansObj,
     {
         temperLadder <- c(20, 10, 5, 1, 0.5)
         nLevels      <- length(temperLadder)
         sampDim      <- nrow(yy)
         startingVals <- sample(c(0, 1),
                                size    = nLevels * sampDim,
                                replace = TRUE)
         startingVals <- matrix(startingVals, nrow = nLevels, ncol = sampDim)
         findMaxTemper(nIters            = 50,
                       statsFuncList     = statsFuncList,
                       temperLadder      = temperLadder,
                       startingVals      = startingVals,
                       logTarDensFunc    = logTarDensFunc,
                       levelsSaveSampFor = seq_len(nLevels),
                       doFullAnal        = TRUE,
                       saveFitness       = TRUE,
                       verboseLevel      = 1)
     })
print(maxTemperObj)
print(names(maxTemperObj))
with(c(maxTemperObj, KMeansObj),
 {
     fitnessCol <- ncol(draws[ , , 1])     
     sub        <- paste('uniform prior on # of clusters: DU[',
                         priorMinClusters, ', ',
                         priorMaxClusters, ']', sep = '')
     for (ii in rev(seq_along(levelsSaveSampFor))) {
         main <- paste('EMCC (MAP) clustering (temper = ',
                       round(temperLadder[levelsSaveSampFor[ii]], 3), ')',
                       sep = '')
         MAPRow <- which.min(draws[ , fitnessCol, ii])
         clusterPlot(clusterInd        = draws[MAPRow, -fitnessCol, ii],
                     data              = yy,
                     main              = main,
                     sub               = sub,
                     knownClusterMeans = knownClusterMeans)
     }
 })
}
\keyword{methods}
