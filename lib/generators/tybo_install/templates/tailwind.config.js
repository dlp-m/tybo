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
        tybo: {
          DEFAULT: '#11072C',
          50: '#e9ebff',
          100: '#d8d9ff',
          200: '#b8b8ff',
          300: '#918eff',
          400: '#7561ff',
          500: '#653dff',
          600: '#5f1cff',
          700: '#5611f1',
          800: '#4512c1',
          900: '#11072c'
        },
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
