(function() {
  var PLUGIN_NAME, fs, gutil, path, spawn, through;

  spawn = require('child_process').spawn;

  through = require('through2');

  fs = require('fs');

  path = require('path');

  gutil = require('gulp-util');

  PLUGIN_NAME = 'gulp-sketch';

  module.exports = function(options) {
    var args, cmnd;
    if (options == null) {
      options = {};
    }
    cmnd = 'sketchtool';
    args = [];
    if (options["export"]) {
      args.push('export');
      args.push(options["export"]);
    }
    if (options.formats) {
      args.push('--formats=' + options.formats);
    }
    if (options.scales) {
      args.push('--scales=' + options.scales);
    }
    if (options.items) {
      args.push('--items=' + options.items);
    }
    if (options.bounds) {
      args.push('--bounds=' + options.bounds);
    }
    return through.obj(function(file, encoding, callback) {
      var program, src, tmp;
      if (!file.isNull()) {
        this.push(file);
        return callback();
      }
      src = file.path;
      tmp = path.dirname(src) + path.sep + '___tmp___' + path.basename(src).replace('.sketch', '');
      program = spawn(cmnd, args.concat(src, '--output=' + tmp));
      return program.stdout.on('end', (function(_this) {
        return function() {
          var f, file_name, file_path, _i, _len, _ref;
          _ref = fs.readdirSync(tmp);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            file_name = _ref[_i];
            file_path = tmp + path.sep + file_name;
            f = new gutil.File({
              cwd: file.cwd,
              base: file.base,
              path: file.base + file_name
            });
            f.contents = fs.readFileSync(file_path);
            _this.push(f);
            fs.unlinkSync(file_path);
          }
          fs.rmdirSync(tmp);
          return callback();
        };
      })(this));
    });
  };

}).call(this);
