###
#Template.postsList.helpers posts: Posts.find {}, sort: submitted: -1
#Template.postList.events



# IF SCROLL = bottom && NEXTPATH exists
  # GO TO NEXTPATH

if Meteor.isServer
  Meteor.publish 'posts', (limit) ->
    return items.find({}, limit: limit})
else if Meteor.isClient
  ITEMS_INCREMENT = 10
  Session.setDefault 'itemsLimit', ITEMS_INCREMENT
  Deps.autorun ->
    Meteor.subscribe 'items', Session.get 'itemsLimit'

  Template.postsList.posts = ->
    items.find()


# If, once the subscription is ready, we have less rows than we
# asked for, weve got all the rows in the collection.
Template.postsList.moreResults = ->
  !(items.find().count() < Session.get 'itemsLimit')

# whenever #showMoreResults becomes visible, retrieve more results
function showMoreVisible() {
    var threshold, target = $("#showMoreResults");
    if (!target.length) return;

    threshold = $(window).scrollTop() + $(window).height() - target.height();

    if (target.offset().top < threshold) {
        if (!target.data("visible")) {
            // console.log("target became visible (inside viewable area)");
            target.data("visible", true);
            Session.set("itemsLimit",
                Session.get("itemsLimit") + ITEMS_INCREMENT);
        }
    } else {
        if (target.data("visible")) {
            // console.log("target became invisible (below viewable arae)");
            target.data("visible", false);
        }
    }
}

# run the above func every time the user scrolls
$(window).scroll(showMoreVisible);
###

# handle.loaded()
# handle.limit()
# handle.ready()
# handle.loadNextPage()
handle = Meteor.subscribeWithPagination 'posts', 20, submitted: -1

Template.postsList.helpers
  posts: Posts.find()
  ready: !handle.ready()

$(window).scroll ->
  if $(window).scrollTop() + $(window).height() == $(document).height()
    handle.loadNextPage()
  #if handle.limit() >= Counts.get 'totalPostCount'
