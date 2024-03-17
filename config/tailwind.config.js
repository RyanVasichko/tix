const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './lib/standard_form_builder/**/*.rb',
    "./app/assets/stylesheets/**/*.css"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  safelist: [
    {
      pattern:
        /(text|bg)-(blue|gray|red|yellow|green|indigo|pink|purple|amber|lime|emerald|teal|cyan|sky|violet|rose|fuchsia|orange|lightBlue)-\d{2,3}$/
    }
  ],
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
