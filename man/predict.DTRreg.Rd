\name{predict}
\alias{predict.DTRreg}
\title{Optimal Outcome Prediction for DTRs}
\description{
Predicted outcome assuming optimal treatment (according to analysis via G-estimation or dWOLS) was followed.  Assumes blip and treatment-free models correctly specified.
}
\usage{
\method{predict}{DTRreg}(object, newdata, treat.range = NULL, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object}{A model object generated by the function DTRreg.}
  \item{newdata}{A dataset (usually the data analyzed by DTRreg for which predicted outcomes are desired.  If a new dataset is provided, variable names should correspond to those presented to DTRreg}
  \item{treat.range}{If treatment is continuous (rather than binary), a list of vectors of the form c(min,max) which specify the minimum and maximum value the treatment may take.  If unspecified, this will be inferred from the treat.range provided with use of the original DTRreg command.  As such, if no treatment range was specified there either, treat.range will be the minimum and maximum observed treatment value at each stage.}
  \item{...}{Space for additional arguments (not currently used by DTRreg)}
}
\details{
This function may be used in a similar fashion to more traditional modelling commands (such as lm).  Users are referred to the primary DTRreg help command (and associated literature) for information concerning model specification.  In particular, we note that the predict function assumes that the treatment-free model has been correctly specified, as the treatment-free parameters are used in the prediction process.
}
\value{An n x 1 matrix of predicted outcome values.
}
\references{
Chakraborty, B., Moodie, E. E. M. (2013) \emph{Statistical Methods for Dynamic Treatment Regimes}. New York: Springer.

Robins, J. M. (2004) \emph{Optimal structural nested models for optimal sequential decisions}. In Proceedings of the Second Seattle Symposium on Biostatistics, D. Y. Lin and P. J. Heagerty (eds), 189--326. New York: Springer.

Wallace, M. P., Moodie, E. M. (2015) Doubly-Robust Dynamic Treatment Regimen Estimation Via Weighted Least Squares. \emph{Biometrics} \bold{71}(3), 636--644 (doi:10.1111/biom.12306.)
}
\author{Michael Wallace}

\examples{
##################
# example single run of a 2-stage g-estimation analysis
set.seed(1)
# expit function
expit <- function(x) {1 / (1 + exp(-x))}
# sample size
n <- 10000
# variables (X = patient information, A = treatment)
X1 <- rnorm(n)
A1 <- rbinom(n, 1, expit(X1))
X2 <- rnorm(n)
A2 <- rbinom(n, 1, expit(X2))
# blip functions
gamma1 <- A1 * (1 + X1)
gamma2 <- A2 * (1 + X2)
# observed outcome: treatment-free outcome plus blip functions
Y <- exp(X1) + exp(X2) + gamma1 + gamma2 + rnorm(n)
# models to be passed to DTRreg
# blip model
blip.mod <- list(~X1, ~X2)
# treatment model (correctly specified)
treat.mod <- list(A1~X1, A2~X2)
# treatment-free model (incorrectly specified)
tf.mod <- list(~X1, ~X2)

# perform G-estimation
mod1 <- DTRreg(Y, blip.mod, treat.mod, tf.mod, method = "gest")

# predicted Y for optimal treatment
dat <- data.frame(X1,X2,A1,A2)
predict(mod1, newdata = dat)
##################
}

\keyword{dynamic treatment regimens,adaptive treatment strategies,personalized medicine,g-estimation,dynamic weighted ordinary least squares}
