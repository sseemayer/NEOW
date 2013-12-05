numeral = require 'numeral'

root = exports ? this

root.isk = (amount, suffix=" ISK") ->
  numeral(amount).format('0,0.00') + suffix


SHORT_ISK_SUFFIXES = [
  [750000000000, 1e12, 'T']
  [750000000,    1e9 , 'B']
  [750000,       1e6 , 'M']
  [9999,         1e3 , 'K']
  [0,            1   , ' ']
]

root.iskShort = (amount, suffix=" ISK") ->
  for [limit, factor, exp_suffix] in SHORT_ISK_SUFFIXES
    if amount >= limit
      return root.isk(amount / factor,  exp_suffix + suffix)

root.romanSkill = ['0', 'I', 'II', 'III', 'IV', 'V']
