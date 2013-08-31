module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

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
                 * BubbleChartJS (<%= pkg.version %>)
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
        dest: 'dist/<%= pkg.name %>.js'

    uglify:
      options:
        banner: '<%= concat.options.banner %>'
      dist:
        files:
          'dist/<%= pkg.name %>.min.js': ['<%= concat.dist.dest %>']

    qunit:
      files: ['test/index.html']

    watch:
      files: ['<%= coffee.compile.src %>'],
      tasks: ['coffee:compile', 'concat', 'test']

  # Load Package Tasks
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-qunit'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # Define Custom Tasks
  grunt.registerTask 'test', ['qunit']
  grunt.registerTask 'dist', ['coffee:compile', 'concat:dist', 'test', 'uglify:dist']