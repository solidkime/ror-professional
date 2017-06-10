ready = ->
  $('body').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
  $('.best-answer').closest('.container_answer').find('.mark-best-button').hide();

$(document).on('turbolinks:load', ready)