function storyLinkHref(link) {
  if (link.isValidUrl()) {
    return link;
  } else {
    return "javascript:;"
  }
}

function copyToClipboard() {
  var aField = document.getElementById("hiddenField");
  aField.hidden = false;
  if (!aField.value) {
    aField.value = window.location.href;
  }
  aField.select();
  document.execCommand("copy");
  aField.hidden = true;
}
