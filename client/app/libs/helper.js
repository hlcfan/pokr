export default {
  ieBrowser11() {
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
}