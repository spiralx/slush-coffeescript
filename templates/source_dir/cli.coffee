
<%= app_name_camel %> = require './<%= app_name_slug %>'


# -----------------------------------------------------------------------------

# Called to parse command-line arguments and kick off the module.
parse = exports.parse = (args) ->
  console.dir args
  <%= app_name_camel %>.hello()
