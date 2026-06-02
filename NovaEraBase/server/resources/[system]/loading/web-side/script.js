const LoadingApp = {
	els: {},
	data: {
		video: "video/video.webm",
		socials: [],
		playlist: [],
		shortcuts: {},
		autoplay: true,
		title: "Rush PvP",
		subtitle: "Servidor de PvP"
	},
	state: {
		playlistIndex: 0,
		totalSteps: 0,
		currentStep: 0,
		ready: false,
		manuallyPaused: false
	},

	init() {
		this.cacheElements();
		this.applyHandover(window.nuiHandoverData);
		this.bindEvents();
		this.renderAll();
	},

	cacheElements() {
		this.els = {
			video: document.getElementById("bg-video"),
			audio: document.getElementById("bg-audio"),
			socials: document.getElementById("socials-container"),
			shortcutsPanel: document.getElementById("shortcuts-panel"),
			shortcutsList: document.getElementById("shortcuts-list"),
			title: document.getElementById("loading-title"),
			subtitle: document.getElementById("loading-subtitle"),
			artist: document.getElementById("music-artist"),
			track: document.getElementById("music-title"),
			cover: document.getElementById("music-cover"),
			currentTime: document.getElementById("music-current-time"),
			totalTime: document.getElementById("music-total-time"),
			progressFill: document.getElementById("progress-fill"),
			prev: document.getElementById("prev-btn"),
			play: document.getElementById("play-pause-btn"),
			next: document.getElementById("next-btn"),
			volume: document.getElementById("volume-slider"),
			volumeIcon: document.getElementById("volume-icon"),
			message: document.getElementById("loading-message"),
			percentage: document.getElementById("loading-percentage"),
			bar: document.getElementById("loading-bar")
		};
	},

	applyHandover(payload) {
		if (!payload || typeof payload !== "object") {
			return;
		}

		Object.assign(this.data, payload);

		if (this.data.socials && !Array.isArray(this.data.socials)) {
			this.data.socials = Object.values(this.data.socials);
		}

		if (this.data.playlist && !Array.isArray(this.data.playlist)) {
			this.data.playlist = Object.values(this.data.playlist);
		}

		if (this.data.shortcuts && !Array.isArray(this.data.shortcuts)) {
			this.data.shortcuts = this.data.shortcuts;
		}
	},

	renderAll() {
		this.renderBrand();
		this.renderSocials();
		this.renderShortcuts();
		this.setupVideo();
		this.setupPlaylist();
		this.updateVolumeUI();
		this.state.ready = true;
	},

	renderBrand() {
		this.els.title.textContent = this.data.title || "Rush PvP";
		this.els.subtitle.textContent = this.data.subtitle || "Servidor de PvP";
	},

	renderSocials() {
		this.els.socials.innerHTML = "";

		(this.data.socials || []).forEach((social) => {
			if (!social || !social.url) {
				return;
			}

			const link = document.createElement("a");
			link.className = "social-btn";
			link.href = social.url;
			link.target = "_blank";
			link.rel = "noopener noreferrer";
			link.innerHTML = `<i class="fa-brands fa-${social.type}"></i>`;
			this.els.socials.appendChild(link);
		});
	},

	renderShortcuts() {
		const shortcuts = this.data.shortcuts || {};
		const entries = Object.entries(shortcuts).filter(([, label]) => label && label !== "");

		if (!entries.length) {
			this.els.shortcutsPanel.classList.add("hidden");
			return;
		}

		this.els.shortcutsPanel.classList.remove("hidden");
		this.els.shortcutsList.innerHTML = "";

		entries.forEach(([key, label]) => {
			const item = document.createElement("li");
			item.innerHTML = `<span>${label}</span><kbd>${key}</kbd>`;
			this.els.shortcutsList.appendChild(item);
		});
	},

	setupVideo() {
		const source = this.data.video || "video/video.webm";
		this.els.video.src = source;
		this.els.video.loop = true;
		this.els.video.muted = true;
		this.els.video.playsInline = true;

		const playVideo = () => {
			this.els.video.play().catch(() => {});
		};

		this.els.video.addEventListener("ended", playVideo);
		this.els.video.addEventListener("error", () => {
			this.els.video.style.display = "none";
		});

		playVideo();

		setInterval(() => {
			if (!this.els.video.paused && !this.els.video.ended) {
				return;
			}

			if (this.els.video.ended) {
				this.els.video.currentTime = 0;
			}

			playVideo();
		}, 1500);
	},

	setupPlaylist() {
		if (!this.data.playlist || !this.data.playlist.length) {
			return;
		}

		this.loadTrack(0);
		this.els.audio.volume = this.els.volume.value / 100;

		if (this.data.autoplay !== false) {
			this.playMusic();
		}

		const unlockAudio = () => {
			if (this.data.autoplay !== false && this.els.audio.paused) {
				this.playMusic();
			}

			document.removeEventListener("mousedown", unlockAudio);
			document.removeEventListener("keydown", unlockAudio);
		};

		document.addEventListener("mousedown", unlockAudio);
		document.addEventListener("keydown", unlockAudio);
	},

	loadTrack(index) {
		const playlist = this.data.playlist || [];
		if (!playlist.length) {
			return;
		}

		this.state.playlistIndex = ((index % playlist.length) + playlist.length) % playlist.length;
		const track = playlist[this.state.playlistIndex];

		this.els.audio.src = track.file || "audio/audio.mp3";
		this.els.track.textContent = track.name || "Sem titulo";
		this.els.artist.textContent = track.artist || "Rush PvP";
		this.els.cover.src = track.image || "./logo.PNG";
		this.els.audio.load();
	},

	playMusic() {
		this.state.manuallyPaused = false;

		this.els.audio.play().then(() => {
			this.els.play.innerHTML = '<i class="fa-solid fa-pause"></i>';
		}).catch(() => {
			this.els.play.innerHTML = '<i class="fa-solid fa-play"></i>';
		});
	},

	pauseMusic() {
		this.state.manuallyPaused = true;
		this.els.audio.pause();
		this.els.play.innerHTML = '<i class="fa-solid fa-play"></i>';
	},

	toggleMusic() {
		if (this.els.audio.paused) {
			this.playMusic();
		} else {
			this.pauseMusic();
		}
	},

	prevTrack() {
		this.loadTrack(this.state.playlistIndex - 1);
		this.playMusic();
	},

	nextTrack() {
		this.loadTrack(this.state.playlistIndex + 1);
		this.playMusic();
	},

	formatTime(seconds) {
		if (!Number.isFinite(seconds)) {
			return "0:00";
		}

		const minutes = Math.floor(seconds / 60);
		const secs = Math.floor(seconds % 60);
		return `${minutes}:${secs < 10 ? "0" : ""}${secs}`;
	},

	updateProgress(value) {
		const progress = Math.max(0, Math.min(100, Math.round(value)));
		this.els.bar.style.width = `${progress}%`;
		this.els.percentage.textContent = `${progress}%`;
	},

	updateVolumeUI(value = this.els.volume.value) {
		this.els.volume.style.backgroundSize = `${value}% 100%`;

		if (value == 0) {
			this.els.volumeIcon.className = "fa-solid fa-volume-xmark";
		} else if (value < 50) {
			this.els.volumeIcon.className = "fa-solid fa-volume-low";
		} else {
			this.els.volumeIcon.className = "fa-solid fa-volume-high";
		}
	},

	bindEvents() {
		this.els.play.addEventListener("click", () => this.toggleMusic());
		this.els.prev.addEventListener("click", () => this.prevTrack());
		this.els.next.addEventListener("click", () => this.nextTrack());
		this.els.audio.addEventListener("ended", () => this.nextTrack());

		this.els.audio.addEventListener("timeupdate", () => {
			if (!Number.isFinite(this.els.audio.duration)) {
				return;
			}

			this.els.currentTime.textContent = this.formatTime(this.els.audio.currentTime);
			this.els.totalTime.textContent = this.formatTime(this.els.audio.duration);

			const progress = (this.els.audio.currentTime / this.els.audio.duration) * 100;
			this.els.progressFill.style.width = `${progress}%`;
		});

		this.els.volume.addEventListener("input", (event) => {
			const value = event.target.value;
			this.els.audio.volume = value / 100;
			this.updateVolumeUI(value);
		});

		window.addEventListener("keydown", (event) => {
			if (event.code === "Space") {
				event.preventDefault();
				this.toggleMusic();
			}

			if (event.code === "ArrowUp") {
				this.els.volume.value = Math.min(100, parseInt(this.els.volume.value, 10) + 10);
				this.els.volume.dispatchEvent(new Event("input"));
			}

			if (event.code === "ArrowDown") {
				this.els.volume.value = Math.max(0, parseInt(this.els.volume.value, 10) - 10);
				this.els.volume.dispatchEvent(new Event("input"));
			}

			if (event.code === "ArrowLeft") {
				this.prevTrack();
			}

			if (event.code === "ArrowRight") {
				this.nextTrack();
			}
		});

		window.addEventListener("message", (event) => {
			const payload = event.data;
			if (!payload || !payload.eventName) {
				return;
			}

			switch (payload.eventName) {
				case "loadConfig":
					this.applyHandover(payload);
					if (this.state.ready) {
						this.renderAll();
					}
					break;
				case "startInitFunctionOrder":
					this.state.totalSteps = payload.count || 0;
					this.els.message.textContent = "A inicializar";
					break;
				case "initFunctionInvoking":
					if (this.state.totalSteps > 0) {
						this.updateProgress((payload.idx / this.state.totalSteps) * 100);
					}
					this.els.message.textContent = "A preparar recursos";
					break;
				case "startDataFileEntries":
					this.state.totalSteps = payload.count || 0;
					this.state.currentStep = 0;
					this.els.message.textContent = "A carregar dados";
					break;
				case "performMapLoadFunction":
					this.state.currentStep++;
					if (this.state.totalSteps > 0) {
						this.updateProgress((this.state.currentStep / this.state.totalSteps) * 100);
					}
					this.els.message.textContent = "A entrar na cidade";
					break;
			}
		});
	}
};

document.addEventListener("DOMContentLoaded", () => LoadingApp.init());
