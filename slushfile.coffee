'use strict'

gulp = require 'gulp'
$ = require('gulp-load-plugins')(config: "#{__dirname}/package.json")

us = require 'underscore.string'

path = require 'path'
fs = require 'fs'

utils = require './lib/utils'
{ getTaskConfig } = require './lib/config'
prompts = require './lib/prompts'


# ----------------------------------------------------------------------------

loadProjectConfig = () ->
  # configFile = path.join __dirname, 'slushproject.json'
  configFile = path.join process.cwd(), './slushproject.json'

  if fs.existsSync configFile
    config = require configFile
    utils.dict [p.name, config[p.name] ? p.default ? ''] for p in prompts


# ----------------------------------------------------------------------------

run = (answers, done) ->
  answers.app_name_slug = us.slugify answers.app_name
  answers.app_name_camel = utils.camelCase answers.app_name

  d = new Date()
  answers.year = d.getFullYear()
  answers.date = d.toISOString().split('T')[0]

  tmpl_dir = "#{__dirname}/templates"

  files = [
    "#{tmpl_dir}/source_dir/app_name_slug.coffee"
    "#{tmpl_dir}/test_dir/app_name_slug.spec.coffee"
    "#{tmpl_dir}/_gitignore"
    "#{tmpl_dir}/_editorconfig"
    "#{tmpl_dir}/package.json"
    "#{tmpl_dir}/README.md"
    "#{tmpl_dir}/gulpfile.*"
    "#{tmpl_dir}/coffeelint.json"
    "#{tmpl_dir}/LICENSE_#{answers.license}"
  ]

  if answers.bin
    files.push "#{tmpl_dir}/bin_dir/app_name_slug"
    files.push "#{tmpl_dir}/source_dir/cli.coffee"

  if answers.compiled
    answers.main_file = "./#{answers.build_dir}/#{answers.app_name_slug}"
    answers.lib_dir = answers.build_dir
  else
    answers.main_file = './index'
    answers.lib_dir = answers.source_dir

    files.push "#{tmpl_dir}/index.js"

  # console.info '-----------------------'
  # console.info JSON.stringify answers, null, '  '
  # console.info '-----------------------'
  # console.info files.join '\n'
  # console.info '-----------------------'


  gulp.src files, { base: tmpl_dir }
    .pipe $.template answers
    .pipe $.rename (file) ->
      file.basename = utils.applyRenames file.basename, answers
        .replace "LICENSE_#{answers.license}", 'LICENSE'
        .replace /^_/, '.'
      file.dirname  = utils.applyRenames file.dirname, answers
      return
    .pipe $.conflict './'
    .pipe gulp.dest './'
    .pipe $.install()
    .on 'end', done

  return


# ----------------------------------------------------------------------------

gulp.task 'default', (done) ->
  getTaskConfig (answers) ->
    run answers, done

  return
