Meteor.publish 'posts', (limit, sort) ->
  Posts.find({}, {limit:limit, sort: sort})
#  Counts.publish this, 'totalPostCount', Posts.find({}, {limit:limit, sort: submitted: -1})
#  return
  #check options,
    #limit: Number,
    #sort: Object
  #Posts.find({}, options)

Meteor.publish 'singlePost', (postId) ->
  check postId, String
  Posts.find postId

Meteor.publish 'comments', (postId) ->
  check postId, String
  Comments.find postId: postId

Meteor.publish 'notifications', ->
  Notifications.find(userId: @userId, read: false)
