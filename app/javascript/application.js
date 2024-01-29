// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import "./controllers";
import "./dropdown";
import 'preline/dist/preline';
import 'fslightbox';
import SlimSelect from 'slim-select'

document.addEventListener("turbo:load", (e) => {
  HSStaticMethods.autoInit();

  const selectTags = document.querySelectorAll('select');

  selectTags.forEach((selectTag) => {
    new SlimSelect({
      select: selectTag,
      showSearch: false,
      allowDeselect: true,
      placeholder: true,
      settings: {
        closeOnSelect: false,
        placeholderText: selectTag.dataset.placeholder,
      }
    });
  });
});
