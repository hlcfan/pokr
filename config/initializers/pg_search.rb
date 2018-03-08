PgSearch.multisearch_options = {
  :using => {
    :tsearch => { :dictionary  => 'english'},
    :trigram => {
      :threshold => 0.5
    }
  }
  # :ignoring => :accents
}
