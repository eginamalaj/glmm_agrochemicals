# Change in agrochemicals across Canada over the last 35 years

This file contains part of the R code to run glmm published with the article:

**Malaj, E.**, Freistadt L, Morrissey CA. (2020). Spatio-Temporal Patterns of Crops and Agrochemicals in Canada Over 35 Years. *Frontiers in Environmental Science* 8, https://doi.org/10.3389/fenvs.2020.556452

The original datasets and full R code produced from this study are available at: Federated Research Data Repository (FRDR) https://doi.org/10.20383/101.0272

To run this analysis the `pestls.RData` is needed that contains four different datasets for insecticides, fungicides, herbicides and fertilizers.

Summarized, here I assess whether the proportion of land area to which agrochemicals were applied varied over census years and across different regions of Canada using the Census Division (CD) unit level in order to retain the hierarchical structure of the data. I used generalized linear mixed models (GLMMs) with beta distribution and logit link function to account for non-normal and continuous-based, proportional data (0–1) via the `glmmTMB` package (https://doi:10.32614/rj-2017-066). These models will improve statistical inference and reduce biased estimates when compared to the alternative of raw data transformation. Four GLMMs were constructed to assess responses in the proportion of cropland treated with agrochemicals (fertilizers, herbicides, fungicides, insecticides) with the following structure: 

(i) census years (1981-2016), region (Pacific, Prairie, Central, and Atlantic) and their interactions as fixed effects; 
(ii) CD unit as a random intercept term. 

Residuals and assumptions of each model were checked using “DHARMa” package (https://cran.r-project.org/web/packages/DHARMa/index.html). An example of the residual diagnostics for insecticides is shown below. Outlier, dispersion and KS tests are all not significant (n.s.).


![residuals](https://user-images.githubusercontent.com/54320408/100787514-64faa600-33d9-11eb-956a-971a39140070.png)


Contrasts of model retained fixed effects were calculated using Type II Wald chi-squared likelihood-ratio tests, and for significant effects, the comparison between different levels (i.e., year as fixed effect across different regions) was evaluated with multiple pairwise comparisons (Tukey’s HSD). 

Odds ratios (OR) were used to evaluate the performance of pairwise comparisons for changes in agrochemicals and crop classes over time. An OR < 1 indicates lower odds of occurrence in the earlier rather than the later census year, and an OR > 1 indicates higher odds of occurrence in the earlier rather than the later census year. Effects were considered statistically significant for p-values smaller than 0.05.

Plotted these contrasts are shown below. Black dots represent estimated marginal means (also known as least squared means) for each year across census division units. Colored bars represent 95% confidence intervals, which are shown in purple for landscape simplification and in green for insecticide use. Red arrows allow statistical comparisons between years, where non-overlapping arrows show that the comparison is significantly different at p-value 0.05. 

![agrochem_change](https://user-images.githubusercontent.com/54320408/100788021-20bbd580-33da-11eb-8360-c12c7666d2ed.png)









