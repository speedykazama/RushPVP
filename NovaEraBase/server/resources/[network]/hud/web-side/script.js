const hud = document.getElementById("hud");
const avatarEl = document.getElementById("avatar");
const passportEl = document.getElementById("passport");
const nameEl = document.getElementById("name");
const healthEl = document.getElementById("health");
const armourEl = document.getElementById("armour");
const voipEl = document.getElementById("voip");
const radioEl = document.getElementById("radio");

const VoipLabels = {
	1: "Sussurro",
	2: "Normal",
	3: "Gritando",
	4: "Megafone",
	5: "Rádio"
};

function setVisible(visible) {
	hud.classList.toggle("hidden", !visible);
}

function setAvatar(url) {
	if (!url) return;
	avatarEl.src = url;
}

function setPassport(data) {
	if (!data) return;

	if (data.Passport !== undefined) {
		passportEl.textContent = "#" + data.Passport;
	}

	if (data.Name) {
		nameEl.textContent = data.Name;
	}

	if (data.Avatar) {
		setAvatar(data.Avatar);
	}
}

function setPlayer(data) {
	if (!data) return;

	healthEl.style.width = Math.max(0, Math.min(100, data.Health || 0)) + "%";
	armourEl.style.width = Math.max(0, Math.min(100, data.Armour || 0)) + "%";

	if (data.Avatar) {
		setAvatar(data.Avatar);
	}

	if (data.Voip !== undefined) {
		voipEl.textContent = VoipLabels[data.Voip] || "Normal";
	}

	if (data.Radio !== undefined) {
		radioEl.textContent = data.Radio;
	}
}

window.addEventListener("message", (event) => {
	const data = event.data || {};

	switch (data.Action) {
		case "Body":
			setVisible(!!data.Payload);
			break;
		case "Avatar":
			setAvatar(data.Payload);
			break;
		case "Passport":
			setPassport(data.Payload);
			break;
		case "Player":
			setPlayer(data.Payload);
			break;
		case "Voip":
			voipEl.textContent = VoipLabels[data.Payload] || "Normal";
			break;
		case "Radio":
			radioEl.textContent = data.Payload || "Offline";
			break;
	}
});

setVisible(false);
