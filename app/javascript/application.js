// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
  const plusBtn = document.querySelector(".plus-btn");
  const menu = document.querySelector(".avatar-menu");
  const fileInput = document.querySelector("#user_avatar");

  if (plusBtn && menu) {
    plusBtn.addEventListener("click", (event) => {
      event.stopPropagation();
      menu.classList.toggle("active");
    });

    menu.addEventListener("click", (event) => {
      event.stopPropagation();
    });

    document.addEventListener("click", () => {
      menu.classList.remove("active");
    });
  }

  if (fileInput) {
    fileInput.addEventListener("change", () => {
      fileInput.form.requestSubmit();
    });
  }
});

