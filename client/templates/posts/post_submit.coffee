Template.postSubmit.events 'submit form': (e) ->
  e.preventDefault()
  post =
    url: $(e.target).find('[name=url]').val()
    title: $(e.target).find('[name=title]').val()

  errors = validatePost post
  if errors.title || errors.url
    return Session.set 'postSubmitErrors', errors

  Meteor.call 'postInsert', post, (error, result) ->
    if error
      return throwError error.reason
    if result.postExists
      throwError 'This link has already been posted'
    Router.go 'postPage', _id: result._id

# clear error list whenever postsubmit is opened
Template.postSubmit.onCreated ->
  Session.set 'postSubmitErrors', {}
  return

Template.postSubmit.helpers
  errorMessage: (field) ->
    Session.get('postSubmitErrors')[field]
  errorClass: (field) ->
    if !!Session.get('postSubmitErrors')[field] then 'has-error' else '';
