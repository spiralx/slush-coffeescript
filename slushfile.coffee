"use strict"

gulp = require "gulp"
$ = require("gulp-load-plugins")()
slugify = require("underscore.string").slugify
inquirer = require "inquirer"

prompts = require './lib/prompts'
{ licenses } = require './lib/data'


# ----------------------------------------------------------------------------

gulp.task 'default', (done) ->
  inquirer.prompt prompts, (answers) ->
    return done() unless answers.__continue

    answers.app_name_slug = slugify answers.app_name

    d = new Date()
    answers.year = d.getFullYear()
    answers.date = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate()

    otherLicenses = (l for l in licenses when l isnt answers.license).join '|'

    files = [
      "templates/#{answers.source_dir}/**/*.*"
      "templates/#{answers.test_dir}/**/*.*"
      "templates/*.*"
      "!templates/LICENSE_(#{otherLicenses})"
    ]

    files.push "templates/#{answers.bin_dir}/**/*.*" if answers.cli

    console.dir files.join '\n'

    # g = (p) -> glob.sync p, { cwd: 'C:\\dev\\projects\\living-style-guide' }

    answersLookup = (key) ->
      answers[key] or key

    gulp.src files, { base: 'templates' }
      .pipe $.template answers
      .pipe $.rename (file) ->
        file.basename = answersLookup file.basename
          .replace "LICENSE_#{answers.license}", 'LICENSE'
          .replace /\w*_dir/g, answersLookup
          .replace /^_/, '.'
        file.dirname  = answersLookup file.dirname
        return
      .pipe $.conflict './'
      .pipe gulp.dest './'
      .pipe $.install()
      .on 'end', done

    return

  return
