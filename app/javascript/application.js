import "@hotwired/turbo-rails"
import "infinite_scroll"


// フォルダフォームの開閉
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

document.addEventListener("turbo:load", setupFolderFormToggle);
if (document.readyState !== "loading") setupFolderFormToggle();

// アバターメニューの開閉
document.addEventListener("turbo:load", () => {
  const plusBtn = document.querySelector(".plus-btn");
  const menu = document.querySelector(".avatar-menu");

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
});

// アバター画像変更の自動送信
document.addEventListener("turbo:load", () => {
  const fileInput = document.querySelector("#user_avatar");

  if (fileInput) {
    fileInput.addEventListener("change", () => {
      fileInput.form.requestSubmit();
    });
  }
});

// フラッシュメッセージの自動削除
document.addEventListener("turbo:load", () => {
  const flashes = document.querySelectorAll(".flash");

  flashes.forEach(flash => {
    setTimeout(() => {
      flash.classList.add("fade-out");
    }, 3000);

    setTimeout(() => {
      flash.remove();
    }, 3500);
  });
});

