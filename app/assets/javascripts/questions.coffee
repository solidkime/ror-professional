ready = ->
  $('body').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

$(document).on('turbolinks:load', ready)