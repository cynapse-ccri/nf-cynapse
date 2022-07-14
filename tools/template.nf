process Command {
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
        val(analysis_id)
        tuple(sample_id, path(input_file))

    output:
        tuple(sample_id, path(output_file), emit: output_file)
        path('log.txt', emit: log)

    script:
        """
        tool command ${params.optional} ${analysis_id} ${params.resource_file} ${input_file}
        """
}
