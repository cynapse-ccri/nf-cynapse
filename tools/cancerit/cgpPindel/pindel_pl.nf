process pindel_pl {
    // edit this block
    program_name = 'pindel.pl'
    tool_ver = '3.10.0'
    tool_name = 'cgpPindel'
    container = "quay.io/wtsicgp/cgppindel:${tool_ver}"

    // don't change these (unless sample_id is not applicable)
    tag { "${tool_name } ${program_name } ${sample_id }" }
    label "${tool_name}_${tool_ver}"
    label "${tool_name}_${tool_ver}_${program_name}"
    // makes sure pipelines fail properly, plus errors and undef values
    shell = ['/bin/bash', '-euo', 'pipefail']

    // edit as necessary
    input:
        tuple path('genome.fa'), path('genome.fa.fai')
        tuple path('badloci.bed.gz'), path('badloci.bed.gz.tbi')
        tuple path('mt.bam'), path('mt.bam.bai')
        tuple path('wt.bam'), path('wt.bam.bai')
        val species
        val assembly
        val seqtype
        val outdir
        // optional
        val exclude
        val excludeFile

    output:
        tuple path('*.vcf.gz'), path('*.vcf.gz.tbi'), emit: vcf
        tuple path('*_mt.bam'), path('*_mt.bam.md5'), path('*_mt.bam.bai'), emit: mt_out
        tuple path('*_wt.bam'), path('*_wt.bam.md5'), path('*_wt.bam.bai'), emit: wt_out

    // not running flagging, use a workflow
    script:
        def applySpecies = species != 'NO_SPECIES' ? "-sp $species" : ''
        def applyAssembly = assembly != 'NO_ASSEMBLY' ? "-as $assembly" : ''
        def applyExclude = exclude != 'NO_EXCLUDE' ? "-e $exclude" : ''
        def applyExcludeFile = excludeFile != 'NO_EXCLUDEFILE' ? "-ef $excludeFile" : ''
        """
        pindel.pl -noflag -o result \
        ${applySpecies} \
        ${applyAssembly} \
        ${applyExclude} \
        -r genome.fa \
        -t mt.bam \
        -n wt.bam \
        -b badloci.bed.gz \
        -st ${seqtype} \
        -c ${task.cpus}
        # easier to link the files than use "publishDir saveAs:"
        ln -f result/*.vcf.gz* .
        ln -f result/*_mt.bam* .
        ln -f result/*_wt.bam* .
        """
}
