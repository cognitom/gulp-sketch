should = require 'should'
sketch = require '../'
gutil = require 'gulp-util'
fs = require 'fs' 
path = require 'path'

createFile = (sketchFileName, contents) ->
  base = path.join __dirname, 'fixtures'
  filePath = path.join base, sketchFileName

  new gutil.File
    cwd: __dirname
    base: base
    path: filePath
    contents: contents || fs.readFileSync filePath

describe 'gulp-sketch', () ->
  describe 'sketch()', () ->
    it 'should pass file when it is not isNull()', (done) ->
      stream = sketch()
      emptyFile =
        isNull: () -> false
      stream.on 'data', (data) ->
        data.should.equal emptyFile
        done()
      stream.write emptyFile
    
    it 'should emit error when file isStream()', (done) ->
      stream = sketch()
      streamFile =
        isNull: () -> false
        isStream: () -> true
      stream.on 'error', (err) ->
        err.message.should.equal 'Streaming not supported'
        done()
      stream.write streamFile