# The QcExperiment Package

## Introduction & Motivation

The package `ngsReports` is able to parse multiple types of QC reports and general log files produced by a multitude of bioinformatics tools.
However, a pivotal weakness of the package is the lack of metadata data in key objects.
This is additionally compounded by the lack of regularity across tools and the modular nature of many reports, such as those provided by `FastQC`, `fastp` and even `cutadapt`.
Notably:

- `FastqcDataList` and `FastpDataList` objects are essentially lists without metadata
- `FastQC` operates on single Fastq files, whilst `Fastp` analyses paired-end data together
- Modules are only defined for `FastqcData*` and `FastpData*` objects

For methylation and gene expression data, a `SummarizedExperiment` is a unifying structure, capable of supporting multiple assays.
Samples and sample-level data is effectively placed within columns. whilst feature and feature-level data is effectively placed along rows
Sample-level metadata is specifically contained with a `colData` slot, whilst feature-level metadata is contained within the `rowData` slot.
If features represent genome-level information, a `rowRanges` element can supplement the `rowData`.
This layout is essentially *rectangular-data* as a single measure for each sample will be contained in each assay.

The intent for `QcExperiment` is to create a unifying and foundational structure for QC reports from any tool.

## Design Considerations

### Overall Structure

A `QcExperiment` object will require both sample metadata and modules stored within a single object.
Whilst information will always focussed at the sample level, features will change profoundly for each tool, report or module within a report.
As such, these objects are not intrinsically rectangular.
Whilst using a basic `S4` structure may be viable, an `S7` structure may also be worth considering.
If using conventional `S4` structures (e.g. a `DataFrame`), determining how this will interact with the `tidyOmics` objects will also be important.
Perhaps a simple `show` wrapper like `tidyOmics` may be a good strategy.

### Sample Metadata

A possible structure might be to hold sample-level metadata in either `rowData` or `colData`, whilst each `module` could be stored in the equivalent of an `assay`.
Without restrictions on the second dimension, each module could be fixed in one direction (equivalent to samples) and flexible in another.
The initial sensible choice might be for metadata to be rowData as the requirements are fundamentally different than for a `SummarizedExperiment`.
If this is the best approach, `rowData` could be returned by default with any module

### Module Structure

Many modules additionally contain layered information, such as that inside fastp json reports, meaning that a generic `S3` `data.frame` may be a poor choice for an individual module.
This leaves `S4 DataFrame`, `data.table` or `tibble` objects as the core structure of choice.
It may be plausible to utilise a more formal `QcModule` class which extends the base `data.table`/`tibble`/`DataFrame` class by adding additional metadata such as the:

1. tool name (e.g. STAR, bwa)
2. tool version
3. command-line parameters as executed

noting that the latter two may be problematic if doing parameters sweeps or any other process involving multiple runs on the same sample.

**NB:** `DFrame`/`DataFrame` objects may already have the required structure for this given the existing slots. 
The defined `metadata` could simply be fixed for a class of `QcModule`.

Perhaps a `getModule()` function could include an argument `as_tbl = TRUE`?

### Classes and Extensibility

The base class should be a `QcExperiment` object which can be extended to `FastqcExperiment` or `FastpExperiment` objects which enable specific operations.
These two classes could include things like total reads, paired-end etc
Each module should be stored as a `QcModule`.

### Methods

Where possible, methods can be written for the base `QcExperiment` object.
Notably, combining and subsetting should be implemented at that level, as well as for the `QcModule` class

