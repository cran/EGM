## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(EGM)

## -----------------------------------------------------------------------------
# Create annotations for detected R-peaks
# Example
ann <- annotation_table(
  annotator = "qrs",
  sample = c(100, 350, 600, 850),
  type = "N",
  frequency = 250,
  channel = 0
)

# Print
ann

## -----------------------------------------------------------------------------
# Load internal annotation data
beat_symbols <- c("N", "L", "R", "a", "V", "F", "J", "A", "S", "E", "j", "/", "Q", "~")
beat_labels <- EGM:::.surface_annotations[EGM:::.surface_annotations$symbol %in% beat_symbols, ]

knitr::kable(
  beat_labels[, c("symbol", "mnemonic", "description")],
  col.names = c("Symbol", "Mnemonic", "Description"),
  row.names = FALSE,
  caption = "Beat Annotation Types"
)

## -----------------------------------------------------------------------------
wave_symbols <- c("p", "t", "u", "(", ")")
wave_labels <- EGM:::.surface_annotations[EGM:::.surface_annotations$symbol %in% wave_symbols, ]

knitr::kable(
  wave_labels[, c("symbol", "mnemonic", "description")],
  col.names = c("Symbol", "Mnemonic", "Description"),
  row.names = FALSE,
  caption = "Waveform Boundary Annotations"
)

## -----------------------------------------------------------------------------
rhythm_symbols <- c("+", "|", "s", "T", "~", "x")
rhythm_labels <- EGM:::.surface_annotations[EGM:::.surface_annotations$symbol %in% rhythm_symbols, ]

knitr::kable(
  rhythm_labels[, c("symbol", "mnemonic", "description")],
  col.names = c("Symbol", "Mnemonic", "Description"),
  row.names = FALSE,
  caption = "Rhythm and Signal Quality Annotations"
)

## -----------------------------------------------------------------------------
special_symbols <- c("*", "D", "\"", "=", "!", "[", "]", "@", "r", "^", "B", "e", "n", "f")
special_labels <- EGM:::.surface_annotations[EGM:::.surface_annotations$symbol %in% special_symbols, ]

knitr::kable(
  special_labels[, c("symbol", "mnemonic", "description")],
  col.names = c("Symbol", "Mnemonic", "Description"),
  row.names = FALSE,
  caption = "Specialized Annotations"
)

## ----eval=FALSE---------------------------------------------------------------
# # View all standard ECG annotation types
# wfdb_annotation_labels()
# 
# # Filter for specific symbols
# wfdb_annotation_labels(symbol = c("N", "V", "A"))
# 
# # Decode annotations in an existing annotation table
# ann <- annotation_table(
#   annotator = "example",
#   sample = c(100, 200),
#   type = c("N", "V")
# )
# 
# # Add human-readable descriptions
# wfdb_annotation_decode(ann)

## ----eval=FALSE---------------------------------------------------------------
# # Read an ECG with annotations
# record_path <- system.file('extdata', package = 'EGM')
# ecg <- read_wfdb(
#   record = "muse-sinus",
#   record_dir = record_path
# )
# 
# # Read associated annotations (if they exist)
# ann <- read_annotation(
#    record = "muse-sinus",
#    annotator = "ecgpuwave",
#    record_dir = record_path
# )
# 
# # Decode annotation types
# ann_decoded <- wfdb_annotation_decode(ann)
# head(ann_decoded)

