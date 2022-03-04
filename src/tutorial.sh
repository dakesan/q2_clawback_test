#!/bin/bash


wget -O "test/85_otus.fasta" "https://data.qiime2.org/2018.6/tutorials/training-feature-classifiers/85_otus.fasta"
wget -O "test/85_otu_taxonomy.txt" "https://data.qiime2.org/2018.6/tutorials/training-feature-classifiers/85_otu_taxonomy.txt"
wget -O "test/rep-seqs.qza" "https://data.qiime2.org/2018.6/tutorials/filtering/sequences.qza"
wget -O "test/table.qza" "https://data.qiime2.org/2018.6/tutorials/filtering/table.qza"
wget -O "test/sample-metadata.tsv" "https://data.qiime2.org/2018.6/tutorials/moving-pictures/sample_metadata.tsv"

# import data 
qiime tools import \
    --type 'FeatureData[Sequence]' \
    --input-path ./test/85_otus.fasta \
    --output-path ./test/85_otus.qza

qiime tools import \
    --type 'FeatureData[Taxonomy]' \
    --input-format HeaderlessTSVTaxonomyFormat \
    --input-path ./test/85_otu_taxonomy.txt \
    --output-path ./test/ref-taxonomy.qza

# get empo_3 available data
# this causes an error
qiime clawback summarize-Qiita-metadata-category-and-contexts \
    --p-category empo_3 \
    --o-visualization ./test/available_empo3.qzv

# extract reads with primer sequences
qiime feature-classifier extract-reads \
    --i-sequences ./test/85_otus.qza \
    --p-f-primer GTGYCAGCMGCCGCGGTAA \
    --p-r-primer GGACTACNVGGGTWTCTAAT \
    --o-reads ./test/ref-seqs-v4.qza

qiime feature-classifier fit-classifier-naive-bayes \
    --i-reference-reads ./test/ref-seqs-v4.qza \
    --i-reference-taxonomy ./test/ref-taxonomy.qza \
    --o-classifier ./test/uniform-classifier.qza

qiime clawback assemble-weights-from-Qiita \
    --i-classifier uniform-classifier.qza \
    --i-reference-taxonomy ./test/ref-taxonomy.qza \
    --i-reference-sequences ./test/ref-seqs-v4.qza \
    --p-metadata-key empo_3 \
    --p-metadata-value "Animal surface" \
    --p-context ./test/Deblur-Illumina-16S-V4-150nt-780653 \
    --o-class-weight ./test/animal-surface-weights.qza

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ./test/ref-seqs-v4.qza \
  --i-reference-taxonomy ./test/ref-taxonomy.qza \
  --i-class-weight ./test/animal-surface-weights.qza \
  --o-classifier ./test/animal-surface-classifier.qza

qiime feature-table filter-samples \
  --i-table table.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-where "BodySite!='gut'" \
  --o-filtered-table no-gut-table.qza

qiime feature-table filter-seqs \
  --i-data rep-seqs.qza \
  --i-table no-gut-table.qza \
  --o-filtered-data no-gut-seqs.qza

qiime feature-classifier classify-sklearn \
  --i-classifier animal-surface-classifier.qza \
  --i-reads no-gut-seqs.qza \
  --o-classification taxonomy.qza

qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv


