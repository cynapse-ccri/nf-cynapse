# Tools

See:

- `tools/template.nf` for a process template.
- `tools/cancerit/cgpPindel/3.10.0/pindel_pl.nf` for a real example

Both follow these conventions:

- Use `<tool>/<version>/<command>.nf` folder structure for this repository.
- Use the original tool version numbering (exactly)
- Use **CamelCase** for `tool`, `command` and `process` names
- Use **lowercase** with words separated by underscores for `params`, `inputs`, `outputs` and `scripts`.
- Use 4 spaces per indentation level.
- All input and output identifiers should descriptive. Use informative names like unaligned_sequences, reference_genome,
  phylogeny, or aligned_sequences instead of foo_input, foo_file, result, input, output, and so forth.
- Set a (hosted) container for each process.
- Do not define any runtime settings like `cpus`, `memory` and `time` - these belong in the workflow configs.
- Set process parameters on include:
  - `include process from 'path/to/process.nf' params(optional: '')`
- Use separate process input channels as much as possible. Use tuples for linked inputs only.
  ```
  input:
        val(analysis_id)
        tuple(sample_id, path(bam), path(bai))
  ```
- Define named process output channels. This ensures that outputs can be referenced in external scope by their respective
  names. Indicate whether an output channel is optional:
  ```
  output:
        path("my_file.txt", emit: my_file)
        path("my_optional_file.txt",  optional: my_optional_file, emit: my_optional_file)
  ```
- Use `params` for resource files, for example `genome.fasta`, `database.vcf`.

Significant credit to [UMCUGenetics/NextflowModules][umcu-nf-modules] for inspiration.

<!-- refs -->

[umcu-nf-modules]: https://github.com/UMCUGenetics/NextflowModules
