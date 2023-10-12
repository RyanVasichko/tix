module.exports = {
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
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "./config/application.rb"
  ],
  plugins: ["postcss-import", "@tailwindcss/forms", "@tailwindcss/aspect-ratio"]
};
