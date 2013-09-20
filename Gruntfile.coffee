module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean: [
      'lib/**/*',
      'dist/**/*',
      '!lib/.gitignore'
      '!dist/.gitignore'
    ]

    coffee:
      compile:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'lib/'
        ext: '.js'

    concat:
      options:
        banner: '''
                /**
                 * BubbleChart (<%= pkg.version %>)
                 *
                 * Author: <%= pkg.author %>
                 * Homepage: <%= pkg.homepage %>
                 * Issue Tracker: <%= pkg.bugs %>
                 * License: <%= pkg.license %>
                 */\n
                '''
        separator: ';'
      dist:
        src: ['lib/**/*.js']
        dest: 'dist/bubblechart.js'

    uglify:
      options:
        banner: '<%= concat.options.banner %>'
      dist:
        files:
          'dist/bubblechart.min.js': ['<%= concat.dist.dest %>']

    compress:
      main:
        options:
          mode: 'gzip'
        expand: true
        cwd: 'dist'
        src: ['*.js']
        dest: 'dist/'

      dist:
        options:
          archive: 'dist/bubblechart-<%= pkg.version %>.zip'
          level: 9
        files: [
          {
            src: [
              'LICENSE.txt',
              'README.md',
            ]
          }
          {
            expand: true
            cwd: 'dist/'
            src: [
              '*.js',
              '*.js.gz'
            ]
          }
        ]

    qunit:
      files: [
        'test/Patches.html',
        'test/classes/**/*.html'
      ]

    watch:
      files: ['<%= coffee.compile.src %>'],
      tasks: ['coffee:compile', 'concat']

  # Load Package Tasks
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Define Custom Tasks
  grunt.registerTask 'test', ['qunit']
  grunt.registerTask 'default', ['clean', 'coffee:compile', 'concat:dist', 'test']
  grunt.registerTask 'dist', ['default', 'uglify:dist', 'compress', 'compress:dist']
