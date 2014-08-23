gulp = require 'gulp'
$ = require('gulp-load-plugins')(lazy: true)


# -----------------------------------------------------------------------------
# Location of source files and output destinations

config =
  src: '<%= source_dir %>/**/*.coffee'
  test: '<%= test_dir %>/**/*.spec.coffee'
  build: '<%= lib_dir %>'
  coffee:
    bare: true
  mocha:
    reporter: 'spec'
  istanbul:
    dir: '<%= test_dir %>/coverage'


# -----------------------------------------------------------------------------

# See http://stackoverflow.com/questions/21602332/catching-gulp-mocha-errors
handleError = (err) ->
  if not (err.plugin is 'gulp-mocha' and err.message.match /\d+ test failed\./)
    $.util.log $.util.colors.red.bold err
  this.emit 'end'


# -----------------------------------------------------------------------------

gulp.task 'clean', ->
  gulp.src [ config.build, config.istanbul.dir ], read: false
    .pipe $.clean()


# -----------------------------------------------------------------------------
# e.g. gulp bump --type minor

gulp.task 'bump', ->
  gulp.src './package.json'
    .pipe $.bump
      type: args.type ? 'patch'
    .pipe gulp.dest './'


# -----------------------------------------------------------------------------

gulp.task 'lint', ->
  gulp.src config.src
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()


# -----------------------------------------------------------------------------

gulp.task 'mocha', ->
  gulp.src config.test, read: false
    .pipe $.mocha config.mocha


gulp.task 'cover', ['coffee'], (cb) ->
  gulp.src 'lib/**/*.js'
    .pipe $.istanbul()
    .on 'finish', ->
      gulp.src config.test
        .pipe $.mocha()
        .pipe $.istanbul.writeReports config.istanbul
        .on 'end', cb
  return


# -----------------------------------------------------------------------------

gulp.task 'coffee', ->
  gulp.src config.src
    .pipe $.coffee config.coffee
    .pipe gulp.dest config.build


# -----------------------------------------------------------------------------

gulp.task 'test', ['lint', 'mocha']

gulp.task 'build', ['test', 'coffee']

gulp.task 'watch', ['build'], ->
  gulp.watch [ config.src, config.test ], ['build']
  # gulp.watch config.test, 'mocha'

gulp.task 'default', ['watch']
