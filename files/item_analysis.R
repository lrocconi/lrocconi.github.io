################################
####  Item Analysis Example ####
################################

# Load packages
library(psych)

# Load data
saq6 <- read.csv(url("https://lrocconi.github.io/files/saq6.csv"))

# These data are a subset of items from Andy Fields' SPSS Anxiety Questionnaire. 

# Response options: Strongly Disagree, Disagree, Neutral, Agree, Strongly Agree

# stat_cry ==	Statistics make me cry.		
# sd_excite ==	Standard deviations excite me.
# corr_attack ==	I dream that Pearson is attacking me with correlation coefficients.
# understand_stat == I don’t understand statistics.
# sleep_eign ==	I can’t sleep for thoughts of eigenvectors.
# duvet_normal ==	I wake up under my duvet thinking that I am trapped under a normal distribution.

# The alpha function from the psych package is a great way to start and computes
# many of the item analysis statistics we discussed.
psych::alpha(saq6)

# Notice the warning message and the low alpha (0.37). This indicates an item
# may need to be reverse coded. We can use the item discrimination to figure our
# which one! In the Item Statistics table, look at the r.drop column. Notice
# that sd_excite has a negative discrimination value. In this case, this item
# should be revise coded, since lower responses on the item "Standard deviations
# excite me" indicate more anxiety.

# Let's reverse code the item and try it again. 
table(saq6$sd_excite)
saq6$sd_excite <- 6 - saq6$sd_excite
table(saq6$sd_excite)
# reverse coding worked!

# Let's re-run alpha
psych::alpha(saq6)

# The alpha is much better (.76) and all the discrimination statistics are
# positive and all within acceptable ranges (.3 to .7). The item duvet_normal
# has the largest item-total correlation (.58) which indicates it best taps into
# the latent construct or best differentiates between those with high and low
# anxiety. The item sleep_eigen has the lowest item-total correlation (but still
# acceptable). Item means (i.e., endorsability) and standard deviation (sd) are
# given in the item statistics table. Item mean indicates location on the latent
# construct and sd provides a measure of respondent variability. We also have a
# table of response frequency for each item, which indicate whether each
# response option was endorsed.

# We can divide the item means the maximum response option to convert the mean
# to a difficulty value ranging from 0 to 1
colMeans(saq6)/5

# Difficulty parameters are all within an acceptable range. The item sleep_eign
# is a on the high end, indicating a high endorsability for this item. Maybe
# this item isn't giving us as much information as the other items about
# anxiety. 

# I like to examine discrmination coefficients for each response option, so I
# wrote a function to compute those for me.
item_distractor <- function(df) {
  # Compute total score for each item
  df$total_score <- rowSums(df)
  
  # Function to calculate point-biserial correlation
  point_biserial <- function(item, total_score) {
    levels <- sort(unique(item))
    correlations <- sapply(levels, function(level) {
      binary <- as.numeric(item == level)
      corrected_total_score <- total_score - as.numeric(as.character(item))
      cor(binary, corrected_total_score, method = "pearson")
          })
    names(correlations) <- levels
    correlations
  }
  
  # Apply the function to each item (excluding 'total_score')
  item_vars <- setdiff(names(df), "total_score")
  correlations <- sapply(df[item_vars], point_biserial, total_score = df$total_score)
  
  # Convert to data frame and set row and column names
  correlations_df <- as.data.frame(correlations)
  
  # Transpose the data frame
  results <- t(correlations_df)
  
  return(results)
}

item_distractor(saq6)

# We want to see negative discrimination values for strongly disagree and
# disagree, indicating those who respond in that category have lower total
# scores (or lower anxiety) and positive correlations for agree and strongly
# agree indicating that people choosing those categories have higher anxiety (as
# reflected in the total score). All of the items follow this patten; however,
# sleep_eign is interesting. There is essentially no correlation between the
# total score those who respond "Strongly disagree" and "Agree". However, very
# few respondents selected "Strongly disagree" for that item (2%) but the
# largest proportion chose "Agree" (37%). Given what all we found about this
# item, we may want to review the item and entertain revisions.

