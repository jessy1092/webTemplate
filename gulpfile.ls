require! <[gulp gulp-util gulp-livereload gulp-jade gulp-plumber gulp-shell]>
require! <[express connect-livereload path vinyl-source-stream browserify glob karma liveify]>
require! <[child_process]>

exec = child_process.exec
app = express!
livereload = gulp-livereload
shell = gulp-shell
build_path = '_public'

gulp.task 'html', ->
  gulp.src './app/views/*.html'
    .pipe gulp.dest "#{build_path}"
    .pipe livereload!

gulp.task 'jade', ->
  gulp.src './app/views/*.jade'
    .pipe gulp-plumber!
    .pipe gulp-jade!
    .pipe gulp.dest "#{build_path}"
    .pipe livereload!

gulp.task 'img', ->
  gulp.src './app/assets/imgs/*'
    .pipe gulp.dest "#{build_path}/assets/imgs/"
    .pipe livereload!

gulp.task 'data', ->
  gulp.src './app/assets/data/*'
    .pipe gulp.dest "#{build_path}/assets/data/"
    .pipe livereload!

gulp.task 'css', ->
  gulp.src './app/styles/*.css'
    .pipe gulp.dest "#{build_path}/styles/"
    .pipe livereload!

gulp.task 'browserify:test', ->
  testFiles = glob.sync './test/spec/*.ls'
  browserify testFiles
    .transform liveify
    .bundle!
    .pipe vinyl-source-stream 'bundle-test.js'
    .pipe gulp.dest "./test/spec/"

gulp.task 'test',<[browserify:test]>, shell.task 'karma start ./test/karma.conf.js'

gulp.task 'browserify', ->
  browserify './app/scripts/app.js'
    .bundle!
    .pipe vinyl-source-stream 'bundle.js'
    .pipe gulp.dest "#{build_path}/scripts/"
    .pipe livereload!

gulp.task 'server', ->
  app.use connect-livereload!
  app.use express.static path.resolve "#{build_path}"
  app.listen 3000
  gulp-util.log 'listening on port 3000'

gulp.task 'watch', ->
  livereload.listen start: true
  gulp.watch './app/views/*.jade', <[jade]>
  gulp.watch './app/assets/imgs/*', <[img]>
  gulp.watch './app/assets/data/*', <[data]>
  gulp.watch './app/styles/*.css', <[css]>
  gulp.watch './app/scripts/app.js', <[browserify]>

gulp.task 'build', <[jade browserify css]>
gulp.task 'dev', <[build server watch]>
gulp.task 'default', <[build]>
