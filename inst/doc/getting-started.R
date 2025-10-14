## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(EGM)

## -----------------------------------------------------------------------------
# Read in data
fp <- system.file('extdata', 'muse-sinus.xml', package = 'EGM')
xml <- readLines(fp)
head(xml)

# Instead, can read this in as a MUSE XML file
# Now as an `egm` class
ecg <- read_muse(fp)
ecg

# Can now plot this easily
ggm(ecg) + 
  theme_egm_light()

## -----------------------------------------------------------------------------
# Read in data
fp <- system.file('extdata', 'bard-avnrt.txt', package = 'EGM')
bard <- readLines(fp)
head(bard, n = 20)

# Instead, read this as signal, breaking apart header and signal data
# Presented as an `egm` class object
egram <- read_bard(fp)
egram

# Similarly, can be visualized with ease
ggm(egram, channels = c('HIS', 'CS', 'RV'), mode = NULL) +
	theme_egm_dark() 

