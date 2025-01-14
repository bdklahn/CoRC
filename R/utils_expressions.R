#' Calculate the value of an expression or reference
#'
#' \code{getValue} calculates the value of a given expression or reference.
#'
#' @param expression Expressions to calculate, as character, finite numeric, or logical vector.
#' @param model a model object
#' @return a numeric vector of values
#' @seealso \code{\link{getInitialValue}}
#' @family expression functions
#' @export
getValue <- function(expression, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.cexpression(expression))
  
  expression %>%
    to_cexpr() %>%
    write_expr(c_datamodel) %>%
    map_dbl(get_expr_val, c_datamodel)
}

#' Calculate the initial value of an expression or reference
#'
#' \code{getValue} calculates the initial value of a given expression or reference.
#'
#' @param expression Expressions to calculate as initial expressions, as character, finite numeric, or logical vector.
#' @param model a model object
#' @return a numeric vector of initial values
#' @seealso \code{\link{getValue}}
#' @family expression functions
#' @export
getInitialValue <- function(expression, model = getCurrentModel()) {
  c_datamodel <- assert_datamodel(model)
  assert_that(is.cexpression(expression))
  
  expression %>%
    to_cexpr() %>%
    write_expr(c_datamodel) %>%
    map_dbl(get_expr_init_val, c_datamodel)
}

is.cexpression <- function(x) {
  is.character(x) || is.numeric(x) && !any(is.infinite(x)) || is.logical(x)
}
on_failure(is.cexpression) <- function(call, env) {
  paste0(deparse(call$x), ' is not a COPASI expression (a character, finitie numeric or logical vector).')
}

# translate from numeric or boolean to propper COPASI expression representation
to_cexpr <- function(x) {
  ret <- as.character(x)
  ret[is.nan(x)] <- "nan"
  
  # prevented via is.cexpression
  # ret[is.infinite(x)] <- "+-Inf"
  
  # default R conversion
  # ret[isTRUE(x)] <- "TRUE"
  # ret[isFALSE(x)] <- "FALSE"
  
  ret
}

# check if an entity has an expression set
# return "" or the expression string
expr_to_str <- function(c_entity, c_datamodel = c_entity$getObjectDataModel(), raw = FALSE) {
  c_expression <- c_entity$getExpressionPtr()
  
  if (is.null(c_expression))
    return("")
  
  expr <- c_expression$getInfix()
  
  if (expr != "" && !raw)
    expr <- read_expr(expr, c_datamodel)
  
  expr
}

# check if an entity has an expression set
# return NA_character_ or the expression DisplayName
expr_to_ref_str <- function(c_entity, c_datamodel = c_entity$getObjectDataModel()) {
  c_expression <- c_entity$getExpressionPtr()
  
  if (is.null(c_expression))
    return(NA_character_)
  
  expr <- c_expression$getInfix()
  
  if (expr == "")
    return(NA_character_)
  
  as_ref(list(c_expression), c_datamodel)
}

# check if an entity has an initial expression set
# return "" or the expression string
iexpr_to_str <- function(c_entity, c_datamodel = c_entity$getObjectDataModel(), raw = FALSE) {
  c_expression <- c_entity$getInitialExpressionPtr()
  
  if (is.null(c_expression))
    return("")
  
  expr <- c_expression$getInfix()
  
  if (expr != "" && !raw)
    expr <- read_expr(expr, c_datamodel)
  
  expr
}

# check if an entity has an initial expression set
# return NA_character_ or the expression DisplayName
iexpr_to_ref_str <- function(c_entity, c_datamodel = c_entity$getObjectDataModel()) {
  c_expression <- c_entity$getInitialExpressionPtr()
  
  if (is.null(c_expression))
    return(NA_character_)
  
  expr <- c_expression$getInfix()
  
  if (expr == "")
    return(NA_character_)
  
  as_ref(list(c_expression), c_datamodel)
}

# COPASI -> R
# In COPASI, expressions consist of <CN>, in R they should be mostly {DN}
read_expr <- function(x, c_datamodel) {
  stringr::str_replace_all(
    x,
    "<CN=.*?[^\\\\]>",
    function(x) {
      x <- stringr::str_sub(x, 2L, -2L)
      c_obj <- cn_to_object(x, c_datamodel)
      assert_that(!is.null(c_obj), msg = paste0("Failure in expression readout. A common name was not resolvable."))
      
      escape_ref(get_key(c_obj))
    }
  )
}

# R -> COPASI
# In COPASI, expressions consist of <CN>, in R they should be mostly {DN}
# Also implicitly translates {Time}, {Avogadro Constant} and {Quantity Conversion Factor}
write_expr <- function(x, c_datamodel) {
  stringr::str_replace_all(
    x,
    "\\{.*?[^\\\\]\\}",
    function(x) {
      c_obj <- dn_to_object(unescape_ref(x), c_datamodel)
      assert_that(!is.null(c_obj), msg = paste0("Cannot resolve ", x, "."))
      
      if (c_obj$getObjectType() != "Reference")
        c_obj <- c_obj$getValueReference()
      
      paste0("<", get_cn(c_obj), ">")
    }
  )
}

# calculate the value of an expression
get_expr_val <- function(x, c_datamodel) {
  # avert_gc so i can delete it right away
  # CExpressions get destructed on model unloading and
  # are therefore unsafe to keep around until next gc
  c_expression <- avert_gc(CExpression("CoRC_value_expr", c_datamodel))
  
  grab_msg(c_expression$setInfix(x))
  assert_that(
    grab_msg(c_expression$compile()$isSuccess()),
    msg = "Failed to compile expression."
  )
  val <- c_expression$calcValue()
  
  delete(c_expression)
  
  val
}

# calculate the initial value of an expression
get_expr_init_val <- function(x, c_datamodel) {
  # avert_gc so i can delete it right away
  # CExpressions get destructed on model unloading and
  # are therefore unsafe to keep around until next gc
  c_expression <- avert_gc(CExpression("CoRC_value_expr", c_datamodel))
  grab_msg(c_expression$setInfix(x))
  
  c_init_expression <- grab_msg(CExpression_createInitialExpression(c_expression, c_datamodel))
  delete(c_expression)
  
  assert_that(
    grab_msg(c_init_expression$compile()$isSuccess()),
    msg = "Failed to compile initial expression."
  )
  val <- c_init_expression$calcValue()
  
  delete(c_init_expression)
  
  val
}
