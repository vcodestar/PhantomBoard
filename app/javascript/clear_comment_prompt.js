
function resetTextarea(event) {
    if (event.target.classList.contains("post-comment-btn")) {
        console.log("Post comment button clicked.");

        const form = event.target.closest("form");
        const textarea = form ? form.querySelector(".comment-textarea") : null;

        if (textarea) {
            console.log("Text area found, submitting comment.");
            
            form.addEventListener('turbo:submit-end', function(event) {
                if (event.detail.success) {
                    console.log("Comment posted successfully. Resetting textarea.");
                    textarea.value = "";  
                    textarea.style.height = "auto";  
                }
            });
        }
    }
}

document.addEventListener("turbo:load", function () {
    console.log("Turbo Frame Loaded");

    document.addEventListener("click", resetTextarea);
    
    console.log("Turbo loaded, script initialized.");
});