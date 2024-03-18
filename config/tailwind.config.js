module.exports = {
  darkMode: "class",
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js",
    "node_modules/preline/dist/*.js",
  ],
  plugins: [require("preline/plugin")],
};
