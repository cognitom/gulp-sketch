{spawn}     = require 'child_process'
through     = require 'through2'
fs          = require 'fs'
path        = require 'path'
gutil       = require 'gulp-util'
temporary   = require 'temporary'
cleanSketch = require 'clean-sketch'

PLUGIN_NAME = 'gulp-sketch'

yesOrNo = (val) -> val == true || val == 'Yes' || val == 'yes' || val == 'YES'

module.exports = (options = {}) ->

  # build a command with arguments
  cmnd = 'sketchtool'
  args = []
  if options.export
    args.push 'export'
    args.push options.export
  args.push '--formats=' + options.formats if options.formats
  args.push '--items=' + options.items if options.items
  args.push '--scales=' + options.scales if options.scales
  args.push '--save-for-web=' + options.saveForWeb if options.saveForWeb
  args.push '--bounds=' + options.bounds if options.bounds
  args.push '--compact=' + options.compact if options.compact
  args.push '--trimmed=' + options.trimmed if options.trimmed
  
  options.clean = yesOrNo options.clean
  
  through.obj (file, encoding, callback) ->
    if file.isStream()
      @emit 'error', new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
      return callback()
    
    # file_name.sketch is a directory (=3.0)
    # file_name.sketch is a file (>3.1)
    
    src = file.path
    tmp_dir = new temporary.Dir()
    
    # SketchTool
    program = spawn cmnd, args.concat src, '--output=' + tmp_dir.path
    
    # return data
    program.stdout.on 'end', =>
      for file_name in fs.readdirSync tmp_dir.path
        file_path = tmp_dir.path + path.sep + file_name
        f = new gutil.File
          cwd: file.cwd
          base: file.base
          path: file.base + file_name
        b = fs.readFileSync file_path
        b = new Buffer cleanSketch b.toString() if options.clean && /\.svg$/.test file_name
        f.contents = b
        @push f
        fs.unlinkSync file_path
      tmp_dir.rmdirSync()
      callback()
