## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(EGM)

## ----eval=TRUE----------------------------------------------------------------
# Locate the WFDB files in the package
dir_path <- system.file('extdata', package = 'EGM')

# Read the same data in both digital and physical units
ecg_digital <- read_wfdb(
  record = "muse-sinus",
  record_dir = dir_path,
  units = "digital"
)

ecg_physical <- read_wfdb(
  record = "muse-sinus",
  record_dir = dir_path,
  units = "physical"
)

# Examine the header to see the conversion parameters
head(ecg_digital$header)
#>   file_name storage_format ADC_gain ADC_baseline ADC_units ADC_resolution
#> 1  muse-sinus.dat      16      200            0        mV             16
#> 2  muse-sinus.dat      16      200            0        mV             16
#> 3  muse-sinus.dat      16      200            0        mV             16
#> 4  muse-sinus.dat      16      200            0        mV             16
#> 5  muse-sinus.dat      16      200            0        mV             16
#> 6  muse-sinus.dat      16      200            0        mV             16

## ----eval=TRUE----------------------------------------------------------------
# Extract the first 10 samples from lead II
digital_values <- ecg_digital$signal$II[1:10]
physical_values <- ecg_physical$signal$II[1:10]

# Get the conversion parameters for lead II from the header
lead_ii_row <- ecg_digital$header[ecg_digital$header$label == "II", ]
gain <- lead_ii_row$ADC_gain
baseline <- lead_ii_row$ADC_baseline

# Create a comparison table
comparison <- data.frame(
  sample = 1:10,
  digital = digital_values,
  physical = round(physical_values, 3),
  calculated_physical = round((digital_values - baseline) / gain, 3)
)

print(comparison)
#>    Sample Digital Physical Calculated
#> 1       1       5    0.025      0.025
#> 2       2       5    0.025      0.025
#> 3       3       5    0.025      0.025
#> 4       4      10    0.050      0.050
#> 5       5      10    0.050      0.050
#> 6       6      10    0.050      0.050
#> 7       7      10    0.050      0.050
#> 8       8      15    0.075      0.075
#> 9       9      20    0.100      0.100
#> 10     10      24    0.120      0.120

# Verify the conversion formula
cat("\nLead II conversion parameters:\n")
cat("  Gain:", gain, "ADC units/mV\n")
cat("  Baseline:", baseline, "ADC units\n")
#> Lead II conversion parameters:
#>   Gain: 200 ADC units/mV
#>   Baseline: 0 ADC units

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

