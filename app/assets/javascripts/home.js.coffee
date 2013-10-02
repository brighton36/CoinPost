# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  if $('#admin_message').length > 0
    $('#repeat_question').click ->
      $('#message_sent_successfully').fadeOut 'fast', -> 
        $('#ask_admin_question').fadeIn 'fast', ->

    form = $('#admin_message')

    $(form).bind "ajax:beforeSend", ->
      window.disable_form_controls @, '.btn'
      window.clear_form_errors @

    $(form).bind "ajax:error", (xhr, status, error) ->
      window.form_errors_from_ajax @, status          
      window.enable_form_controls @, '.btn'

    $(form).bind "ajax:success", (data, status, xhr) ->
      form = $(@)
      $('#ask_admin_question').fadeOut 'fast', -> 
        $('#message_sent_successfully').fadeIn 'fast', ->
          window.enable_form_controls form, '.btn'
          form.find('#message_subject').val('')

          if tinymce?
            tinymce.get(form.find('textarea').attr('id')).setContent('')
          else
            form.find('#message_body').val('')
