module.exports = function(grunt) {

  grunt.config.set('browserify', {
    dev: {
      files: {
        '.tmp/public/main.js': ['assets/js/main.coffee'],
      },
      options: {
        transform: ['coffeeify']
      }
    }
  });

  grunt.loadNpmTasks('grunt-browserify');
};