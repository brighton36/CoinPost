# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # This allows us to edit the item when the user is on the preview action
  if $('#new_back_btn').length > 0
    $('#new_back_btn').click (e) ->
      $("#new_item").attr("action", $('#new_back_btn').attr('value'))

  # Initialize the jquery-file-upload controls    
  if $('#fileupload').length > 0
    window.locale = {
      "fileupload": {
        "errors": {
          "maxFileSize": "File is too big",
          "minFileSize": "File is too small",
          "acceptFileTypes": "Filetype not allowed",
          "maxNumberOfFiles": "Max number of files exceeded",
          "uploadedBytes": "Uploaded bytes exceed file size",
          "emptyResult": "Empty file upload result"
        },
        "error": "Error",
        "start": "Upload File",
        "cancel": "Cancel",
        "destroy": "Delete"
      }
    }
    $('#fileupload').fileupload(
      autoUpload: true
    )
    $('#fileupload').bind 'fileuploaddone', (e,data) ->
      if $('#fileupload table tbody tr').length >= 6
        $('#item_image_add_file').addClass 'disabled'
        $('#item_image_add_file input').attr 'disabled', 'disabled'
          
    $('#fileupload').bind 'fileuploaddestroy', (e,data) ->
      if $('#fileupload table tbody tr').length == 6
        $('#item_image_add_file').removeClass 'disabled'
        $('#item_image_add_file input').removeAttr 'disabled'

    $('#fileupload').each( ->
      that = this
      $.getJSON(this.action, (result) ->
        if (result && result.length)
          $(that).fileupload('option', 'done').call(that, null, {result: result})
      )
    )

  if $('#item_price_input').length > 0
    for event in ['click', 'select']
      $('#item_price_in_currency_price').on event,  ->
        $('#price_currency_BTC').prop('checked', false)
        $('#price_currency_other').prop('checked', true)
      $('#item_price_in_btc').on event,  ->
        $('#price_currency_other').prop('checked', false)
        $('#price_currency_BTC').prop('checked', true)

  if $('#submit_to_reddit').length > 0
    $('#submit_to_reddit').bind 'ajax:before', ->
      # Remove the old errors
      $(@).find('.alert-error').slideUp()
      $(@).find('.control-group').removeClass('error')
      $(@).find('.help-inline').remove()

      # Loading Indicators:
      button = $(@).find('button')
      button.addClass('disabled')
      button.attr('disabled', 'disabled')
      $(@).find('.loading_indicator').removeClass('hidden')

    $('#submit_to_reddit').bind 'ajax:complete', ->
      button = $(@).find('button')
      button.removeClass('disabled')
      button.removeAttr('disabled', 'disabled')
      $(@).find('.loading_indicator').addClass('hidden')

    $('#submit_to_reddit').bind 'ajax:success', (evt, xhr) ->
      $('#submit_to_reddit').fadeOut()
      $('#submit_to_reddit_success').fadeIn()

    $('#submit_to_reddit').bind 'ajax:error', (evt, xhr) ->
      response = $.parseJSON(xhr.responseText)

      if response.error_banner
        $(@).find('.alert-error .error_banner').html(response.error_banner)
        $(@).find('.alert-error').slideDown()

      captcha_controls = $(@).find('.control-group.captcha')
      if response.captcha_iden?
        $(@).find('#reddit_iden').val(response.captcha_iden)
        $(@).find('#captcha_iden').attr 'src', 
          "http://www.reddit.com/captcha/#{response.captcha_iden}.png"
        captcha_controls.slideDown()
      else if captcha_controls.css('display') != 'none'
        captcha_controls.slideUp()

      for attr, errors of response.errors
        control_group = $("#reddit_#{attr}").parents('.control-group')
        control_group.addClass('error')
        control_group.find('.controls').last().append(
          "<div class=\"help-inline\">#{errors.join(", ")}</div>")
        console.log attr
