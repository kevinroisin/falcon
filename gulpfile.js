var gulp = require('gulp');
var nodemon = require('gulp-nodemon');
var livereload = require('gulp-livereload');
var rename = require('gulp-rename')
var browserify = require('gulp-browserify');
var sourcemaps = require('gulp-sourcemaps');
var sass = require('gulp-sass');

gulp.task('watch', function() {
  livereload.listen();
  gulp.watch('./public/coffee/**/*.coffee', ['scripts']);
  gulp.watch('./public/scss/*.scss', ['scss']);
  gulp.watch('./public/scripts/bundle.js', ['reload_js']);
});

gulp.task('scss', function () {
  gulp.src('./public/scss/*.scss')
    .pipe(sourcemaps.init())
    .pipe(sass())
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('./public/css'))
    .pipe(livereload());
});

gulp.task('scripts', function() {
  gulp.src('./public/coffee/main.coffee', { read: false })
    .pipe(browserify({
      debug: true,
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('./public/scripts'))
});

gulp.task('reload_js', function(){
  livereload.changed("./public/scripts/bundle.js");
});

gulp.task('develop', function () {
  livereload.listen();
  nodemon({
    script: 'app.js',
    ext: 'js coffee handlebars',
  }).on('restart', function () {
    setTimeout(function () {
      livereload.changed(__dirname);
    }, 500);
  });
});

gulp.task('default', [
  'develop',
  'scripts',
  'scss',
  'watch',
]);
