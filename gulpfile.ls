require! <[gulp gulp-util express connect-livereload gulp-livereload path]>

app = express!
build_path = '_public'

gulp.task 'html', ->
    gulp.src './app/views/*.html'
        .pipe gulp.dest "#{build_path}"

gulp.task 'js', ->
    gulp.src './app/assets/scripts/*.js'
        .pipe gulp.dest "#{build_path}/assets/scripts/"

gulp.task 'vendor', ->
    gulp.src './vendors/**/*'
        .pipe gulp.dest "#{build_path}/vendors/"

gulp.task 'img', ->
    gulp.src './app/assets/imgs/*'
        .pipe gulp.dest "#{build_path}/assets/imgs/"

gulp.task 'css', ->
    gulp.src './app/assets/styles/*.css'
        .pipe gulp.dest "#{build_path}/assets/styles/"

gulp.task 'data', ->
    gulp.src './app/assets/data/*'
        .pipe gulp.dest "#{build_path}assets/data/"

gulp.task 'server', ->
    app.use connect-livereload!
    app.use express.static path.resolve "#{build_path}"
    app.listen 3000
    gulp-util.log 'listening on port 3000'

gulp.task 'watch', ->
    gulp-livereload.listen silent: true
    gulp.watch './app/views/*.html', <[html]> .on \change, gulp-livereload.changed
    gulp.watch './app/assets/imgs/*', <[img]> .on \change, gulp-livereload.changed
    gulp.watch './app/assets/data/*', <[data]> .on \change, gulp-livereload.changed
    gulp.watch './app/assets/scripts/*.js', <[js]> .on \change, gulp-livereload.changed
    gulp.watch './app/assets/styles/*.css', <[css]> .on \change, gulp-livereload.changed

gulp.task 'build', <[html js css vendor]>
gulp.task 'dev', <[build server watch]>
gulp.task 'default', <[build]>
