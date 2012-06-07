$ ->
  atm_heading = $('#atm-heading')
  current_card = $('#current-card')
  loading = $('#loader')
  response_screen = $('#response-screen')
  
  format_balance = (amount) ->
    if parseFloat(amount) < 0.0
      "<span class=red>&pound; #{amount}</span>"
    else
      "&pound; #{amount}"
  
  clear_screen = ->
    $('#balance-screen').hide()
    $("#pin").hide()
    $("#operations-menu").hide()
    $("#amount-menu").hide()
    response_screen.hide()
  
  show_pin = ->
    $("#pin").show()
    
  display_operations_menu = ->
    clear_screen()
    atm_heading.html('Select an operation')
    $('#operations-menu').show()
    
  display_amount_menu = ->
    atm_heading.html('Select amount')
    clear_screen()
    $('#amount-menu').show()
  
  
  $('.debit-cards a').on 'click', (e) ->
    clear_screen()
    $link = $(@)
    balance = if current_card.data('balance') then current_card.data('balance') else $link.data('balance')
    $('#current-card').data
      pin: $link.data('pin')
      balance: balance
      id: $link.data('id')
    e.preventDefault()
    atm_heading.html('Please enter your PIN')
    show_pin()
    
  $('#pin-form').on 'submit', (e) ->
    e.preventDefault()
    $input = $("#pin-number")
    if $input.val().toString() == current_card.data('pin').toString()
      display_operations_menu()
    else
      alert 'Incorrect PIN, please try again.'
    
  $('#display-balance').on 'click', (e) ->
    e.preventDefault()
    $('#balance-screen').html(format_balance(current_card.data('balance'))).show()
    
  $('#withdraw-money').on 'click', (e) ->
    e.preventDefault()
    display_amount_menu()
    
  $('.withdraw').on 'click', (e) ->
    atm_heading.html('Processing request...')
    $link = $(@)
    e.preventDefault()
    clear_screen()
    loading.show()
    response_screen.html('<p>Processing your request...</p>').show()
    $.ajax "/accounts/#{current_card.data('id')}/transactions.json",
      type: "POST",
      data:
        delay: 1
        transaction:
          initiator: 'ATM Machine'
          transaction_type: 'withdrawal'
          amount: parseInt($link.data('amount'))
          account_id: parseInt(current_card.data('id'))
      success: (response) ->
        atm_heading.html('Done!')
        loading.hide()
        response_screen.append('<p>Done!</p>')
        .append("<p>You have withdrawn <b>&pound; #{Math.abs(parseFloat(response.amount))}</b></p>")
        if parseInt(response.overdraft_cost)
          response_screen.append("<p>There was an ovedraft charge of <b>&pound; #{response.overdraft_cost}</b> to this transaction</p>")
        response_screen.append("<p>Your new account balance is <b>#{format_balance(response.balance)}</b></p>")
        response_screen.append("<p>Please collect your cash. Thank you for using CBSE ATM!</p>")
        current_card.data('balance', response.balance)
      error: (response) ->
        atm_heading.html('Error!')
        loading.hide()
        if response.status == 500
          response_screen.append('<p class="red">The server responded with status 500 (Server error)</p>')
        else
          errors = JSON.parse(response.responseText)
          response_screen.append('<p class="red">There was an error while processing your request</p>')
          $.each errors, (key, items) ->
            response_screen.append("<p class=red>#{key}: #{items.join(', ')}</p>")