Meteor.publish 'posts', (options) ->
  check options,
    limit: Number,
    sort: Object
  Posts.find({}, options)

Meteor.publish 'singlePost', (postId) ->
  check postId, String
  Posts.find postId

Meteor.publish 'comments', (postId) ->
  check postId, String
  Comments.find postId: postId

Meteor.publish 'notifications', ->
  Notifications.find(userId: @userId, read: false)
