class window.BtcAmount
  constructor: (@amount_in_cents) ->
  toString: ->
    # Split the fractional part and the whole:
    amount_parts = /([\d]*?)([\d]{0,8})$/.exec(@amount_in_cents.toString())

    # We wish to comma separate the groupings of three in the whole part of 
    # the number
    whole = "0" 
    if amount_parts[1].length > 0 
      whole = amount_parts[1].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")

    cents = amount_parts[2]
   
    # Let's pad the string if we have to:
    cents = '0' + cents while cents.length < 8

    # This ensures that we always display, at most, one zero after the last 
    # fractional part
    cents = cents.replace(/(.*?)[0]*$/, '$1')
   
    # We need to at least indicate '0' if the cents component is empty
    cents = "0" if cents? or cents is ''
    [whole,cents].join('.')
