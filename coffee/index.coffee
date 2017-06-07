{spawn}     = require 'child_process'
{Promise}   = require 'es6-promise'
through     = require 'through2'
fs          = require 'fs'
path        = require 'path'
gutil       = require 'gulp-util'
temporary   = require 'temporary'
cleanSketch = require 'clean-sketch'
recursive   = require 'recursive-readdir'
rimraf      = require 'rimraf'
which       = require('npm-which') process.cwd()

PLUGIN_NAME = 'gulp-sketch'
APP_PATH    = '/Applications/Sketch.app'
TOOL_PATH   = "#{ APP_PATH }/Contents/Resources/sketchtool/bin/sketchtool"

yesOrNo = (val) -> val == true || val == 'Yes' || val == 'yes' || val == 'YES'

checkSketchTool = do ->
  cmnd = '' # cache of path/to/sketchtool
  ->
    return Promise.resolve cmnd if cmnd
    new Promise (resolve, reject) ->
      # Check the tool bundled with Sketch.app (>= ver 3.5)
      fs.access TOOL_PATH, fs.F_OK, (err) ->
        unless err
          resolve TOOL_PATH
          return
        # Check the tool installed via install.sh
        which 'sketchtool', (err2, pathTo) ->
          if err2
            reject new gutil.PluginError PLUGIN_NAME, 'No sketchtool installed.'
          else
            cmnd = pathTo
            resolve cmnd

module.exports = (options = {}) ->

  # build a command with arguments
  args = []
  if options.export
    args.push 'export'
    args.push options.export
  args.push '--trimmed=' + options.trimmed         if options.trimmed
  args.push '--compression=' + options.compression if options.compression
  args.push '--scales=' + options.scales           if options.scales
  args.push '--formats=' + options.formats         if options.formats
  args.push '--item=' + options.item               if options.item
  args.push '--progressive'                        if yesOrNo options.progressive
  args.push '--compact'                            if yesOrNo options.compact
  args.push '--background=' + options.background   if options.background
  args.push '--group-contents-only'                if yesOrNo options.groupContentsOnly
  args.push '--items=' + options.items             if options.items
  args.push '--save-for-web'                       if yesOrNo options.saveForWeb
  args.push '--bounds=' + options.bounds           if options.bounds

  options.clean = yesOrNo options.clean

  through.obj (file, encoding, callback) ->
    # stream?
    if file.isStream()
      @emit 'error', new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      return callback()

    checkSketchTool()
    .catch (err) ->
      @emit 'error', err
      callback()
    .then (cmnd) =>
      # file_name.sketch is a directory (=3.0)
      # file_name.sketch is a file (>3.1)

      src = file.path
      tmp_dir = new temporary.Dir()

      # Output JSON
      if options.outputJSON
        args.push '--outputJSON=' + tmp_dir.path + '/' + options.outputJSON

      # SketchTool
      program = spawn cmnd, args.concat src, '--output=' + tmp_dir.path

      # Verbose Output
      program.stdout.on 'data', (data) ->
        if options.verbose
          gutil.log data.toString()

      # return data
      program.stdout.on 'end', =>
        recursive tmp_dir.path, (err, files) =>
          for abs_path in files
            rel_path = path.relative tmp_dir.path, abs_path
            f = new gutil.File
              cwd: file.cwd
              base: file.base
              path: path.join file.base, rel_path
            b = fs.readFileSync abs_path
            b = new Buffer cleanSketch b.toString() if options.clean && /\.svg$/.test rel_path
            f.contents = b
            @push f
          rimraf tmp_dir.path, -> callback()
