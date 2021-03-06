if Posts.find().count() == 0
  now = new Date().getTime()

  tomId = Meteor.users.insert profile: name: 'Tom Coleman'
  tom = Meteor.users.findOne tomId

  sachaId = Meteor.users.insert profile: name: 'Sacha Greif'
  sacha = Meteor.users.findOne sachaId

  telescopeId = Posts.insert
    title: 'Introducing Telescope'
    userId: sacha._id
    author: sacha.profile.name
    url: 'http://sachagreif.com/introducing-telescope/'
    submitted: new Date(now - 7 * 3600 * 1000)
    commentsCount: 2

  Comments.insert
    postId: telescopeId
    userId: tom._id
    author: tom.profile.name
    submitted: new Date(now - 5 * 3600 * 1000)
    body: 'How do you do ms. Greif?'

  Comments.insert
    postId: telescopeId
    userId: sacha._id
    author: sacha.profile.name
    submitted: new Date(now - 3 * 3600 * 1000)
    body: 'Shut up Tom'

  Posts.insert
    title: 'Meteor'
    userId: tom._id
    author: tom.profile.name
    url: 'http://meteor.com'
    submitted: new Date(now - 13 * 3600 * 1000)
    commentsCount: 0

  Posts.insert
    title: 'The Meteor Book'
    userId: tom._id
    author: tom.profile.name
    url: 'http://themeteorbook.com'
    submitted: new Date(now - 300 * 3600 * 1000)
    commentsCount: 0

  i = 0
  while i < 40
    Posts.insert
      title: 'Test post #' + i
      userId: tom._id
      author: tom.profile.name
      url: 'http://google.com/?q=test-' + i
      submitted: new Date((now - 290 * 3600 * 1000) + i * 500)
      commentsCount: 0
    i++
