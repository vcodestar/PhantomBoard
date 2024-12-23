function initializeDropdowns() {
    const dropdownButtons = document.querySelectorAll('.dropdown-toggle');
    dropdownButtons.forEach((button) => {
      new bootstrap.Dropdown(button); // Initialize Bootstrap Dropdown
    });
    console.log("Dropdowns initialized2");
    console.log("Dropdowns initialized2");
  }

  
  
  document.addEventListener("turbo:load", function () {
    console.log("Turbo Frame Loaded");
  
    // Initialize dropdowns and collapse toggles
    initializeDropdowns();
  });