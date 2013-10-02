$(document).ready ->
  if $('#mark_fulfilled_modal').length > 0
    for a in $("a[rel='mark_fulfilled']")
      $(a).bind 'click.show_mark_fulfilled', (e) ->
        e.preventDefault()
        modal = $('#mark_fulfilled_modal')
        modal.find('form').attr('action', $(this).attr('href'))
        modal.find('#purchase_item_title').text($(this).attr('title'))
        modal.modal('toggle')

    # This resets the form controls to their default values in a modal-minimize
    # for the case of a purchase modal:
    $('#mark_fulfilled_modal').on 'hidden', ->
      $('#purchase_fulfillment_notes').val('')

    # This ensures that a click to the close button after a purchase, reloads
    # the page.
    $('#mark_fulfilled_modal form').bind "ajax:success", (data, status, xhr) ->
      if status == true
        $(this).find('.close').bind 'click.default_redirection', (e) ->
          window.location = $('#mark_fulfilled_modal form .close_actions a').attr('href')
          e.stopImmediatePropagation()

  if $('form.leave_feedback').length > 0
    for form in $('form.leave_feedback')
      $(form).bind "ajax:beforeSend", ->
        window.disable_form_controls this, '.actions .btn'
        window.clear_form_errors this

      $(form).bind "ajax:error", (xhr, status, error) ->
        window.form_errors_from_ajax this, status          
        window.enable_form_controls this, '.actions .btn'

      $(form).bind "ajax:success", (data, status, xhr) ->
        if status == true
          form = this
          $(this).find('.feedback_row').slideUp 500, ->
            window.enable_form_controls form

  # This resets the form controls to their default values in a modal-minimize
  # for the case of a purchase modal:
  if $('#item_purchase_modal').length > 0 
    $('#item_purchase_modal').on 'hidden', ->
      $('#purchase_quantity_purchased').val('1')

    $('#item_purchase_modal form').bind "ajax:success", (data, status, xhr) ->
      $(this).find('.modal-body_success .btc_money .amount').text(
        (new BtcAmount(status.total_in_cents)).toString() )

      # This ensures that a click to the close button after a purchase, reloads
      # the page.
      $(this).find('.close').bind 'click.default_redirection', (e) ->
        window.location = $('#item_purchase_modal form .close_actions a').attr('href')
        e.stopImmediatePropagation()

