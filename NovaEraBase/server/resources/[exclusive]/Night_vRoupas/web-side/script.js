const app = document.getElementById('app');
const genderEl = document.getElementById('gender');
const cardsEl  = document.getElementById('cards');
const luaPre   = document.getElementById('luaBlock');

const btnClose   = document.getElementById('btnClose');
const btnCopyLua = document.getElementById('btnCopyLua');

const LABELS = {
  hat:        '<span class="glow-emoji">👒</span> Chapéus →',
  glass:      '<span class="glow-emoji">👓</span> Óculos →',
  backpack:   '<span class="glow-emoji">🎒</span> Mochilas →',
  vest:       '<span class="glow-emoji">🦺</span> Coletes →',
  accessory:  '<span class="glow-emoji">📿</span> Acessórios →',
  ear:        '<span class="glow-emoji">👂</span> Brincos →',
  watch:      '<span class="glow-emoji">⌚</span> Relógios →',
  tshirt:     '<span class="glow-emoji">👕</span> Camisas →',
  torso:      '<span class="glow-emoji">👔</span> Jaquetas →',
  pants:      '<span class="glow-emoji">👖</span> Calças →',
  arms:       '<span class="glow-emoji">🖐</span> Braços →',
  mask:       '<span class="glow-emoji">🎭</span> Máscaras →',
  bracelet:   '<span class="glow-emoji">💍</span> Pulseiras →',
  shoes:      '<span class="glow-emoji">👞</span> Sapatos →',
  decals:     '<span class="glow-emoji">🏷️</span> Adesivos →'
};

const ORDER = [
  'hat',        // Chapéu
  'glass',      // Óculos
  'backpack',   // Mochilas
  'vest',       // Coletes
  'accessory',  // Acessórios
  'ear',        // Brincos
  'watch',      // Relógios
  'tshirt',     // Camisas
  'torso',      // Jaquetas
  'pants',      // Calças
  'arms',       // Braços
  'mask',       // Máscaras
  'bracelet',   // Pulseiras
  'shoes',      // Sapatos
  'decals'      // Adesivos
];

function openUI(payload){
    app.classList.remove('hide');

    const modelKey = Object.keys(payload.outfit)[0] || "-";
    const gender = modelKey === "mp_m_freemode_01" ? "Masculino (mp_m_freemode_01)" 
                 : modelKey === "mp_f_freemode_01" ? "Feminino (mp_f_freemode_01)"
                 : "-";

    genderEl.textContent = gender;

    cardsEl.innerHTML = '';
    const outfitData = payload.outfit[modelKey] || {};
    ORDER.forEach(key => {
        const val = outfitData[key];
        const itemNumber = (val && val.item !== undefined) ? val.item : (key === "hat" || key === "bracelet" || key === "ear" || key === "glass" || key === "watch" ? -1 : 0);
        const textureNumber = (val && val.texture !== undefined) ? val.texture : 0;
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
          <h3>${LABELS[key] || key}</h3>
          <div class="value">{ item = ${itemNumber}, texture = ${textureNumber} }</div>
        `;
        cardsEl.appendChild(card);
    });

    luaPre.textContent  = payload.luaBlock || '';
}

function closeUI(){
  app.classList.add('hide');
  fetch(`https://${GetParentResourceName()}/close`, {
    method: 'POST',
    headers: {'Content-Type':'application/json'},
    body: JSON.stringify({})
  });
}

function copyText(str){
  const ta = document.createElement('textarea');
  ta.value = str;
  document.body.appendChild(ta);
  ta.select();
  ta.setSelectionRange(0, str.length);
  document.execCommand('copy');
  ta.remove();
}

btnClose.addEventListener('click', closeUI);
btnCopyLua.addEventListener('click', () => copyText(luaPre.textContent));

window.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') closeUI();
});

window.addEventListener('message', (event) => {
  const data = event.data || {};
  if (data.action === 'open') {
    openUI(data.payload);
  }
});

async function refreshFromClient(){
  try{
    const res = await fetch(`https://${GetParentResourceName()}/requestOutfit`, {
      method: 'POST',
      headers: {'Content-Type':'application/json'},
      body: JSON.stringify({})
    });
    const payload = await res.json();
    openUI(payload);
  }catch(e){}
}