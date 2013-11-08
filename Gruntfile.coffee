module.exports = (grunt)->

    grunt.initConfig
        pkg: grunt.file.readJSON('package.json')

        watch:
            coffeechange:
                files: ['<%= pkg.path %>coffee/**']
                tasks: ['coffee:dev']
                options:
                    livereload: true,

            css:
                files: ['<%= pkg.path %>compass/**']
                tasks: ['compass:dev']
                options:
                    livereload: true,

            template:
                files: ['<%= pkg.path %>*.<%= pkg.fileType %>']
                tasks: ['replace:dev']
                options:
                    livereload: true,

            livereloadcompile:
                options:
                    livereload: true,
                files: [
                    '<%= pkg.path %>assets/js/*.js',
                    '<%= pkg.path %>assets/css/*.css',
                    '<%= pkg.path %>assets/img/{,**/}*.{png,jpg,jpeg,gif,webp,svg}',
                    '<%= pkg.path %>*.<%= pkg.fileType %>'
                ]

        coffee:
            dev:
                options:
                    join: true
                files:
                    '<%= pkg.devPath %>assets/js/app.js': [
                        '<%= pkg.path %>coffee/**/*.coffee'
                    ]
            prod:
                options:
                    join: true
                files:
                    '<%= pkg.prodPath %>assets/js/app.js': [
                        '<%= pkg.path %>coffee/**/*.coffee'
                    ]

        uglify:
            dev:
                options:
                    banner:   '/*!\n' +
                              ' * <%= pkg.name %>\n' +
                              ' * <%= pkg.title %>\n' +
                              ' * <%= pkg.url %>\n' +
                              ' * @author <%= pkg.author %>\n' +
                              ' * @version <%= pkg.version %>\n' +
                              ' * Copyright <%= pkg.copyright %>. <%= pkg.license %> licensed.\n' +
                              ' */\n'
                files:
                    '<%= pkg.devPath %>assets/js/libs.min.js': ['<%= pkg.path %>coffee/libs/*.js']

            prod:
                options:
                    banner:   '/*!\n' +
                              ' * <%= pkg.name %>\n' +
                              ' * <%= pkg.title %>\n' +
                              ' * <%= pkg.url %>\n' +
                              ' * @author <%= pkg.author %>\n' +
                              ' * @version <%= pkg.version %>\n' +
                              ' * Copyright <%= pkg.copyright %>. <%= pkg.license %> licensed.\n' +
                              ' */\n'
                files:
                    '<%= pkg.prodPath %>assets/js/app.js': ['<%= pkg.prodPath %>assets/js/app.js']
                    '<%= pkg.devPath %>assets/js/libs.min.js': ['<%= pkg.path %>coffee/libs/*.js']

        compass:
            dev:
                options:
                    sassDir: '<%= pkg.path %>compass',
                    cssDir: '<%= pkg.devPath %>assets/css',
                    generatedImagesDir: '<%= pkg.devPath %>assets/img',
                    imagesDir: '<%= pkg.path %>img',
                    javascriptsDir: '<%= pkg.devPath %>assets/js',
                    fontsDir: '<%= pkg.devPath %>assets/fonts',
                    importPath: '<%= pkg.path %>coffee/libs',
                    #httpImagesPath: '/images',
                    #httpGeneratedImagesPath: '/images/generated',
                    #relativeAssets: false

            prod:
                options:
                    sassDir: '<%= pkg.path %>compass',
                    cssDir: '<%= pkg.prodPath %>assets/css',
                    generatedImagesDir: '<%= pkg.prodPath %>assets/img',
                    imagesDir: '<%= pkg.path %>img',
                    javascriptsDir: '<%= pkg.prodPath %>assets/js',
                    fontsDir: '<%= pkg.prodPath %>assets/fonts',
                    importPath: '<%= pkg.path %>coffee/libs',
                    #httpImagesPath: '/images',
                    #httpGeneratedImagesPath: '/images/generated',
                    #relativeAssets: false

        htmlmin:
            dev:
                options: {
                    collapseWhitespace: false
                    collapseBooleanAttributes: false
                    removeAttributeQuotes: false
                    removeRedundantAttributes: false
                    useShortDoctype: false
                    removeEmptyAttributes: false
                    removeOptionalTags: false
                },
                files: [{
                    expand: true,
                    cwd: '<%= pkg.path %>',
                    src: '*.html',
                    dest: '<%= pkg.devPath %>'
                }]

            prod:
                options: {
                    collapseWhitespace: true
                    collapseBooleanAttributes: true
                    removeAttributeQuotes: true
                    removeRedundantAttributes: true
                    useShortDoctype: true
                    removeEmptyAttributes: true
                    removeOptionalTags: true
                },
                files: [{
                    expand: true,
                    cwd: '<%= pkg.path %>',
                    src: '*.html',
                    dest: '<%= pkg.prodPath %>'
                }]

        copy:
            dev:
                files: [
                    {
                    expand: true,
                    dot: true,
                    cwd: '<%= pkg.path %>',
                    dest: '<%= pkg.devPath %>'
                    src: [
                        '*.{ico,txt,png}',
                        '.htaccess'
                        ]
                    },
                    {
                    expand: true,
                    dot: true,
                    cwd: '<%= pkg.path %>',
                    dest: '<%= pkg.devPath %>assets'
                    src: [
                        'fonts/*'
                        ]
                    }
                ]

            prod:
                files: [
                    {
                    expand: true,
                    dot: true,
                    cwd: '<%= pkg.path %>',
                    dest: '<%= pkg.prodPath %>'
                    src: [
                        '*.{ico,txt,png}',
                        '.htaccess'
                        ]
                    },
                    {
                    expand: true,
                    dot: true,
                    cwd: '<%= pkg.path %>',
                    dest: '<%= pkg.prodPath %>assets'
                    src: [
                        'fonts/*'
                        ]
                    }
                ]

        replace: {
            dev: {
                options: {
                    patterns: [
                        {
                        match: 'build_css -->',
                        replacement: '<link rel="stylesheet" href="assets/css/screen.css" media="screen">\n
        <link rel="stylesheet" href="assets/css/print.css" media="print">\n
        <!--[if IE]> <link rel="stylesheet" href="assets/css/ie.css" media="screen"> <![endif]-->'
                        },
                        {
                        match: 'build_javascript_libs -->',
                        replacement: '<script src="assets/js/libs.min.js"></script>'
                        },
                        {
                        match: 'build_javascript_app -->',
                        replacement: '<script src="assets/js/app.js"></script>'
                        },
                        {
                        match: 'build_livereload -->',
                        replacement: '<script src="http://localhost:35729/livereload.js"></script>'
                        }
                    ]
                    prefix: '<!-- @@'
                },
                files: [
                    {expand: true, flatten: true, src: ['dev/*.html'], dest: 'dev/'}
                ]
            },
            prod: {
                options: {
                    patterns: [
                        {
                        match: 'build_css -->',
                        replacement: '<link rel="stylesheet" href="assets/css/screen.css" media="screen">\n
        <link rel="stylesheet" href="assets/css/print.css" media="print">\n
        <!--[if IE]> <link rel="stylesheet" href="assets/css/ie.css" media="screen"> <![endif]-->'
                        },
                        {
                        match: 'build_javascript_libs -->',
                        replacement: '<script src="assets/js/libs.min.js"></script>'
                        },
                        {
                        match: 'build_javascript_app -->',
                        replacement: '<script src="assets/js/app.js"></script>'
                        },
                        {
                        match: 'build_livereload -->',
                        replacement: ''
                        }
                    ]
                    prefix: '<!-- @@'
                },
                files: [
                    {expand: true, flatten: true, src: ['prod/*.html'], dest: 'prod/'}
                ]
            }
        }

        clean:
            prod:
                src: [
                    '<%= pkg.prodPath %>assets/js/app.js',
                    '<%= pkg.prodPath %>assets/js/libs.min.js',
                    '**/.DS_Store',
                    '<%= pkg.prodPath %>assets/img/**.png',
                    '<%= pkg.path %>compass/.sass-cache',
                    '<%= pkg.prodPath %>assets/css/main.css',
                    '<%= pkg.prodPath %>/*.<%= pkg.fileType %>'
                ]

        imagemin:
            dev:
                files: [
                    expand: true,
                    cwd: '<%= pkg.path %>img/',
                    src: '{,*/}*.{png,jpg,jpeg,gif}',
                    dest: 'dev/assets/img/'
                ]
            prod:
                files: [
                    expand: true,
                    cwd: '<%= pkg.path %>img/',
                    src: '{,*/}*.{png,jpg,jpeg,gif}',
                    dest: 'prod/assets/img/'
                ]
        cssmin:
            prod:
                options: {
                    banner:   '/*!\n' +
                              ' * <%= pkg.name %>\n' +
                              ' * <%= pkg.title %>\n' +
                              ' * <%= pkg.url %>\n' +
                              ' * @author <%= pkg.author %>\n' +
                              ' * @version <%= pkg.version %>\n' +
                              ' * Copyright <%= pkg.copyright %>. <%= pkg.license %> licensed.\n' +
                              ' */\n'
                },
                expand: true,
                cwd: 'prod/assets/css/',
                src: ['*.css'],
                dest: 'prod/assets/css/'


    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-compass')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-imagemin')
    grunt.loadNpmTasks('grunt-replace');
    grunt.loadNpmTasks('grunt-contrib-htmlmin')
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['coffee:dev', 'uglify:dev', 'compass:dev', 'htmlmin:dev', 'imagemin:dev', 'copy:dev', 'replace:dev', 'watch'])
    grunt.registerTask('compile', ['coffee:dev', 'uglify:dev', 'compass:dev', 'htmlmin:dev', 'imagemin:dev', 'replace:dev'])
    grunt.registerTask('build', ['clean:prod', 'coffee:prod', 'uglify:prod', 'compass:prod', 'imagemin:prod', 'copy:prod', 'htmlmin:prod', 'replace:prod', 'cssmin:prod'])
    grunt.registerTask('superclean', ['clean:prod'])
    grunt.registerTask('compressimg', ['imagemin'])
    grunt.registerTask('compressjpg', ['imagemin:jpg'])
    grunt.registerTask('compresspng', ['imagemin:png'])
