'use strict'

path = require 'path'
fs = require 'fs'

inquirer = require 'inquirer'
assign = require 'object-assign'

prompts = require './prompts'
{ dict } = require './utils'


# ----------------------------------------------------------------------------

getDefaultAnswers = () ->
   dict([p.name, p.default ? ''] for p in prompts)


# ----------------------------------------------------------------------------

loadConfigFile = () ->
  # configFile = path.join __dirname, 'slushproject.json'

  configFile = path.join process.cwd(), './slush-config.json'
  return null unless fs.existsSync configFile

  assign {}, getDefaultAnswers(), require configFile


# ----------------------------------------------------------------------------

getTaskConfig = exports.getTaskConfig = (callback) ->
  config = loadConfigFile()

  return callback(config) if config

  inquirer.prompt prompts, (answers) ->
    return callback() unless answers.__continue

    callback answers
