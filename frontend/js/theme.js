const html = document.documentElement;
const summary = document.querySelector("#theme-dropdown summary");
const links = document.querySelectorAll("#theme-dropdown a");
const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

function apply(theme) {
  html.dataset.theme = theme === "auto" ? (mediaQuery.matches ? "dark" : "light") : theme;
}

function load() {
  const saved = localStorage.getItem("theme") || "auto";
  apply(saved);
  const active = document.querySelector(`#theme-dropdown a[data-theme-option="${saved}"]`);
  if (active) summary.innerHTML = active.innerHTML;
}

links.forEach((link) => {
  link.addEventListener("click", (event) => {
    event.preventDefault();
    const theme = link.dataset.themeOption;
    localStorage.setItem("theme", theme);
    summary.innerHTML = link.innerHTML;
    apply(theme);
    document.getElementById("theme-dropdown").removeAttribute("open");
  });
});

mediaQuery.addEventListener("change", () => {
  const saved = localStorage.getItem("theme") || "auto";
  if (saved === "auto") apply("auto");
});

load();
