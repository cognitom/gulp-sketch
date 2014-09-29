gulp = require 'gulp'
coffee = require 'gulp-coffee'
sketch = require './'

gulp.task 'default', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'
  
gulp.task 'test1', ->
  gulp.src './test/fixtures/symbol-font-14px.sketch'
  .pipe sketch
    export: 'artboards'
    formats: 'svg'
    clean: true
  .pipe gulp.dest './tmp/'
  