"use strict"

gulp = require "gulp"
$ = require("gulp-load-plugins")()
slugify = require("underscore.string").slugify
inquirer = require "inquirer"


# ----------------------------------------------------------------------------

gulp.task 'default', (done) ->
  inquirer.prompt require("./prompts.coffee"), (answers) ->
    return done() unless answers.__continue

    answers.app_name_slug = slugify answers.app_name

    d = new Date()
    answers.year = d.getFullYear()
    answers.date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate()

    files = [
      # __dirname + "/templates/**"
      # "!" + __dirname + "/templates/node_modules/**"
      # "!" + __dirname + "/templates/node_modules/"
      # "!" + __dirname + "/templates/LICENSE_" + if answers.license is 'MIT' then 'BSD' else 'MIT'
      "templates/**/(!LICENSE_)*.*"
      "templates/LICENSE_#{answers.license}"
    ]

    answersLookup = (key) ->
      answers[key] or key

    gulp.src files
      .pipe $.template answers
      .pipe $.rename (file) ->
        file.basename = file.basename
          .replace "LICENSE_#{answers.license}", 'LICENSE'
          .replace /\w*_dir/g, answersLookup
          .replace /^_/, '.'
        file.dirname  = file.dirname.replace /\w*_dir/g, answersLookup
        return
      .pipe $.conflict './'
      .pipe gulp.dest './'
      .pipe $.install()
      .on 'end', done

    return

  return
