'use strict'



# ----------------------------------------------------------------------------

loadProjectConfig = () ->
  # configFile = path.join __dirname, 'slushproject.json'
  configFile = path.join process.cwd(), './slushproject.json'

  if fs.existsSync configFile
    config = require configFile
    utils.dict [p.name, config[p.name] ? p.default ? ''] for p in prompts


# ----------------------------------------------------------------------------

getConfig = exports.getConfig = (questions, done) ->

