const defaultTheme = require('tailwindcss/defaultTheme')
const execSync = require('child_process').execSync;
const output = execSync('bundle show tybo', { encoding: 'utf-8' });


module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{erb,haml,html,rb}',
    output.trim() + '/app/**/*.{erb,haml,html,rb}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        tybo: {
          DEFAULT: '#5626d9',
          '50': '#f4f3ff',
          '100': '#eae9fe',
          '200': '#d8d6fe',
          '300': '#bbb5fd',
          '400': '#998bfa',
          '500': '#785cf6',
          '600': '#663aed',
          '700': '#5626d9',
          '800': '#4921b6',
          '900': '#3d1d95',
          '950': '#241065',
        },
        'red-alert': {
          DEFAULT: '#d0342c',
          '50': '#fdf3f3',
          '100': '#fde4e3',
          '200': '#fbcfcd',
          '300': '#f8ada9',
          '400': '#f17e78',
          '500': '#e7544c',
          '600': '#d0342c',
          '700': '#b12b24',
          '800': '#932721',
          '900': '#7a2622',
          '950': '#42100d',
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
