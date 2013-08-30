module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    coffee:
      compile:
        expand: true
        cwd: 'src/'
        src: ["**/*.coffee"]
        dest: 'lib/'
        ext: '.js'

    concat:
      options:
        separator: ";"
      dist:
        cwd: 'lib/'
        src: ["**/*.js"]
        dest: "dist/<%= pkg.name %>.<%= pkg.version %>.js"

    uglify:
      options:
        banner: "/* <%= pkg.name %> - <%= pkg.version %> */\n"
      dist:
        files:
          "dist/<%= pkg.name %>.<%= pkg.version %>.min.js": ["<%= concat.dist.dest %>"]

    qunit:
      files: ["test/index.html"]

    watch:
      files: ['<%= coffee.compile.src %>'],
      tasks: ['coffee:compile', 'concat:js', 'sync']

  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-qunit"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-concat"

  grunt.registerTask "test", ["qunit"]
  grunt.registerTask "dist", ["qunit", "concat", "uglify"]
