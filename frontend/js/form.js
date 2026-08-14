import { validateUrl } from "./validation.js";

export function initForm() {
  const form = document.getElementById("form");
  const submitBtn = document.getElementById("submit");

  const urlInput = form.querySelector('input[name="url"]');
  const metaUrlInput = form.querySelector('input[name="meta-url"]');
  
  const urlError = document.getElementById("url-error");
  const metaUrlError = document.getElementById("meta-url-error");

  function validateField(input, errorEl, { optional = false } = {}) {
    if (optional && !input.value) {
      errorEl.textContent = "";
      errorEl.style.display = "none";
      return true;
    }

    const result = validateUrl(input.value);
    errorEl.textContent = result.message;
    errorEl.style.display = result.valid ? "none" : "block";
    return result.valid;
  }

  function updateButton() {
    const urlValid = validateField(urlInput, urlError);
    const metaUrlValid = validateField(metaUrlInput, metaUrlError, {
      optional: true,
    });

    submitBtn.disabled = !urlValid || !metaUrlValid;
  }

  urlInput.addEventListener("input", updateButton);
  metaUrlInput.addEventListener("input", updateButton);

  return { form, urlInput, metaUrlInput };
}
