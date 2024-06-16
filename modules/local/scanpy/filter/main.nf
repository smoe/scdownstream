process SCANPY_FILTER {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/scanpy:1.10.1--ea08051addf267ac':
        'community.wave.seqera.io/library/scanpy:1.10.1--0c8c97148fc05558' }"

    input:
    tuple val(meta), path(h5ad)

    output:
    tuple val(meta), path("*.h5ad"), emit: h5ad
    path "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    args   = task.ext.args   ?: 'min_genes=1'
    args2  = task.ext.args2  ?: 'min_cells=1'
    prefix = task.ext.prefix ?: "${meta.id}"
    template 'filter.py'
}
