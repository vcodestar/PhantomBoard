document.addEventListener("input", function (event) {

    console.log("inside resize");

    if (event.target.classList.contains("comment-textarea")) {
        event.target.style.height = 'auto';  
        event.target.style.height = `${event.target.scrollHeight}px`; 
    }
});





 
  
  