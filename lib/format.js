(function() {
  var SHORT_ISK_SUFFIXES, numeral, root;

  numeral = require('numeral');

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.isk = function(amount, suffix) {
    if (suffix == null) {
      suffix = " ISK";
    }
    return numeral(amount).format('0,0.00') + suffix;
  };

  SHORT_ISK_SUFFIXES = [[750000000000, 1e12, 'T'], [750000000, 1e9, 'B'], [750000, 1e6, 'M'], [9999, 1e3, 'K'], [0, 1, ' ']];

  root.iskShort = function(amount, suffix) {
    var exp_suffix, factor, i, len, limit, ref;
    if (suffix == null) {
      suffix = " ISK";
    }
    for (i = 0, len = SHORT_ISK_SUFFIXES.length; i < len; i++) {
      ref = SHORT_ISK_SUFFIXES[i], limit = ref[0], factor = ref[1], exp_suffix = ref[2];
      if (amount >= limit) {
        return root.isk(amount / factor, exp_suffix + suffix);
      }
    }
  };

  root.romanSkill = ['0', 'I', 'II', 'III', 'IV', 'V'];

}).call(this);
