should = require 'should'
sketch = require '../coffee/'
gutil  = require 'gulp-util'
fs     = require 'fs'
path   = require 'path'

createVinyl = (file_name, contents) ->
  base = path.join __dirname, 'fixtures'
  filePath = path.join base, file_name
  
  new gutil.File
    cwd: __dirname
    base: base
    path: filePath
    contents: contents || fs.readFileSync filePath

describe 'gulp-sketch', () ->
  describe 'sketch()', () ->
    
    @timeout 10000
    
    it 'should emit error when file isStream()', (done) ->
      stream = sketch()
      streamFile =
        isNull: () -> false
        isStream: () -> true
      stream.on 'error', (err) ->
        err.message.should.equal 'Streaming not supported'
        done()
      stream.write streamFile

    it 'should export single png file', (done) ->
      src = createVinyl 'flat.sketch'
      stream = sketch
        export: 'slices'
        formats: 'png'
        saveForWeb: true
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'yellow.png'
        actual = dist.contents.toString 'hex'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'yellow.png'), 'hex'
        actual.should.equal expected
        done()
      stream.write src
    
    it 'should export single png file under subdirectory', (done) ->
      src = createVinyl 'subdir.sketch'
      stream = sketch
        export: 'slices'
        formats: 'png'
        saveForWeb: true
      stream.on 'data', (dist) ->
        should.exist dist
        should.exist dist.path
        should.exist dist.relative
        should.exist dist.contents
        dist.path.should.equal path.join __dirname, 'fixtures', 'square', 'yellow.png'
        actual = dist.contents.toString 'hex'
        expected = fs.readFileSync path.join(__dirname, 'expect', 'yellow.png'), 'hex'
        actual.should.equal expected
        done()
      stream.write src