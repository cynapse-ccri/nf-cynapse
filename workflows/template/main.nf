#!/usr/bin/env nextflow
nextflow.preview.dsl = 2

def repository_name = 'cynapse-ccri/????'
def workflow_path = 'workflows/template'
def tool = 'example'

def helpMessage() {
    log.info """
    Usage:
        The typical command for running the pipeline is as follows:

        nextflow run https://github.com/${repository_name}/blob/master/${workflow_path}/${tool}.nf [Options]

        Inputs Options:
        --input         Input file
        Resource Options:
        --max_cpus      Maximum number of CPUs (int)
                        (default: $params.max_cpus)
        --max_memory    Maximum memory (memory unit)
                        (default: $params.max_memory)
        --max_time      Maximum time (time unit)
                        (default: $params.max_time)

        See here for more info: https://github.com/${repository_name}/blob/master/${workflow_path}/${tool}.md
    """.stripIndent()
}

// import modules
include templateTool from '../tools/template.nf'

// definitions
def workspace = params.outdir

// define the workflow
workflow {
//
}

// Workflow completion notification
workflow.onComplete {
}

// CUSTOM process definitions
// Only when not appropriate to define a tool
// e.g. bash file transforms, still needs an appropriate container
