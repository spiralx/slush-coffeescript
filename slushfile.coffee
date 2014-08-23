"use strict"

gulp = require "gulp"
$ = require("gulp-load-plugins")(config: "#{__dirname}/package.json")

slugify = require("underscore.string").slugify
inquirer = require "inquirer"
path = require "path"

prompts = require './lib/prompts'


# ----------------------------------------------------------------------------

splitext = (fn) ->
  ext = path.extname fn
  [
    path.basename fn, ext
    ext
  ]


applyRenames = (fn, answers) ->
  [name, ext] = splitext fn
  name = answers[name] ? name
  name + ext


# ----------------------------------------------------------------------------

gulp.task 'default', (done) ->
  inquirer.prompt prompts, (answers) ->
    return done() unless answers.__continue

    answers.app_name_slug = slugify answers.app_name

    d = new Date()
    answers.year = d.getFullYear()
    answers.date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate()

    tmpl_dir = "#{__dirname}/templates"

    files = [
      "#{tmpl_dir}/source_dir/**/*.*"
      "#{tmpl_dir}/test_dir/**/*.*"
      "#{tmpl_dir}/_gitignore"
      "#{tmpl_dir}/_editorconfig"
      "#{tmpl_dir}/package.json"
      "#{tmpl_dir}/README.md"
      "#{tmpl_dir}/gulpfile.*"
      "#{tmpl_dir}/coffeelint.json"
      "#{tmpl_dir}/LICENSE_#{answers.license}"
    ]

    files.push "#{tmpl_dir}/bin_dir/**/*.*" if answers.cli

    if answers.compiled
      answers.main_file = "./#{answers.build_dir}/#{answers.app_name_slug}"
      answers.lib_dir = answers.build_dir
    else
      answers.main_file = "./index"
      answers.lib_dir = answers.source_dir

      files.push "#{tmpl_dir}/index.js"
      files.push "!#{tmpl_dir}/source_dir/cli.coffee"

    console.dir answers
    console.info files.join '\n'

    gulp.src files, { base: tmpl_dir }
      .pipe $.template answers
      .pipe $.rename (file) ->
        file.basename = applyRenames file.basename, answers
          .replace "LICENSE_#{answers.license}", 'LICENSE'
          .replace /^_/, '.'
        file.dirname  = applyRenames file.dirname, answers
        return
      .pipe $.conflict './'
      .pipe gulp.dest './'
      # .pipe $.install()
      .on 'end', done

    return

  return
