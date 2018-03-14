PgSearch.multisearch_options = {
  :using => {
    :tsearch => { :dictionary  => 'english'},
    :trigram => {
      :threshold => 0.4
    }
  }
  # :ignoring => :accents
}
