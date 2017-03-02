function storyLinkHref(link) {
  if (link.isValidUrl()) {
    return link;
  } else {
    return "javascript:;"
  }
}