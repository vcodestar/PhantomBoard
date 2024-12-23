document.addEventListener("DOMContentLoaded", function() {
  // Check if we are on a `posts/:id` URL
  const path = window.location.pathname;
  const isPostsShowPage = /^\/posts\/\d+$/.test(path); // Matches `/posts/` followed by a number (e.g., `/posts/1`)

  if (isPostsShowPage) {
      // Restore the previous scroll position
      const previousScrollPosition = sessionStorage.getItem('scrollPosition');
      if (previousScrollPosition) {
          setTimeout(function() {
              window.scrollTo(0, previousScrollPosition);
          }, 0);
      }

      // Handle the "back" link
      const backLink = document.getElementById('back-link');
      if (backLink) {
          backLink.addEventListener('click', function() {
              sessionStorage.setItem('scrollPosition', window.scrollY);
          });
      }

      // Save the current scroll position
      window.addEventListener('scroll', function() {
          sessionStorage.setItem('scrollPosition', window.scrollY);
      });
  }
});

function initializeDropdowns() {
  const dropdownButtons = document.querySelectorAll('.dropdown-toggle');
  dropdownButtons.forEach((button) => {
    new bootstrap.Dropdown(button); // Initialize Bootstrap Dropdown
  });
  console.log("Dropdowns initialized");
}

document.addEventListener("turbo:load", function () {
  console.log("Turbo Frame Loaded");

  // Initialize dropdowns and collapse toggles
  initializeDropdowns();
});