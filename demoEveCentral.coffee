neow = require './src'

client = new neow.EveCentralClient()


priceComparator = (inverse=false) ->
  (a, b) ->
    ap = parseFloat(a.price)
    bp = parseFloat(b.price)
    if inverse
      [ap, bp] = [bp, ap]

    if ap < bp
      return -1
    else if ap > bp
      return 1
    else
      return 0

client.fetch('quicklook', typeid: 31866, regionlimit: 10000002)
  .get('quicklook')
  .then (data) ->
    regions = (for reg in data.regions.region
      reg.replace(/^\s+|\s$/g, '')
    ).join(", ")

    console.log "Market statistics for #{data.itemname} in #{regions}"

    console.log ""
    console.log "Sell orders"

    data.sell_orders.order.sort priceComparator()
    data.buy_orders.order.sort priceComparator(true)

    for so in data.sell_orders.order
      console.log "#{so.station_name} (#{so.security}): #{so.vol_remain} items @ #{neow.format.isk(so.price)}"

    console.log ""
    console.log "Buy orders"

    for so in data.buy_orders.order
      console.log "#{so.station_name} (#{so.security}): #{so.vol_remain} items @ #{neow.format.isk(so.price)}"

  .done()
