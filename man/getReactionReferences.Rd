% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/entity_accessors.R
\name{getReactionReferences}
\alias{getReactionReferences}
\title{Get reaction references}
\usage{
getReactionReferences(key = NULL, model = getCurrentModel())
}
\arguments{
\item{key}{Optionally, a character vector specifying which reactions to get.}

\item{model}{A model object.}
}
\value{
Reactions and associated references, as data frame.
}
\description{
\code{getReactions} returns reactions attribute references as a data frame.
}
\details{
The \href{https://jpahle.github.io/CoRC/articles/entity_management.html}{online article on managing model entities} provides some further context.
}
\seealso{
\code{\link{getReactions}} \code{\link{setReactions}}

Other reaction functions: 
\code{\link{clearCustomKineticFunctions}()},
\code{\link{deleteKineticFunction}()},
\code{\link{deleteReaction}()},
\code{\link{entity_finders}},
\code{\link{getParameterReferences}()},
\code{\link{getParameters}()},
\code{\link{getReactionMappings}()},
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
