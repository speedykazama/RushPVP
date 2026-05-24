const IMAGE_BASE_TATTOS = 'http://localhost/tattoos'; // Diretório das imagens das tatuagens da base

var app = new Vue({
    el: '#app',
    template: `<div v-if="menu" class="menuContainer">

        <img src="./assets/menuBackground.png" alt="">

        <div class="menuContent">
            <header>
                <h1>{{selectedCategory == 'hair' ? 'Micropigmentação' : 
                    selectedCategory == 'head' ? 'Cabeça' : (
                        selectedCategory == 'torso' ? 'Torso' : (
                            selectedCategory == 'leftarm' ? 'Braço Esquerdo' : (
                                selectedCategory == 'rightarm' ? 'Braço Direito' : (
                                    selectedCategory == 'leftleg' ? 'Perna Esquerda' : (
                                        selectedCategory == 'rightleg' ? 'Perna Direita' : ''
                                    )
                                )
                            )
                        )
                    )
                }}</h1>
            </header>

            <nav>
            	<div @click="selectedCategory = 'hair',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'hair'}" class="categoryIcon">
					<img src="./assets/categoryIcon1.svg" alt="">
				</div>
                <div @click="selectedCategory = 'head',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'head'}" class="categoryIcon">
                    <img src="./assets/categoryIcon2.svg" alt="">
                </div>
                <div @click="selectedCategory = 'torso',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'torso'}" class="categoryIcon">
                    <img src="./assets/categoryIcon3.svg" alt="">
                </div>
                <div @click="selectedCategory = 'leftarm',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'leftarm'}" class="categoryIcon">
                    <img src="./assets/categoryIcon4.svg" alt="">
                </div>
                <div @click="selectedCategory = 'rightarm',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'rightarm'}" class="categoryIcon">
                    <img src="./assets/categoryIcon5.svg" alt="">
                </div>
                <div @click="selectedCategory = 'leftleg',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'leftleg'}" class="categoryIcon">
                    <img src="./assets/categoryIcon6.svg" alt="">
                </div>
                <div @click="selectedCategory = 'rightleg',selectedComponent = -1" :class="{selectedCategory: selectedCategory == 'rightleg'}" class="categoryIcon">
                    <img src="./assets/categoryIcon7.svg" alt="">
                </div>
            </nav>

            <main>
                <div @click="selectItem(index)" :class="{purchasedItem: components[selectedCategory][index].purchased || selectedComponent -1 == index}" v-for="(v,index) in components[selectedCategory]" class="item">
                    <img :src="getTattooImagePath(selectedCategory, index + 1)" class="tattoo-image" :alt="'Tattoo ' + (index + 1)">
                </div>
            </main>

            <footer>
                <div @click="limpar" class="button">
                    <h1>Limpar</h1>
                </div>
                <div @click="closeUI" class="button">
                    <h1>Salvar</h1>
                </div>
            </footer>
        </div>

		<div class="rotateButtonsContainer">
			<div class="rotateButtons">
				<div class="button">
					<h1>A</h1>
				</div>
				<div class="button">
					<h1>D</h1>
				</div>
				<div class="button">
					<h1>X</h1>
				</div>
			</div>

			<h1>Rotacionar</h1>
		</div>
	</div>`,

    data: {
        menu: false,
        gender: "Masculino",
        selectedComponent: -1,
        components: {
            hair: [
                { purchased: false },
                { purchased: false },
            ],
            head: [
                { purchased: false },
                { purchased: false },
            ],
            torso: [
                { purchased: false },
                { purchased: false },
            ],
            leftarm: [
                { purchased: false },
                { purchased: false },
            ],
            rightarm: [
                { purchased: false },
                { purchased: false },
            ],
            leftleg: [
                { purchased: false },
                { purchased: false },
            ],
            rightleg: [
                { purchased: false },
                { purchased: false },
            ],
        },
        selectedCategory: 'hair',
        audio: new Audio('nui://tattooshop/web-side/assets/maquininha.mp3')
    },

    methods: {
        selectItem(index) {
            let category = this.selectedCategory;
            let number = index + 1;
            this.selectedComponent = number;

            this.audio.play();

            if (!this.components[category][index].purchased) {
                this.components[category][index].purchased = true;
            } else {
                this.components[category][index].purchased = false;
                this.selectedComponent = -1;
            }

            axios.post('http://tattooshop/Change', {
                type: category,
                id: number
            });
        },

        limpar() {
            axios.post('http://tattooshop/Clean');
            Object.keys(this.components).map((table, index) => {
                Object.keys(this.components[table]).map((e, tattoIndex) => {
                    if (this.components[table][e].purchased) {
                        this.components[table][e].purchased = false;
                        this.selectedComponent = -1;
                    }
                });
            });
        },

        searchCategory(tattoName) {
            Object.keys(this.components).map((table, index) => {
                Object.keys(this.components[table]).map((e, tattoIndex) => {
                    if (this.components[table][e].name == tattoName) {
                        this.components[table][e].purchased = true;
                    }
                });
            });
        },

        formatObject(data) {
            Object.keys(data).map((e, index) => {
                let category = this.searchCategory(e);
            });
        },

        openUI(data, myTattos, gender) {
            this.components = data;
            this.formatObject(myTattos);
            this.gender = gender || "Masculino";
            this.menu = true;
        },

        closeUI() {
            this.menu = false;
            this.selectedComponent = -1;
            axios.post('http://tattooshop/Close');
        },

        getTattooImagePath(category, index) {
            const sex = this.gender === "Masculino" ? "male" : "female";
            return `${IMAGE_BASE_TATTOS}/${sex}/${category}/${index}.png`;
        },
    },

    mounted() {
        document.addEventListener('keydown', (event) => {
            if (app.menu) {
                if (event.key == 'Escape') {
                    app.closeUI();
                } else if (event.key == 'x') {
                    axios.post('http://tattooshop/HandsUp');
                }
            }
        });

		document.addEventListener("keypress", (event) => {
			if (event["key"] == "a" || event["key"] == "A") {
				axios.post("http://tattooshop/Rotate", { direction: "Left" });
			} else if (event["key"] == "d" || event["key"] == "D") {
				axios.post("http://tattooshop/Rotate", { direction: "Right" });
			}
		}, false);

        window.addEventListener("message", function (event) {
            app.openUI(event.data.shop, event.data.tattoo, event.data.gender);
        });
    }
});