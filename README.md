# nf-cynapse <!-- omit in toc -->

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

| Branch  |       GitHub Action Status        |
| :-----: | :-------------------------------: |
|  main   |  ![pre-commit][pre-commit-main]   |
| develop | ![pre-commit][pre-commit-develop] |

Repository for nextflow tool definitions.

- [Intent](#intent)
- [Use](#use)
  - [Sample data](#sample-data)
- [Development](#development)
  - [hub-flow](#hub-flow)
  - [nextflow](#nextflow)
  - [Versioning](#versioning)
- [pre-commit](#pre-commit)
  - [Coding guidance](#coding-guidance)

Although nf-core is an excellent project the integration cycle and code ownership can become an issue.  More specifically
several of the tools used here are not easily built with conda (without additional overhead) so only containers are present.

## Intent

This repo has been created to manage the creation of workflows used in the CYNAPSE analysis platform (provided by [Lifebit][lifebit-web]).

Where possible containers managed by the tool authors will be referenced.  Where not available items will be added to the
quay.io [cynapse-ccri][cynapse-ccri-quay] organisation space (with corresponding GitHub repo).

## Use

The examples here use the reference bundles described on the [dockstore-cgpwgs wiki][cgpwgs-refs].

Example command follows, please specify the variables:

```bash
nextflow run -with-report -profile ... \
  -c $REPO_PATH/workflows/cancerit/cgpPindel/cgpPindel-somatic.config \
  $REPO_PATH/workflows/cancerit/cgpPindel/cgpPindel-somatic.nf \
    --genomefa $REF_BASE/genome.fa \
    --tumour $DATA_MT \
    --normal $DATA_WT \
    --simrep $REF_BASE/pindel/simpleRepeats.bed.gz \
    --filter $REF_BASE/${PROTOCOL}_Rules.lst \
    --genes $REF_BASE/codingexon_regions.indel.bed.gz \
    --unmatched $REF_BASE/pindel_np.gff3.gz \
    --seqtype $PROTOCOL \
    --assembly $REF_BUILD \
    --species "$SPECIES" \
    --exfile $REF_BASE/pindel/exclude.lst \
    --badloci $REF_BASE/HiDepth.bed.gz \
    --softfil $REF_BASE/softRules.lst
```

Ensure the correct `-profile`s are specified, e.g.

```bash
nextflow run -with-report -profile singularity,slurm \
  ...
```

If overriding default memory and CPU for testing purposes (e.g. tincy datasets like e.g. just chr21):

```bash
# append, don't forget \ continuation on existing command
    --max_cpus 1 \
    --max_memory 6 \
    --max_time 1
```

### Sample data

Data from a cell line can be obtained from the dockstore-cgpwgs data (GRCh37/NCBI37).  This is be retrieved via:

```bash
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829.bam
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829.bam.bai
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829.bam.bas
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829-BL.bam
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829-BL.bam.bai
wget http://ngs.sanger.ac.uk/production/cancer/dockstore/cgpwgs/sampled/COLO-829-BL.bam.bas
```

For testing purposes cgpPindel will function well with a single chromosome.

```bash
samtools view --write-index -bo COLO-829_21.bam COLO-829.bam 21
samtools view --write-index -bo COLO-829-BL_21.bam COLO-829-BL.bam 21
# copy the BAS file
cp COLO-829.bam.bas COLO-829_21.bam.bas
cp COLO-829-BL.bam.bas COLO-829-BL_21.bam.bas
```

## Development

### hub-flow

Please follow the [git-flow] process for branching and releases.  As part of this please use the [hub-flow]
tools to manage your workspace.  These install correctly under Windows when using the git-bash extensions.

### nextflow

Nextflow can not be executed on Windows without using Windows Subsystem for Linux.  Speak to your team for details of
working practices where a linux environment is required.

### Versioning

This project uses the `<year>.<month>[.<inc>]` method for versioning:

- First release of Jan `2022.01`
- Subsequent releases in same month `2022.01.01`

The individual tools have versions aligned to the tool release, the repo release is for user convenience when referencing
rather than use commit IDs.

## pre-commit

In order to provide a level of coding standards and assurance this project has pre-commit hooks.

Where possible pre-commit hooks are executed as part of CI and block progress, to ensure this is minimised activate checking
in your local environment.  Please see the [pre-commit] docs for how to do this.

If new file types are added please check to see if hooks are available to validate these and implement as necessary in
`.pre-commit-config.yaml`.

### Coding guidance

Please see the relevant [`tools`](tools/README.md) or `workflows`(workflows/README.md) README files.

See `tools/cancerit/cgpPindel` and `workflows/cancerit/cgpPindel` for a complete example.

<!-- refs -->

[cgpwgs-refs]: https://github.com/cancerit/dockstore-cgpwgs/wiki/Reference-archives
[cynapse-ccri-quay]: https://quay.io/organization/cynapse-ccri
[git-flow]: https://datasift.github.io/gitflow/IntroducingGitFlow.html
[hub-flow]: https://datasift.github.io/gitflow/TheHubFlowTools.html
[lifebit-web]: https://www.lifebit.ai/
[pre-commit]: https://pre-commit.com/
[pre-commit-develop]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/pre-commit.yaml/badge.svg?branch=develop
[pre-commit-main]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/pre-commit.yaml/badge.svg?branch=main
