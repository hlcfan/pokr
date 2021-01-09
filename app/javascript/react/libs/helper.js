export function ieBrowser11() {
  let trident = {
    string: navigator.userAgent.match(/Trident\/(\d+)/)
  }

  trident.version = trident.string ? parseInt(trident.string[1], 10) : null;
  if (trident.version === 7 || trident.version === 6) {
    return true
  } else {
    return false
  }
}

export function  jiraTicketUrlForApi(clientUrl) {
  // http://localhost:8080/rest/api/2/issue/POK-1
  // http://localhost:8080/browse/POK-4
  const anchorTag = document.createElement('a')
  anchorTag.href = clientUrl
  const matches = /\/browse\/(.*)/.exec(anchorTag.pathname)
  return matches && `${anchorTag.origin}/rest/api/2/issue/${matches[1]}`
}

export function jiraTicketUrlForClient(apiUrl) {
  const anchorTag = document.createElement("a")
  anchorTag.href = apiUrl
  const matches = /\/rest\/api\/2\/issue\/(.*)/.exec(anchorTag.pathname)
  return matches && `${anchorTag.origin}/browse/${matches[1]}`
}

export function jiraHostFromUrl(url) {
  const anchorTag = document.createElement("a")
  anchorTag.href = url
  return anchorTag.origin
}
