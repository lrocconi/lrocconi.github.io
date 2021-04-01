---
permalink: /software/
title: "Software"
---

# R
In the near future, I plan on submitting these function to CRAN. 

## Quick Frequency and Descriptive Statistics
The majority of my students come to R after using SPSS for most of their careers. One issue they seem to grapple with is running frequency statistics in R. While there are many packages that provide descriptive statistics (e.g., `psych::describe`, `skimr::skim`), I wanted (1) a lightweight function that just prints frequency tables for all variables in a data frame, including NAs, regardless of type (e.g., factor, numeric): `freq`  and (2) a function that prints a frequency table, including NAs, valid cases, and proportions, for factor variables and descriptive statistics (min, 1st quartile, median, 3rd quartile, max, mean, standard deviation, and number of missing cases) for numeric variables: `stats`. There is also an auxiliary function, `freq2` that prints a frequency table along with number missing and proportions for all variables in a data frame regardless of type. 

Each function requires only one argument, the name of the data frame object stored in R. *Note:* `stats` only works if every variable in the data frame is either a factor or numeric variable. Character variables will throw an error cause the function not to work. 
```R
freq(myData)
stats(myData)
freq2(myData)
```

You can download the file [here](/file/software/freqstats.R) or source it directly from the website
	source("https://lrocconi.github.io/files/software/freqstats.R")
	stats(myData)
	
## Structure Matrix
This function computes the Structure Matrix for a `psych::fa` object. When using an oblique rotation (e.g., oblimin, promax) in exploratory factor analysis, the factor loadings and correlations between the variables and factors are distinct. The Pattern Matrix contains the loadings while the Structure Matrix contains the correlation between variables and factors. The `psych::fa` function only prints the Pattern Matrix. To get the Structure Matrix, we need to multiple the pattern matrix by the correlations between the factors (e.g., `fit$loadings %*% fit$Phi`). This function performs this operation as well as suppresses correlations below a user-defined threshold and sorts the variables by their correlation with factor for easy reading.

The arguments in the function include:
- `x` Output from `psych::fa` function
- `cut` Correlations less than cut will not be printed; cut defaults to .32

Example `structureMatrix(fa_1, .4)` 

You can download the file [here](/files/software/structureMatrix.R) or source it directly from the website
	source("https://lrocconi.github.io/files/software/structureMatrix.R")
	structureMatrix(fa_1, .4)

## Item Complexity
This function compute Hoffman's item complexity index. This is mainly for teaching and demonstration purposes since item complexity is returned by default in `psych::fa`. Item complexity is an indication of simple structure (i.e., items should load highly onto one factor and have weak loadings on others). Students often ask why the item complexity for particular item is greater than 2 when only one loading is displaying for that item? The issue arises when suppressing loadings less than a certain value. The weak loadings across multiple factors is usually what is causing the complexity score to be greater than 2. To help students better understand item complexity, I wrote this function. Simply, supply the function a vector of factor loadings and it will compute item complexity.

Example `complexity(c(.40, .29, .10, .03, .01, .04))`

You can download the file [here](/files/software/complexity.R) or source it directly from the website
	source("https://lrocconi.github.io/files/software/complexity.R")

## Clean Matrix
This function removes rows and columns from a correlation matrix. This is useful when performing an exploratory factor analysis using a correlation matrix and one needs to drop a variable from the analysis. 

The arguments in the function include:
-  `matrix` The name of matrix object to clean
- `vars` A list of variables to drop from the matrix

Example `cleanMatrix(myMatrix, c(var1, var3, var7))`

You can download the file [here](/files/software/cleanMatrix.R) or source it directly from the website
	source("https://lrocconi.github.io/files/software/cleanMatrix.R")

## Monte Carlo Confidence Interval for Indirect Effects
This function `mcci` computes Mote Carlo confidence intervals for indirect effects when performing path analysis using OLS regression. This macro is based on the discussion on inferences for indirect effects from  Darlington & Hayes (2017, pp. 455-464) *Regression analysis and linear models*.

The arguments in the function include:
- `b1` Unstandardized coefficient for direct effect
- `se1` Standard error of `b1`
- `b2` Unstandardized coefficient for moderator effect
- `se2` Standard error of `b2`
- `seed` Random number seed, defaults to 3000
- `digits` Number of digits to round output, defaults to 4.  

Each argument is required. *Note:* Currently only compute 95% CI. 

Example `mcci(.365, .066, .725, .058)`   

You can download the file [here](/files/software/mcci.R) or source it directly from the website
	source("https://lrocconi.github.io/files/software/mcci.R")
	mcci(.365, .066, .725, .058)


# SPSS
## An SPSS Macro for Computing Confidence Intervals for Effect Sizes
Until recently (e.g., SPSS 27), SPSS did not compute standardized mean difference effect sizes (e.g., Cohen's d) for users when performing an independent samples or paired samples t-tests. It currently still does not compute variance explained effect sizes (e.g., eta-squared) for these analyses. This macro computes Cohen's d, Hedge's g, Eta-Squared, and Omega-Squared for independent, dependent, and single sample t-tests and their confidence intervals based off of the non-central t parameter. 

The arguments in the macro include:
- `N1` Sample size for group 1
- `N2` Sample size for group 2
- `CL` Confidence Level (an integer, defaults to 95)
- `paired` (0, 1) Indicates independent or dependent/single sample t-test (Defaults to 0 or an independent design) 
- `obs_t` The observed t value 

The macro name is `!ESCI` and must be called first. Values must be specified for `N1` and `obs_t`. `N2` is not required for the dependent and single sample t-tests. The `paired` argument is used to indicate which test you are conducting: 0 = independent and is the default, 1 = paired/dependent or single sample design. The `CL` argument is optional, and will default to a 95% confidence level. The CL must be indicated in whole numbers (i.e., 95 for 95% and 90 for 90%). The `obs_t` argument must be the last argument, the order for the rest of the arguments does not matter.

Example 99% CI for an independent samples t-test:
	!ESCI N1=20 N2=15 CL=99 obs_t=.87. 

Example 90% CI for a dependent samples t-test:
	!ESCI paired=1 CL=90 N1=18 obs_t=3.126. 

Example 95% CI for single-sample t-test:
	!ESCI N1=36 CL=95 paired=1 obs_t=2.95.

You can download the file [here](/files/software/EffectSizeCI.sps) or source it directly from the website
	insert file = "https://lrocconi.github.io/files/software/EffectSizeCI.sps"
	!ESCI N1=20 N2=15 CL=99 obs_t=.87. 

## Monte Carlo Confidence Interval for Indirect Effects
This macro computes Mote Carlo confidence intervals for indirect effects when performing path analysis using OLS regression. This macro is based on the discussion on inferences for indirect effects from  Darlington & Hayes (2017, pp. 455-464) *Regression analysis and linear models*.

The arguments in the macro include:
- `b1` Unstandardized coefficient for direct effect
- `se1` Standard error of `b1`
- `b2` Unstandardized coefficient for moderator effect
- `se2` Standard error of `b2`
- `seed` Random number seed, defaults to 3000. 

The macro name is `!mcci` and must be called first. Each argument is required. 

Example `!mcci b1 = .365 se1 = .066 b2 = .725 se2 = .058 seed= 12345.`   

You can download the file [here](/files/software/MonteCarloCI.sps) or source it directly from the website
	insert file = "https://lrocconi.github.io/files/software/MonteCarloCI.sps"
	!mcci b1 = .365 se1 = .066 b2 = .725 se2 = .058 seed= 12345.
	
