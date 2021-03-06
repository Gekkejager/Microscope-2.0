Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: ->
    [
      Meteor.subscribe 'notifications'
    ]

Router.route '/post/:_id',
  name: 'postPage'
  waitOn: ->
    [
      Meteor.subscribe 'singlePost', @params._id
      Meteor.subscribe 'comments', @params._id
    ]
  data: -> Posts.findOne @params._id

Router.route '/posts/:_id/edit',
  name: 'postEdit'
  waitOn: ->
    Meteor.subscribe 'singlePost', @params._id
  data: -> Posts.findOne @params._id

Router.route '/submit', name: 'postSubmit'

Router.route '/',
  name: 'postsList'

requireLogin = ->
  if ! Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'accessDenied'
  else
    @next()


Router.onBeforeAction requireLogin, only: 'postSubmit'
Router.onBeforeAction 'dataNotFound', only: 'postPage'
