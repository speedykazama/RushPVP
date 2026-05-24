const params = Object.fromEntries(new URLSearchParams(location.search).entries())
document.documentElement.style.fontSize = params.fontSize + 1

let clicks = 0

function increase() {
  document.querySelector('p').innerText = ++clicks
}

function back() {
  fetch('http://smartphone/keydown', {
    method: 'POST',
    body: JSON.stringify('Backspace')
  })
}

function ponto() {
  $.post("http://ponto/Ponto", JSON.stringify({
  }));
}

/* ----------FORMAT---------- */
const format = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}
window.addEventListener('keydown', ({ key }) => {
  if (key === 'Backspace' || key === 'Escape') {
    fetch('http://smartphone/keydown', {
      method: 'POST',
      body: JSON.stringify({ key })
    })
  }
})