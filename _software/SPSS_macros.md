---
title: "Talk 2 on Relevant Topic in Your Field"
collection: software
title: "SPSS Macros"
permalink: /software/SPSS-macros
---

# SPSS Macros

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
	`!ESCI N1=20 N2=15 CL=99 obs_t=.87.` 

Example 90% CI for a dependent samples t-test:
	`!ESCI paired=1 CL=90 N1=18 obs_t=3.126.` 

Example 95% CI for single-sample t-test:
	`!ESCI N1=36 CL=95 paired=1 obs_t=2.95.`

You can download the file [here](/files/software/EffectSizeCI.sps) or source it directly from the website: `insert file = "https://lrocconi.github.io/files/software/EffectSizeCI.sps".`


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

You can download the file [here](/files/software/MonteCarloCI.sps) or source it directly from the website: `insert file = "https://lrocconi.github.io/files/software/MonteCarloCI.sps".`

