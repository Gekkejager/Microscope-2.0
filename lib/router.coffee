Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  notFoundTemplate: 'notFound'
  waitOn: ->
    [
      Meteor.subscribe 'posts'
      Meteor.subscribe 'comments'
    ]

Router.route '/', name: 'postsList'
Router.route '/post/:_id',
  name: 'postPage'
  data: -> Posts.findOne @params._id
Router.route '/posts/:_id/edit',
  name: 'postEdit'
  data: -> Posts.findOne @params._id
Router.route '/submit', name: 'postSubmit'

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