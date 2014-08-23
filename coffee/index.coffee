{spawn}   = require 'child_process'
through   = require 'through2'
fs        = require 'fs'
path      = require 'path'
gutil     = require 'gulp-util'
temporary = require 'temporary'

PLUGIN_NAME = 'gulp-sketch'

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
  
  through.obj (file, encoding, callback) ->
    
    # file_name.sketch is a directory
    unless file.isNull()
      @push file
      return callback()
    
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
        f.contents = fs.readFileSync file_path
        @push f
        fs.unlinkSync file_path
      tmp_dir.rmdirSync()
      callback()
      
