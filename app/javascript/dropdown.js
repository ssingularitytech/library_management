document.addEventListener("DOMContentLoaded", function () {
  const dropdownButton = document.querySelector(".hs-dropdown"); // Replace with your button selector
  const dropdownMenu = document.querySelector(".hs-dropdown-menu"); // Replace with your dropdown menu selector

  dropdownButton.addEventListener("click", function () {
    dropdownMenu.classList.toggle("hidden");
    dropdownMenu.classList.toggle("opacity-0");
  });

  // Close the dropdown when clicking outside of it
  document.addEventListener("click", function (event) {
    if (!dropdownButton.contains(event.target) && !dropdownMenu.contains(event.target)) {
      dropdownMenu.classList.add("hidden opacity-0");
    }
  });
});
