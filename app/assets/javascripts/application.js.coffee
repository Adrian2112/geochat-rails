## This is a manifest file that'll be compiled into application.js, which will include all the files
## listed below.
##
## Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
## or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
##
## It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
## the compiled file.
##
## WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
## GO AFTER THE REQUIRES BELOW.
##
##= require jquery
##= require jquery_ujs
##= require vendor
##= require_tree .

window.geochat = {}

#setea los attributos de location
lat = null
lon = null
success = (position) ->
  lat = position.coords.latitude
  lon = position.coords.longitude

  console.log("lat #{lat}")
  console.log("lon #{lon}")
  foursquare_api()

error = () ->
    "error gelocation"

#peticion de lugares a foursqueare
foursquare_api = (params) ->
  if typeof params != typeof {}
    params = {}

  api_params = {
    client_id: "clientId"
    client_secret: "clientSecret"
    v: moment().format("YYYYmmdd")
    limit: 20
    ll: "#{lat},#{lon}"
  }
  $.extend(api_params,params)
  
  $.ajax({
    url: "https://api.foursquare.com/v2/venues/search"
    data: api_params
    dataType: "json"
    beforeSend: ->
      $("#places_list").html("<img src='/assets/spinner.gif' />")
    success: (data) ->
      window.geochat.places = $.map data.response.venues, (e, i) ->
        {name: e.name, id: e.id}
      refresh_places(window.geochat.places)
  })

refresh_places = (places) ->
  html = Handlebars.compile($("#places_tmpl").html())
  $("#places_list").html(html({places: places}))


append_message = (message) ->
  html = Handlebars.compile($("#place_tmpl").html())
  $("#messages").append(html(message))
  scroll_to_bottom()

@scroll_to_bottom = () ->
  $("#messages").scrollTop($("#messages")[0]?.scrollHeight)

@announce_user = (user) ->
  $("#messages").append("<div>"+JSON.stringify(user)+"</div>")
  scroll_to_bottom()

jQuery ->
  scroll_to_bottom()
  $("#new_message input.text").focus()

  if $("#places_list").length != 0
    navigator.geolocation.getCurrentPosition(success, error)

  $("form#place_query input.query").observe_field 0.5, ->
    places = geochat.places || []
    query = this.value
    re = new RegExp(query, "i")
    
    matched_places = $.map places, (e,i) ->
      if e.name.match(re) then e else null

    if matched_places.length != 0 and query != ""
      refresh_places(matched_places)
    else
      foursquare_api({query: query})

   $("form#place_query").submit ->
     foursquare_api({query: $(this).children(".query").val()})
     return false
   
   $("form#new_message").submit (e) ->
     $.ajax {
       url: $(this).data("action")
       data: $(this).serialize()
       type: "POST"
     }

     $(this).children(".text").val("")
     e.preventDefault()

  $("abbr.timeago").livequery ->
    $(this).timeago()
