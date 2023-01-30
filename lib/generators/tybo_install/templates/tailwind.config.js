const defaultTheme = require('tailwindcss/defaultTheme')
const execSync = require('child_process').execSync;
const output = execSync('bundle show tybo', { encoding: 'utf-8' });


module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.html.erb',
    output.trim() + '/app/**/*.{erb,haml,html,rb}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        sidebar: {
          DEFAULT: '#11072C',
          50: 'rgba(255, 255, 255, 0.5)',
          200: 'rgba(255, 255, 255, 0.2)',
          900: 'rgba(0, 0, 0, 0.2)',
        },
        custom: {
          DEFAULT: '#11072C',
        },
        home: {
          DEFAULT: '#F5F5F5'
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
