import "@hotwired/turbo-rails"
import "infinite_scroll"


const setupFolderFormToggle = () => {
  const btn = document.getElementById("show-folder-form");
  const form = document.getElementById("folder-form");

  if (!btn || !form || btn.dataset.folderFormBound === "true") {
    return;
  }

  btn.dataset.folderFormBound = "true";
  btn.addEventListener("click", () => {
    form.style.display = (form.style.display === "none") ? "block" : "none";
  });
};

const setupAvatarMenu = () => {
  const plusBtn = document.querySelector(".plus-btn");
  const menu = document.querySelector(".avatar-menu");

  if (!plusBtn || !menu || plusBtn.dataset.avatarMenuBound === "true") {
    return;
  }

  plusBtn.dataset.avatarMenuBound = "true";
  plusBtn.addEventListener("click", (event) => {
    event.stopPropagation();
    menu.classList.toggle("active");
  });

  menu.addEventListener("click", (event) => {
    event.stopPropagation();
  });
};

const setupAvatarAutoSubmit = () => {
  const fileInput = document.querySelector("#user_avatar");

  if (!fileInput || fileInput.dataset.autoSubmitBound === "true") {
    return;
  }

  fileInput.dataset.autoSubmitBound = "true";
  fileInput.addEventListener("change", () => {
    fileInput.form.requestSubmit();
  });
};

const setupFlashMessages = () => {
  const flashes = document.querySelectorAll(".flash");

  flashes.forEach(flash => {
    if (flash.dataset.autoDismissBound === "true") {
      return;
    }

    flash.dataset.autoDismissBound = "true";
    setTimeout(() => {
      flash.classList.add("fade-out");
    }, 3000);

    setTimeout(() => {
      flash.remove();
    }, 3500);
  });
};

const closeAvatarMenus = () => {
  document.querySelectorAll(".avatar-menu.active").forEach(menu => {
    menu.classList.remove("active");
  });
};

const setupPageScripts = () => {
  setupFolderFormToggle();
  setupAvatarMenu();
  setupAvatarAutoSubmit();
  setupFlashMessages();
};

document.addEventListener("click", closeAvatarMenus);
document.addEventListener("turbo:load", setupPageScripts);

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", setupPageScripts);
} else {
  setupPageScripts();
}
