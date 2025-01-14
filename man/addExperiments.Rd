% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/task_parameterestimation.R
\name{addExperiments}
\alias{addExperiments}
\title{Add a parameter estimation experiment}
\usage{
addExperiments(..., model = getCurrentModel())
}
\arguments{
\item{...}{objects as returned by \code{\link{defineExperiments}}.
Alternatively, the same parameters as used by \code{\link{defineExperiments}}.}

\item{model}{a model object}
}
\description{
Add a parameter estimation experiment
}
\seealso{
\code{\link{defineExperiments}} \code{\link{clearExperiments}}

Other parameter estimation: 
\code{\link{addParameterEstimationParameter}()},
\code{\link{clearExperiments}()},
\code{\link{clearParameterEstimationParameters}()},
\code{\link{clearValidations}()},
\code{\link{defineExperiments}()},
\code{\link{getParameterEstimationSettings}()},
\code{\link{runParameterEstimation}()},
\code{\link{setParameterEstimationSettings}()}
}
\concept{parameter estimation}
