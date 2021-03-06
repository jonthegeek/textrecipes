% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/embeddings.R
\name{step_word_embeddings}
\alias{step_word_embeddings}
\alias{tidy.step_word_embeddings}
\title{Pretrained word embeddings of tokens}
\usage{
step_word_embeddings(
  recipe,
  ...,
  role = "predictor",
  trained = FALSE,
  columns = NULL,
  embeddings,
  aggregation = c("sum", "mean", "min", "max"),
  aggregation_default = 0,
  prefix = "w_embed",
  skip = FALSE,
  id = rand_id("word_embeddings")
)

\method{tidy}{step_word_embeddings}(x, ...)
}
\arguments{
\item{recipe}{A recipe object. The step will be added to the sequence of
operations for this recipe.}

\item{...}{One or more selector functions to choose variables. For
\code{step_word_embeddings}, this indicates the variables to be encoded into a
\link{tokenlist}. See \code{\link[recipes:selections]{recipes::selections()}} for more details. For the \code{tidy}
method, these are not currently used.}

\item{role}{For model terms created by this step, what analysis role should
they be assigned?. By default, the function assumes that the new columns
created by the original variables will be used as predictors in a model.}

\item{trained}{A logical to indicate if the recipe has been baked.}

\item{columns}{A list of tibble results that define the encoding. This is
\code{NULL} until the step is trained by \code{\link[recipes:prep]{recipes::prep.recipe()}}.}

\item{embeddings}{A tibble of pre-trained word embeddings, such as those
returned by the embedding_glove function function from the textdata
package The first column should contain tokens, and additional columns
should contain embeddings vectors.}

\item{aggregation}{A character giving the name of the aggregation function to
use. Must be one of "sum", "mean", "min", and "max". Defaults to "sum".}

\item{aggregation_default}{A numeric denoting the default value for case with
no words are matched in embedding. Defaults to 0.}

\item{prefix}{A character string that will be the prefix to the resulting new
variables. See notes below.}

\item{skip}{A logical. Should the step be skipped when the recipe is baked by
\code{\link[recipes:bake]{recipes::bake.recipe()}}? While all operations are baked when
\code{\link[recipes:prep]{recipes::prep.recipe()}} is run, some operations may not be able to be
conducted on new data (e.g. processing the outcome variable(s)). Care
should be taken when using \code{skip = TRUE} as it may affect the computations
for subsequent operations.}

\item{id}{A character string that is unique to this step to identify it.}

\item{x}{A \code{step_word_embeddings} object.}
}
\value{
An updated version of \code{recipe} with the new step added to the
sequence of existing steps (if any).
}
\description{
\code{step_word_embeddings} creates a \emph{specification} of a recipe step that will
convert a \link{tokenlist} into word-embedding dimensions by aggregating the
vectors of each token from a pre-trained embedding.
}
\details{
Word embeddings map words (or other tokens) into a high-dimensional
feature space. This function maps pre-trained word embeddings onto the
tokens in your data.

The argument \code{embeddings} provides the pre-trained vectors. Each dimension
present in this tibble becomes a new feature column, with each column
aggregated across each row of your text using the function supplied in the
\code{aggregation} argument.

The new components will have names that begin with \code{prefix}, then the name
of the aggregation function, then the name of the variable from the
embeddings tibble (usually something like "d7"). For example, using the
default "word_embeddings" prefix, the "sum" aggregation, and the GloVe
embeddings from the textdata package (where the column names are \code{d1},
\code{d2}, etc), new columns would be \code{word_embeddings_sum_d1},
\code{word_embeddings_sum_d2}, etc.
}
\examples{
library(recipes)

embeddings <- tibble(
  tokens = c("the", "cat", "ran"),
  d1 = c(1, 0, 0),
  d2 = c(0, 1, 0),
  d3 = c(0, 0, 1)
)

sample_data <- tibble(
  text = c(
    "The.",
    "The cat.",
    "The cat ran."
  ),
  text_label = c("fragment", "fragment", "sentence")
)

rec <- recipe(text_label ~ ., data = sample_data) \%>\%
  step_tokenize(text) \%>\%
  step_word_embeddings(text, embeddings = embeddings)

obj <- rec \%>\%
  prep()

bake(obj, sample_data)

tidy(rec, number = 2)
tidy(obj, number = 2)
}
\seealso{
\code{\link[=step_tokenize]{step_tokenize()}} to turn character into tokenlist.

Other tokenlist to numeric steps: 
\code{\link{step_texthash}()},
\code{\link{step_tfidf}()},
\code{\link{step_tf}()}
}
\concept{tokenlist to numeric steps}
