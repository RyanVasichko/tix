module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          "50": "#fffbeb",
          "100": "#fef3c7",
          "200": "#fde68a",
          "300": "#fcd34d",
          "400": "#fbbf24",
          "500": "#f59e0b",
          "600": "#d97706",
          "700": "#b45309",
          "800": "#92400e",
          "900": "#78350f",
          "950": "#451a03"
        }
      }
    }
  },
  safelist: [
    {
      pattern:
        /(text|bg)-(blue|gray|red|yellow|green|indigo|pink|purple|amber|lime|emerald|teal|cyan|sky|violet|rose|fuchsia|orange|lightBlue)-\d{2,3}$/
    }
  ],
  content: [
    "./app/views/**/*.html.erb",
    "./app/views/**/*.turbo_stream.erb",
    "./app/helpers/**/*.rb",
    "./lib/dosey_doe_tickets_form_builder/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/application.rb",
    "./node_modules/flowbite/**/*.js"
  ],
  plugins: [
    require("postcss-import"),
    require("@tailwindcss/forms"),
    require("@tailwindcss/aspect-ratio"),
    require("flowbite/plugin")
  ]
};
