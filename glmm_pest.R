# ------------------------------------------------------------------------------------------------------
#
# glmm code for 
#
# Spatio-temporal patterns of crops and agrochemicals in Canada over 35 years
# Egina Malaj, Levi Freistadt, Christy A. Morrissey
#
# Contact: eginamalaj@gmail.com
#
# ------------------------------------------------------------------------------------------------------
# GLMMs for difference between years for agrochemicals
# ------------------------------------------------------------------------------------------------------
#
require(glmmTMB)
require(emmeans)
require(DHARMa)
require(car)
require(ggplot2)
require(cowplot) # for plot_grid
# 
#
load(file="pestls.RData")# data saved as pestls
#
#
# Agrochemicals
#
# Test Difference between years - using raw data
#
###### Insecticides
inst<-pestls$ins; inst[2:4] <- lapply(inst[2:4], factor)
#
# Change order of regions
inst$REGION <- factor(inst$REGION, levels = c("PACIFIC","PRAIRIE","CENTRAL","ATLANTIC"))
#
hist(inst$insPrc); range(inst$insPrc) # nonnormal & proportion
i_mod<-glmmTMB(data=inst, insPrc~C_YEAR*REGION +(1|CDUID),dispformula = ~C_YEAR, family="beta_family") 
#
# check assumptions - OK - beta distribution fits relatively well
i_sim<- simulateResiduals(fittedModel = i_mod, n = 250)
x11();plot(i_sim)
testDispersion(i_sim) # n.s. p-value indicates no under/overdispersion
#
# 
#test for overall interaction effect
ins_anv<-Anova(i_mod,type="II",test="Chisq")
#
# Post-hoc
# Pairs of years per region
ins_m<-emmeans(i_mod, pairwise~C_YEAR|REGION, type = "response")
#
#
###### Fungicides
fungt<-pestls$fung; fungt[2:4] <- lapply(fungt[2:4], factor)
#
# Change order of regions
fungt$REGION <- factor(fungt$REGION, levels = c("PACIFIC","PRAIRIE", "CENTRAL", "ATLANTIC"))
#
hist(fungt$funPrc); range(fungt$funPrc) # nonnormal & proportion
fn_mod<-glmmTMB(data=fungt, funPrc~C_YEAR*REGION +(1|CDUID),dispformula = ~C_YEAR,  family="beta_family")
fn_sim<- simulateResiduals(fittedModel = fn_mod, n = 250)
x11();plot(fn_sim)
testDispersion(fn_sim) # n.s. p-value indicates no under/overdispersion
fn_anv<-Anova(fn_mod,type="II",test="Chisq")
fn_m<-emmeans(fn_mod, pairwise ~ C_YEAR | REGION, type = "response")
#
#
###### Herbicides
herbt<-pestls$herb; herbt[2:4] <- lapply(herbt[2:4], factor)
#
# Change order of regions
herbt$REGION <- factor(herbt$REGION, levels = c("PACIFIC","PRAIRIE", "CENTRAL", "ATLANTIC"))
#
# Remove 2 values with herbPrc >1 - beta model only works with 0-1 values
herbt<- herbt[!herbt$herPrc>1,]
hist(herbt$herPrc); range(herbt$herPrc) # nonnormal & proportion & values >1
herb_mod<-glmmTMB(data=herbt, herPrc~C_YEAR*REGION +(1|CDUID),dispformula = ~C_YEAR,family="beta_family")
herb_sim<- simulateResiduals(fittedModel = herb_mod, n = 250)
x11();plot(herb_sim)
testDispersion(herb_sim) # n.s. p-value indicates no under/overdispersion
herb_anv<-Anova(herb_mod,type="II",test="Chisq")
herb_m<-emmeans(herb_mod, pairwise ~ C_YEAR | REGION, type = "response")
#
#
###### Fertilizers
fertt<-pestls$fert; fertt[2:4] <- lapply(fertt[2:4], factor)
#
# Change order of regions
fertt$REGION <- factor(fertt$REGION, levels = c("PACIFIC","PRAIRIE", "CENTRAL", "ATLANTIC"))
#
# Remove values with herbPrc >1 - beta model only works with 0-1 values
fertt<- fertt[!fertt$fertPrc>1,]
#
hist(fertt$fertPrc); range(fertt$fertPrc) # proportion
ft_mod<-glmmTMB(data=fertt, fertPrc~C_YEAR*REGION +(1|CDUID), family="beta_family")
ft_sim<- simulateResiduals(fittedModel = ft_mod, n = 250)
x11();plot(ft_sim)
testDispersion(ft_sim) # n.s. p-value indicates no under/overdispersion
ft_anv<-Anova(ft_mod,type="II",test="Chisq")
ft_m<-emmeans(ft_mod, pairwise ~ C_YEAR | REGION, type = "response")
#
#
## Plotting
#
ins_plot<- plot(ins_m, comparisons = TRUE, horizontal = FALSE, colors = c("black", "orange", "orange","red"))+
  facet_wrap(~ REGION, nrow=1, strip.position="top")+
  theme_bw(base_size = 24)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour="black", size=18),
        axis.text.y = element_text(colour="black", size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  labs(y = "Insecticide Use", x = "")

fn_plot<- plot(fn_m, comparisons = TRUE, horizontal = FALSE, colors = c("black", "blue", "blue","red"))+
  facet_wrap(~ REGION, nrow=1, strip.position="top")+
  theme_bw(base_size = 24)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour="black", size=18),
        axis.text.y = element_text(colour="black", size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  labs(y = "Fungicide Use", x = "")

herb_plot<- plot(herb_m, comparisons = TRUE, horizontal = FALSE, colors = c("black", "green", "green","red"))+
  facet_wrap(~ REGION, nrow=1, strip.position="top")+
  theme_bw(base_size = 24)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour="black", size=18),
        axis.text.y = element_text(colour="black", size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  labs(y = "Herbicide Use", x = "")

ft_plot<- plot(ft_m, comparisons = TRUE, horizontal = FALSE, colors = c("black", "black", "black","red"))+
  facet_wrap(~ REGION, nrow=1, strip.position="top")+
  theme_bw(base_size = 24)+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour="black", size=18),
        axis.text.y = element_text(colour="black", size=20),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  labs(y = "Fertilizer Use", x = "")

x11(width =30, height=20)
ag_plot<-plot_grid(ins_plot,fn_plot,herb_plot,ft_plot,nrow = 2) 
ggsave("agrochem_change.tiff", dpi=500, compression = "lzw", width =30, height=20, plot = ag_plot)

