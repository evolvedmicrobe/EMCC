
%%% $Id: print.Rd,v 1.1 2008/02/05 19:30:09 goswami Exp $

\name{print}

\alias{print.EMCC}

\alias{print.EMCCMaxTemper}

\alias{print.EMCCPlaceTempers}

\title{The printing family of functions}

\description{
  The printing family of functions for this package.
}

\usage{
\method{print}{EMCC}(x, \dots)
\method{print}{EMCCMaxTemper}(x, \dots)
\method{print}{EMCCPlaceTempers}(x, \dots)
}

\arguments{

  \item{x}{an object inheriting from class \code{EMCC} (generated by
    function \code{evolMonteCarloClustering}), \code{EMCCMaxTemper}
    (generated by function \code{findMaxTemper}) or
    \code{EMCCPlaceTempers} (generated by function
    \code{placeTempers}).}

  \item{\dots}{optional arguments passed to \code{print.default}; see
    its documentation.}
}

\author{Gopi Goswami \email{goswami@stat.harvard.edu}}

\seealso{\code{\link{evolMonteCarloClustering}},
  \code{\link{findMaxTemper}}, \code{\link{placeTempers}}}

\keyword{print}
