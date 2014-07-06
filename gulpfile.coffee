gulp = require 'gulp'
coffee = require 'gulp-coffee'
sketch = require './'

gulp.task 'default', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'
  
gulp.task 'test1', ->
  gulp.src './test/fixtures/*.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'png'
  .pipe gulp.dest './tmp/'
  