% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/entity_accessors.R
\name{getParameters}
\alias{getParameters}
\title{Get reaction parameters}
\usage{
getParameters(key = NULL, model = getCurrentModel())
}
\arguments{
\item{key}{Optionally, a character vector specifying which reaction parameters to get.}

\item{model}{A model object.}
}
\value{
Reaction parameters and associated information, as data frame.
}
\description{
\code{getParameters} returns reaction parameters as a data frame.
}
\details{
The \href{https://jpahle.github.io/CoRC/articles/entity_management.html}{online article on managing model entities} provides some further context.
}
\seealso{
\code{\link{getParameterReferences}} \code{\link{setParameters}}

Other reaction functions: 
\code{\link{clearCustomKineticFunctions}()},
\code{\link{deleteKineticFunction}()},
\code{\link{deleteReaction}()},
\code{\link{entity_finders}},
\code{\link{getParameterReferences}()},
\code{\link{getReactionMappings}()},
\code{\link{getReactionReferences}()},
\code{\link{getReactions}()},
\code{\link{getValidReactionFunctions}()},
\code{\link{newKineticFunction}()},
\code{\link{newReaction}()},
\code{\link{setParameters}()},
\code{\link{setReactionFunction}()},
\code{\link{setReactionMappings}()},
\code{\link{setReactions}()}
}
\concept{reaction functions}
