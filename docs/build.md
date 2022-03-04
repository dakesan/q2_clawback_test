# Building conda environment

## About

q2-clawbackプラグインの性能を確かめるために行った検討に関するdocsです。

原則、2022年3月現在で最新のバージョンでテストをしています。

## Command

```bash
mamba create -n qiime2_clawback -f=q2_clawback_env.yaml
```

## Test

```bash
conda activate qiime2_clawback

#❯ qiime clawback --help
#Usage: qiime clawback [OPTIONS] COMMAND [ARGS]...
#
#  Description: This QIIME 2 plugin provides support for generating
#  generating class weights for use with the feature-classifier
#
#  Plugin website: https://github.com/BenKaehler/q2-clawback
#
#  Getting user support: Please post to the QIIME 2 forum for help with this
#  plugin: https://forum.qiime2.org
#
#Options:
#  --version            Show the version and exit.
#  --example-data PATH  Write example data and exit.
#  --citations          Show citations and exit.
#  --help               Show this message and exit.
#
#Commands:
#  assemble-weights-from-Qiita     Assemble weights from Qiita for use with
#                                  q2-feature-classifier
#
#  fetch-Qiita-samples             Fetch feature counts for a collection of
#                                  samples
#
#  generate-class-weights          Generate class weights from a set of samples
#  sequence-variants-from-samples  Extract sequence variants from a feature
#                                  table
#
#  summarize-Qiita-metadata-category-and-contexts
#                                  Fetch Qiita sample types and contexts
```
