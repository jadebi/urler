import * as api from "./api.js";
import { initForm } from "./form.js";

document.addEventListener("DOMContentLoaded", function () {
  const { form, urlInput, metaUrlInput } = initForm();

  form.addEventListener("submit", async function (event) {
    event.preventDefault();
    const submitBtn = document.getElementById("submit");
    submitBtn.ariaBusy = "true";

    const response = await api.sendRequest({
      url: urlInput.value,
      meta_url: metaUrlInput?.value || null,
    });

    if (response.ok) {
      const data = await response.json();
      submitBtn.ariaBusy = "false";
      submitBtn.ariaInvalid = "false";
      console.log(data);
    } else {
      submitBtn.ariaBusy = "false";
      submitBtn.ariaInvalid = "true";
    }
  });
});
