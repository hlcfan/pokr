Array.prototype.clean = function(deleteValue) {
  for (var i = 0; i < this.length; i++) {
    if (this[i] == deleteValue) {         
      this.splice(i, 1);
      i--;
    }
  }
  return this;
};

Array.prototype.remove = function(v) {
  this.splice(this.indexOf(v) == -1 ? this.length : this.indexOf(v), 1);
}
