# NOTE: Bump the version after ANY changes
#
#= require vendor_preload_config
#= require browser_compatibility/localstorage-polyfill
#= require es6-promise
#= require fastclick
#= require jquery
#= require jquery.animate-enhanced
#= require headroom.js/dist/headroom.js
#= require headroom.js/dist/jQuery.headroom.js
#  require vide
#= require isotope/dist/isotope.pkgd
#= require typeahead.js/dist/bloodhound.js
#= require handlebars/handlebars.runtime.js
#= require underscore
#= require backbone
#= require backbone-filtered-collection
#  require backbone_query/backbone-query
#= require backbone-relational
#= require Backbone.BindTo
#= require Backbone.Handlebars
#= require pace
#  require moment
#  require utility/boba-0.0.2

$ ->
  FastClick.attach(document.body)