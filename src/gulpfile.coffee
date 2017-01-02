gulp    = require 'gulp'
gutil   = require 'gulp-util'
jeet    = require 'jeet'
pug     = require 'gulp-pug'
stylus  = require 'gulp-stylus'
coffee  = require 'gulp-coffee'
sync    = require 'browser-sync'
                  .create()

args = process.argv.slice(2)

gulp.task 'default', ['compile', 'watch']
gulp.task 'compile', ['compile:pug', 'compile:stylus', 'compile:coffee']

gulp.task 'compile:pug', ->
    gulp.src './index.pug'
        .pipe pug(pretty: no)
        .pipe gulp.dest('../')
        .pipe sync.stream()

gulp.task 'compile:stylus', ->
    gulp.src './index.styl'
        .pipe stylus(compress: yes, use: jeet())
        .pipe gulp.dest('../')
        .pipe sync.stream()

gulp.task 'compile:coffee', ->
    gulp.src './index.coffee'
        .pipe coffee()
        .pipe gulp.dest('../')
        .pipe sync.stream()

gulp.task 'watch', ->
    shouldOpen = args.indexOf('--open') isnt -1 or args.indexOf('-o') isnt -1
    shouldShare = args.indexOf('--share') isnt -1 or args.indexOf('-s') isnt -1
    shouldBeVerbose = args.indexOf('--info') isnt -1 or args.indexOf('-i') isnt -1

    sync.init(server: '..', online: shouldShare, logLevel: (if shouldBeVerbose then 'info' else 'silent'), open: shouldOpen)

    gulp.watch './index.coffee', ['compile:coffee']
    gulp.watch './index.styl',   ['compile:stylus']
    gulp.watch './index.pug',    ['compile:pug']