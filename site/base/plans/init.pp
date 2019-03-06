# entry point plan

plan base(
  TargetSpec $nodes,
) {

  # Install puppet on the target and gather facts
  $nodes.apply_prep

  # Compile the manifest block into a catalog
  apply($nodes) {
    class { 'base': }
  }
}
