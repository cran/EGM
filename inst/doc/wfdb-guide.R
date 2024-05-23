## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(EGM)

## ----eval=FALSE---------------------------------------------------------------
#  set_wfdb_path("wsl /usr/local/bin")

## -----------------------------------------------------------------------------
fp <- system.file('extdata', 'muse-sinus.xml', package = 'EGM')
ecg <- read_muse(fp)
fig <- ggm(ecg) + theme_egm_light()
fig

## -----------------------------------------------------------------------------
# Let x = 10-second signal dataset
# We will apply this across the dataset
# This is an oversimplified approach.
find_peaks <- function(x,
                       threshold = 
                         mean(x, na.rm = TRUE) + 2 * sd(x, na.rm = TRUE)
                       ) {
  
  # Ensure signal is "positive" for peak finding algorithm
  x <- abs(x)
  
  # Find the peaks
  peaks <- which(diff(sign(diff(x))) == -2) + 1
  
  # Filter the peaks
  peaks <- peaks[x[peaks] > threshold]
  
  # Return
  peaks
}

# Create a signal dataset
dat <- extract_signal(ecg)

# Find the peaks
sig <- dat[["I"]]
pk_loc <- find_peaks(sig)
pk_val <- sig[pk_loc]
pks <- data.frame(x = pk_loc, y = pk_val)

# Plot them
plot(sig, type = "l")
points(x = pks$x, y = pks$y, col = "orange")

## -----------------------------------------------------------------------------
# Find the peaks
raw_signal <- dat[["I"]]
peak_positions <- find_peaks(raw_signal)
peak_positions

# Annotations do not need to store the value at that time point however
# The annotation table function has the following arguments
args(annotation_table)

# We can fill this in as below using additional data from the original ECG
hea <- ecg$header
start <- attributes(hea)$record_line$start_time
hz <- attributes(hea)$record_line$frequency

ann <- annotation_table(
  annotator = "our_pks",
  sample = peak_positions,
  type = "R",
  frequency = hz,
  channel = "I"
)

# Here are our annotations
ann

# Then, add this back to the original signal
ecg$annotation <- ann
ecg

