@Posts = new (Mongo.Collection)('posts')

Posts.allow
  update: (userId, post) ->
    ownsDocument userId, post
  remove: (userId, post) ->
    ownsDocument userId, post

Posts.deny update: (userId, post, fieldNames) ->
  # may only edit the following two fields:
  _.without(fieldNames, 'url', 'title').length > 0

@validatePost = (post) ->
  errors = {}

  if !post.title
    errors.title = "Please fill in a headline"

  if !post.url
    errors.url = "Please fill in a URL"

  return errors

Meteor.methods
  postInsert: (postAttributes) ->
    check @userId, String
    check postAttributes,
      title: String
      url: String

    errors = validatePost postAttributes
    if errors.title || errors.url
      throw new Meteor.Error 'invalid-post', "You must set a title and URL for your post you sneaky bugger"

    postWithSameLink = Posts.findOne(url: postAttributes.url)
    if postWithSameLink
      return {
        postExists: true
        _id: postWithSameLink._id
      }
    user = Meteor.user()
    post = _.extend(postAttributes,
      userId: user._id
      author: user.username
      submitted: new Date)
    postId = Posts.insert(post)
    { _id: postId }

  postUpdate: (currentPostId, postAttributes) ->
    check @userId, String
    check postAttributes,
      title: String
      url: String

    errors = validatePost postAttributes
    if errors.title || errors.url
      throw new Meteor.Error 'invalid-post', "You must set a title and URL for your post you sneaky bugger"

    postWithSameLink = Posts.findOne
      _id: {$ne: currentPostId}
      url: postAttributes.url

    # Check postWithSameLink first, thats false (if thats null),
    # don't continue with right expression (&& instead of &)
    if postWithSameLink && postWithSameLink._id != currentPostId
      return {
        postExists: true
        _id: postWithSameLink._id
      }
    postAttributes editTime: new Date()
    Posts.update currentPostId, $set: postAttributes
    { _id: currentPostId }
