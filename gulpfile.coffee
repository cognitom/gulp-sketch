gulp = require 'gulp'
coffee = require 'gulp-coffee'
sketch = require './coffee/'

gulp.task 'default', ->
  gulp.src './coffee/index.coffee'
  .pipe coffee()
  .pipe gulp.dest './'
  
gulp.task 'test-flat', ->
  gulp.src './test/fixtures/flat.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'png'
    saveForWeb: true
  .pipe gulp.dest './tmp/test/flat'

gulp.task 'test-subdir', ->
  gulp.src './test/fixtures/subdir.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'png'
    saveForWeb: true
  .pipe gulp.dest './tmp/test/subdir'
  
gulp.task 'test-svg', ->
  gulp.src './test/fixtures/flat.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'svg'
  .pipe gulp.dest './tmp/test/svg'

gulp.task 'test-svg-subdir', ->
  gulp.src './test/fixtures/subdir.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'svg'
  .pipe gulp.dest './tmp/test/svg-subdir'
  