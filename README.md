# nf-cynapse <!-- omit in toc -->

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

| Branch  |                   GitHub Action Status                    |
| :-----: | :-------------------------------------------------------: |
|  main   |    ![pre-commit][pre-commit-main] ![build][build-main]    |
| develop | ![pre-commit][pre-commit-develop] ![build][build-develop] |

Repository for nextflow tool definitions.

- [Intent](#intent)
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

[build-develop]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/build.yaml/badge.svg?branch=develop
[build-main]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/build.yaml/badge.svg?branch=main
[cynapse-ccri-quay]: https://quay.io/organization/cynapse-ccri
[git-flow]: https://datasift.github.io/gitflow/IntroducingGitFlow.html
[hub-flow]: https://datasift.github.io/gitflow/TheHubFlowTools.html
[lifebit-web]: https://www.lifebit.ai/
[pre-commit]: https://pre-commit.com/
[pre-commit-develop]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/pre-commit.yaml/badge.svg?branch=develop
[pre-commit-main]: https://github.com/cynapse-ccri/nf-cynapse/actions/workflows/pre-commit.yaml/badge.svg?branch=main
