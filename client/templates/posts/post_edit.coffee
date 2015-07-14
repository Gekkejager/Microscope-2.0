Template.postEdit.onCreated ->
  Session.set 'postEditErrors', {}

Template.postEdit.helpers
  errorMessage: (field) ->
    Session.get('postEditErrors')[field]
  errorClass: (field) ->
    if !!Session.get('postEditErrors') then 'has-error' else ''

Template.postEdit.events
  'submit form': (e) ->
    e.preventDefault()

    currentPostId = @_id

    postProperties =
      url: $(e.target).find('[name=url]').val()
      title: $(e.target).find('[name=title]').val()

    errors = validatePost postProperties
    if errors.title || errors.url
      return Session.set 'postEditErrors', errors

    #Posts.update currentPostId, $set: postProperties, (error, result) ->
    Meteor.call 'postUpdate', currentPostId, postProperties, (error, result) ->
      if error
        return throwError error.reason
      if result.postExists
        throwError('Duplicate');
      Router.go 'postPage', _id: currentPostId

  'click .delete': (e) ->
    e.preventDefault()

    if confirm('Delete this post?')
      currentPostId = this._id
      Posts.remove(currentPostId)
      Router.go 'postsList'
