# gulp-sketch [![Build Status](https://travis-ci.org/cognitom/gulp-sketch.svg?branch=master)](https://travis-ci.org/cognitom/gulp-sketch) [![Stories in Ready](https://badge.waffle.io/cognitom/gulp-sketch.png?label=ready&title=Ready)](https://waffle.io/cognitom/gulp-sketch)

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
  return gulp.src("./src/sketch/*.sketch")
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
- `formats`: png,jpg,pdf,eps,svg
- `scales`: 1.0,2.0
- `items`: List of artboard/slice names or ids to export. The default is to export all artboards/slices (optional).
- `bounds`:
- `saveForWeb`: Export web-ready images (optional, defaults to NO).
- `compact`: Export in compact form. Currently only relevant for SVG export. (optional, defaults to NO).
- `trimmed`: Export images trimmed. (optional, defaults to NO).

Additionally, it has `clean` option for exporting SVG.

- `clean`: Remove Sketch namespaces and metadata from SVG (optional, defaults to NO). See [clean-sketch](https://github.com/overblog/clean-sketch).
