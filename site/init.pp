# the entry point

plan site {
  # Ensure puppet tools are installed and gather facts for the apply
  apply_prep($nodes)

  apply($nodes) {
    class { 'profiles::disable_puppet': }
  }
}
