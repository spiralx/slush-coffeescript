gulp = require 'gulp'
$ = require('gulp-load-plugins')(lazy: true)


# -----------------------------------------------------------------------------
# Location of source files and output destinations

config =
  src: ['slushfile.coffee', 'lib/**/*.coffee']
  test: 'test/**/*.spec.coffee'
  mocha:
    reporter: 'spec'


# -----------------------------------------------------------------------------

# See http://stackoverflow.com/questions/21602332/catching-gulp-mocha-errors
handleError = (err) ->
  if not (err.plugin is 'gulp-mocha' and err.message.match /\d+ test failed\./)
    $.util.log $.util.colors.red.bold err
  this.emit 'end'


# -----------------------------------------------------------------------------

gulp.task 'lint', ->
  gulp.src config.src
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()


# -----------------------------------------------------------------------------

gulp.task 'mocha', ['lint'], ->
  gulp.src config.test, read: false
    .pipe $.mocha config.mocha


# -----------------------------------------------------------------------------

gulp.task 'test', ['mocha']

gulp.task 'watch', ['mocha'], ->
  gulp.watch [ config.src, config.test ], ['mocha']

gulp.task 'default', ['watch']
