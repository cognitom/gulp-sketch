# gulp-sketch [![Build Status](https://travis-ci.org/cognitom/gulp-sketch.svg?branch=master)](https://travis-ci.org/cognitom/gulp-sketch)

A [SketchTool](http://bohemiancoding.com/sketch/tool/) plugin for [gulp](https://github.com/wearefractal/gulp).


## Install

Download [SketchTool](http://sketchtool.bohemiancoding.com/sketchtool-latest.zip) and install it to your environment.

```bash
npm install gulp-sketch --save-dev
```


## Usage

```javascript
var gulp = require("gulp");
var sketch = require("gulp-sketch");

gulp.task('sketch', function(){
  gulp.src("./src/sketch/*.sketch")
    .pipe(sketch({
      export: 'slices',
      formats: 'png'
    }))
    .pipe(gulp.dest("./dist/images/"));
});
```

or write it in CoffeeScript.

```coffeescript
gulp = require 'gulp'
sketch = require 'gulp-sketch'

gulp.task 'sketch', ->
  gulp.src './src/sketch/*.sketch'
  .pipe sketch
    export: 'slices'
    formats: 'png'
  .pipe gulp.dest './dist/images/'
```


## Options

The options are the same as what's supported by `SketchTool`.

- `export`: pages,artboards,slices
- `formats`: png,pdf,eps,jpg
- `scales`: 1.0,2.0
- `items`: 
- `bounds`: 
