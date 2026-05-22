let page = 1;
let loading = false;
let observer = null;

function setupInfiniteScroll() {
  const grid = document.getElementById("video-grid");
  const sentinel = document.getElementById("sentinel");
  const keywordInput = document.getElementById("keyword");

  if (!grid || !sentinel || !keywordInput) return;

  // 初期化（検索し直した時もここでリセットされる）
  page = 1;
  loading = false;

  // 既存の observer があれば解除
  if (observer) observer.disconnect();

  observer = new IntersectionObserver(async (entries) => {
    const entry = entries[0];
    if (!entry.isIntersecting) return;
    if (loading) return;

    const keyword = keywordInput.value;
    if (!keyword) return;

    loading = true;
    page += 1;

    try {
      const res = await fetch(
        `/searches.json?keyword=${encodeURIComponent(keyword)}&page=${page}`
      );

      if (!res.ok) {
        observer.disconnect();
        return;
      }

      const data = await res.json();

      if (!data.html || data.html.trim() === "") {
        observer.disconnect(); // これ以上は無い
        return;
      }

      grid.insertAdjacentHTML("beforeend", data.html);
    } catch (e) {
      console.error(e);
    } finally {
      loading = false;
    }
  }, {
    root: null,
    rootMargin: "200px",
    threshold: 0
  });

  observer.observe(sentinel);
}

// Turbo 対応
document.addEventListener("turbo:load", setupInfiniteScroll);
document.addEventListener("DOMContentLoaded", setupInfiniteScroll);
