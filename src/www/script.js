document.querySelector("form").addEventListener("submit", function (event) {
  event.preventDefault();

  console.log("submit intercepted");

  const url = document.getElementById("url").value;

  fetch("/api/shorten", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ url: url }),
  })
    .then((res) => res.json())
    .then((data) => {
      document.getElementById("response").textContent = JSON.stringify(
        data,
        null,
        2,
      );
    })
    .catch((err) => {
      document.getElementById("response").textContent = "Error: " + err.message;
    });
});
