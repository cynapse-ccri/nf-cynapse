#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

// all params defined before inclusion are available in the module scope
include { pindel_pl as tool_pindel_pl } from './tools/cancerit/cgpPindel/pindel_pl'
include { flagvcf_pl as tool_flagvcf_pl } from './tools/cancerit/cgpPindel/FlagVcf_pl'

// used in various places, here to simplify
def repository_name = 'cynapse-ccri/cynapse-nf'
def workflow_path = 'workflows/cancerit/cgpPindel'
def tool = 'cgpPindel-somatic'

def helpMessage() {
    log.info """
    Usage:
        The typical command for running the pipeline is as follows:

        nextflow run https://github.com/${repository_name}/blob/master/${workflow_path}/${tool}.nf [Options]

    Required parameters:
        --genomefa    Path to reference genome file *.fa[.gz]
        --tumour      Tumour BAM/CRAM file (co-located index and bas files)
        --normal      Normal BAM/CRAM file (co-located index and bas files)
        --simrep      Full path to tabix indexed simple/satellite repeats.
        --filter      VCF filter rules file (see FlagVcf.pl for details)
        --genes       Full path to tabix indexed coding gene footprints.
        --unmatched   Full path to tabix indexed gff3 of unmatched normal panel
                        - see pindel_np_from_vcf.pl
    Optional
        --seqtype   Sequencing protocol, expect all input to match [WGS]
        --assembly  Name of assembly in use
                      -  when not available in BAM header SQ line.
        --species   Species
                      -  when not available in BAM header SQ line.
        --exclude   Exclude this list of ref sequences from processing, wildcard '%'
                      - comma separated, e.g. NC_007605,hs37d5,GL%
        --exfile    Exclude this list of ref sequences from processing, wildcard '%'
                      - one name per-line
        --badloci   Tabix indexed BED file of locations to not accept as anchors
                      - e.g. hi-seq depth from UCSC
        --skipgerm  Don't output events with more evidence in normal BAM.
        --softfil   VCF filter rules to be indicated in INFO field as soft flags
        --debug     Don't cleanup workarea on completion.
        --apid      Analysis process ID (numeric) - for cgpAnalysisProc header info
                      - not necessary for external use
    Resource Options (only impacts pindel_pl, not flagging):
        --max_cpus      Maximum number of CPUs (int)
                        (default: $params.max_cpus)
        --max_memory    Maximum memory (GB)
                        (default: $params.max_memory)
        --max_time      Maximum time (h)
                        (default: $params.max_time)
        """.stripIndent()
}

// definitions

// define the workflow
workflow {
    // This is the workflow for direct use as a stand-alone
    // Show help message
    if ( params.help ) {
        helpPindelMessage()
        exit 0
    }

    main:
        // setup tuples for index inclusion
        mt = tuple file(params.tumour), file("${params.tumour}.bai")
        wt = tuple file(params.normal), file("${params.normal}.bai")
        badloci = tuple file(params.badloci), file("${params.badloci}.tbi")
        genome = tuple file(params.genomefa), file("${params.genomefa}.fai")
        genes = tuple file(params.genes), file("${params.genes}.tbi")
        unmatched = tuple file(params.unmatched), file("${params.unmatched}.tbi")
        simrep = tuple file(params.simrep), file("${params.simrep}.tbi")
        excludeFile = Channel.fromPath(params.excludeFile, checkIfExists:false)

        unmatched_ext = params.unmatched.contains('gff3') ? 'gff3' : 'bed'

        main:
        pindel(
            genome, badloci,
            mt, wt,
            species, assembly, seqtype,
            exclude, excludeFile
        )
        pindel_flag(
            unmatched_ext,
            filter,
            genes,
            unmatched,
            simrep,
            pindel.out.vcf,
            softfil,
            apid,
        )

    emit:
    pindel_reads_mt = pindel.mt_out
    pindel_reads_mt =  pindel.wt_out
    pindel_vcf =  pindel.vcf
    pindel_vcf_flagged =  pindel_flag.out
}

// Workflow completion notification
// workflow.onComplete {
// }

// CUSTOM process definitions
// Only when not appropriate to define a tool
// e.g. bash file transforms, still needs an appropriate container
