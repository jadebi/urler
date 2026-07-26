const saved = localStorage.getItem("theme") || "auto";

document.documentElement.dataset.theme =
  saved === "auto"
    ? matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light"
    : saved;
