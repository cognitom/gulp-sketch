{spawn} = require 'child_process'
gulp = require 'gulp'
gutil = require 'gulp-util'
coffee = require 'gulp-coffee'

gulp.task 'coffee', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'