const fs = require('fs');

const excludeFromDist = [
    '!Dockerfile',
    '!node_modules/**',
    '!Jenkinsfile',
    '!Gemfile.lock',
    '!yarn.lock',
    '!vendor/**',
    '!package-lock.json'
];

const allowInPackageJson = ['name', 'version', 'description', 'keywords', 'author', 'license'];

module.exports = grunt => {

    //
    // Use node-sass as scss compiler
    const sass = require("sass");


    //
    // Define sources
    const scss_source = {
        "assets/css/template.css": "source/scss/template.scss"
    };


    //
    // Setup Grunt
    grunt.initConfig({


        //
        // watch for changes
        watch: {
            options: {
                atBegin: true
            },
            sass: {
                files: './source/scss/**/*.{css}',
                tasks: ['sass:watch']
            },
            js: {
                files: './source/**/*.js',
                tasks: 'uglify:watch'
            },
            postcss: {
                files: [
                    'source/css/tailwind.css',
                    'modules/**/*.{html,tpl}',
                    'partials/**/*.{html,tpl}'
                ],
                tasks: 'postcss'
            }
        },

        //
        // PostCss - TailwindCss & Autoprefixer
        postcss: {
            options: {
                processors: [
                    require('tailwindcss')('tailwind.config.js'),
                    require('autoprefixer')({ overrideBrowserslist: 'last 2 versions' }) // add vendor prefixes
                ]
            },
            dist: {
                expand: true,
                cwd: 'source/css/',
                src: 'tailwind.css',
                dest: 'assets/css/',
                ext: '.css'
            }
        },

        //
        // sass compilation with node-sass
        sass: {
            "options": {
                implementation: sass,
                sourceMap: false,
                includePaths: [
                    "./node_modules/breakpoint-sass/stylesheets/",
                    "./node_modules/breakpoint-slicer/stylesheets/",
                    "./node_modules/compass-mixins-template/lib/",
                    "./source/scss/"
                ]
            },
            watch: {
                options: {
                    outputStyle: "expanded",
                    sourceComments: true
                },
                files: scss_source
            },
            "build": {
                options: {
                    outputStyle: "expanded",
                    sourceComments: false
                },
                files: scss_source
            }
        },

        //
        // css minification and concatination
        cssmin: {	
            combine: {	
                options: {	
                    keepSpecialComments: 0	
                },	
                files: [{
                    expand: true,
                    cwd: 'assets/css',
                    src: ["*.css", "!*.min.css"],
                    dest: "assets/css/min",
                    ext: '.min.css' 
                }]
            }
        },

        //
        // js minification
        uglify: {
            watch: {
                files: {
                    'assets/js/template.js': ['./source/libs/**/*.js', './source/js/**/*.js']
                },
                options: {
                    compress: false,
                    mangle: false,
                    beautify: true
                }
            },
            build: {
                files: {
                    'assets/js/template.js': ['./source/libs/**/*.js', './source/js/**/*.js']
                },
                options: {
                    sourceMap: true,
                    preserveComments: false,
                    mangle: true,
                    compress: {
                        drop_console: true
                    }
                }
            }
        },

        //
        // clear dist folder
        clean: {
            release: ['dist'],
        },

        //
        // copy files to dist folder
        copy: {
            dist: {
                expand: true,
                src: ['**'].concat(excludeFromDist),
                dest: 'dist/',
              },
        },

        //
        // create dist package.json
        makePackageJson: {
            yes: true
        }

    });

    //
    // custom task for dist package json
    grunt.registerMultiTask('makePackageJson', 'Make package.json', function(){
        let pkg = require('./package.json');
        Object.keys(pkg)
            .filter(key => !allowInPackageJson.includes(key))
            .forEach(key => delete pkg[key]);
        fs.writeFileSync('dist/package.json', JSON.stringify(pkg, null, 2));
    })


    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('@lodder/grunt-postcss');

    //
    // Register tasks
    grunt.registerTask('default', ['watch']);
    grunt.registerTask('libs', ['uglify:build']);
    grunt.registerTask('build', ['sass:build', 'postcss', 'cssmin', 'libs']);
    grunt.registerTask('dist', ['sass:build', 'cssmin', 'libs', 'clean', 'copy:dist', 'makePackageJson']);
    grunt.registerTask('compile-tailwindcss', ['postcss', 'cssmin']);

    //
    // Use grunt-tasks to load modules instead of
    require("load-grunt-tasks")(grunt, { scope: "devDependencies" });
};