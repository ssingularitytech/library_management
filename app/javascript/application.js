// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "./dropdown";
import 'preline/dist/preline';


document.addEventListener("turbo:load", (e) => {
  HSStaticMethods.autoInit();
});
