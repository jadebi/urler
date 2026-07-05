document.getElementById('submitBtn').addEventListener('click', function () {
  const usernameValue = document.getElementById('username').value;
  const scoreValue = parseInt(document.getElementById('score').value, 10);
  const responseDiv = document.getElementById('response');

  responseDiv.textContent = 'Sending...';

  const payload = {
    username: usernameValue,
    score: scoreValue
  };

  fetch('/api/submit', {
    method: 'POST',
    headers: {
      // By changing this to text/plain, Pegasus leaves the raw body alone
      'Content-Type': 'text/plain'
    },
    body: JSON.stringify(payload)
  })
    .then(res => res.json())
    .then(data => {
      responseDiv.textContent = JSON.stringify(data, null, 2);
    })
    .catch(err => {
      responseDiv.textContent = 'Error: ' + err.message;
    });
});