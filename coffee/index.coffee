{spawn} = require 'child_process'
through  = require 'through2'
fs = require 'fs'
path = require 'path'
gutil = require 'gulp-util'

PLUGIN_NAME = 'gulp-sketch'

module.exports = (options = {}) ->

	# build a command with arguments
	cmnd = 'sketchtool'
	args = []
	if options.export
		args.push 'export'
		args.push options.export
	args.push '--formats=' + options.formats if options.formats
	args.push '--scales=' + options.scales if options.scales
	args.push '--items=' + options.items if options.items
	args.push '--bounds=' + options.bounds if options.bounds
	
	through.obj (file, encoding, callback) ->
		
		# filename.sketch is a directory
		unless file.isNull()
			@push file
			return callback()
		
		if file.isStream()
			@emit 'error', new gutil.PluginError PLUGIN_NAME, 'Streaming not supported'
			return callback()
		
		src = file.path
		tmp = path.dirname(src) + path.sep + '___tmp___' + path.basename(src).replace('.sketch', '')
		
		# SketchTool
		program = spawn cmnd, args.concat src, '--output=' + tmp
		
		# return data
		program.stdout.on 'end', =>
			for file_name in fs.readdirSync tmp
				file_path = tmp + path.sep + file_name
				f = new gutil.File
					cwd: file.cwd
					base: file.base
					path: file.base + file_name
				f.contents = fs.readFileSync file_path
				@push f
				fs.unlinkSync file_path
			fs.rmdirSync tmp
			callback()
			
