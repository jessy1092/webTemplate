require! <[gulp gulp-util gulp-livereload gulp-jade gulp-plumber]>
require! <[express connect-livereload path vinyl-source-stream browserify]>

app = express!
build_path = '_public'

gulp.task 'html', ->
  gulp.src './app/views/*.html'
    .pipe gulp.dest "#{build_path}"

gulp.task 'jade', ->
  gulp.src './app/views/*.jade'
    .pipe gulp-plumber!
    .pipe gulp-jade!
    .pipe gulp.dest "#{build_path}"

gulp.task 'img', ->
  gulp.src './app/assets/imgs/*'
    .pipe gulp.dest "#{build_path}/assets/imgs/"

gulp.task 'data', ->
  gulp.src './app/assets/data/*'
    .pipe gulp.dest "#{build_path}/assets/data/"

gulp.task 'css', ->
  gulp.src './app/styles/*.css'
    .pipe gulp.dest "#{build_path}/styles/"

gulp.task 'browserify', ->
  browserify './app/scripts/app.js'
    .bundle!
    .pipe vinyl-source-stream 'bundle.js'
    .pipe gulp.dest "#{build_path}/scripts/"

gulp.task 'server', ->
  app.use connect-livereload!
  app.use express.static path.resolve "#{build_path}"
  app.listen 3000
  gulp-util.log 'listening on port 3000'

gulp.task 'watch', ->
  gulp-livereload.listen silent: true
  gulp.watch './app/views/*.jade', <[jade]> .on \change, gulp-livereload.changed
  gulp.watch './app/assets/imgs/*', <[img]> .on \change, gulp-livereload.changed
  gulp.watch './app/assets/data/*', <[data]> .on \change, gulp-livereload.changed
  gulp.watch './app/styles/*.css', <[css]> .on \change, gulp-livereload.changed
  gulp.watch './app/scripts/app.js', <[browserify]> .on \changed, gulp-livereload.changed

gulp.task 'build', <[jade browserify css]>
gulp.task 'dev', <[build server watch]>
gulp.task 'default', <[build]>
