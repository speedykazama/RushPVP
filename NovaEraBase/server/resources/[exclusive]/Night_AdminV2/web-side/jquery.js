$(document).ready(function(){
	window.addEventListener("message",function(event){

		$(".searchitens").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".itens-overflow .nome-inventario").filter(function () {
			  $(this).closest(".item-inventario").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		$(".searchgaragem").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".nome-garagem").filter(function () {
			  $(this).closest(".item-garagem").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		$(".searchplayers").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".item-controle").filter(function () {
				let id = $(this).find(".item-header").first().text().toLowerCase();
				let name = $(this).find(".nome-controle").text().toLowerCase();
				$(this).toggle(id.indexOf(search) > -1 || name.indexOf(search) > -1);
			});
		});

		$(".searchgerenciar").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".item-header").filter(function () {
			  $(this).closest(".item-gerenciar").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		$(".searchskins").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".nome-skin").filter(function () {
			  $(this).closest(".item-overflowskins").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		$(".searchbausfac").on("keyup", function () {
			let search = $(this).val().toLowerCase();
			$(".item-header").filter(function () {
			  $(this).closest(".item-baus").toggle($(this).text().toLowerCase().indexOf(search) > -1)
			});
		});

		switch(event.data.action){
			case "showMenu":
				CloseAll()
				LimparInputs()
				Reload()

				$("#pagina-inicio").show();
				$("#players-online").html(event.data.players);
				$("#policia-online").html(event.data.police);
				$("#ilegal-online").html(event.data.ilegal);
				$("#staff-online").html(event.data.staff);
				SetNomes(event.data.nome, event.data.sobrenome);
				$(".img-screenshot").attr(`src`,"nui://Night_AdminV2/web-side/images/loading2.gif");
				$("#img1").attr(`src`,event.data.imagem);

				$("body").fadeIn(800);
			break;
		}
	});

	document.addEventListener("keydown",function(event) {
		if (event.key == "Escape"){
			$(".adicionar-teleportBox").fadeOut(500);
			$("body").fadeOut();	
			$.post("http://Night_AdminV2/staffClose");
		}
	})

});

function SairPainel(){
    $(".adicionar-teleportBox").fadeOut(500);
    $("body").fadeOut();	
    $.post("http://Night_AdminV2/staffClose");
}
// ---------------------------------------
// -- Sistema de Teleport
// ---------------------------------------

function listTeleport(){
    $.post("http://Night_AdminV2/CoordsLista",JSON.stringify({}),(data) => {
		let coordenadas = data.teleporteslista
		$('.telport-box-2').empty()
		coordenadas.forEach((key,value) => {
			$('.telport-box-2').prepend(`

				<div class="item-teleport">
					<div class="nome-teleort" onclick="teleportPlayer(this)" data-index="${key.nome}" data-x="${key.coord.x}" data-y="${key.coord.y}" data-z = "${key.coord.z}"><i class="fas fa-angle-right" style="margin-right: 10px; font-size: 11px;"></i>${key.nome}</div>
					<i onclick="deleteTeleport(this)" data-id="${key.id}" data-nome="${key.nome}" class="fas fa-trash icontrash"></i>
				</div>

			`)
		});
    });
}

function createCoord(){
	let $el = $('.criar-teleport:hover');
	let nome = $("#nome-teleport-create").val();
	if($el.length) {
		$.post("http://Night_AdminV2/addteleport",JSON.stringify({
			nome:nome
		}), (data) =>{ 
			if(data.retorno == 'done') {
				closeCoord()
				LimparInputs()
				Reload()
			} 
		});
	}
};



function openCoord(){
    $(".format").fadeIn(500);
	$(".adicionar-tp-resquest").fadeIn(500);
}

function closeCoord(){
    $(".format").fadeOut(500);
	$(".adicionar-tp-resquest").fadeOut(500);
}

function teleportPlayer(data) {
	$.post("https://Night_AdminV2/teleport",JSON.stringify({name:data.dataset.index,x:data.dataset.x,y:data.dataset.y,z:data.dataset.z}))
}

function deleteTeleport(data) {
	$.post("https://Night_AdminV2/deleteteleport",JSON.stringify({
		id : data.dataset.id,
		nome : data.dataset.nome,
	}), (data) => {
			LimparInputs()
			Reload()
		}
	)
}

// ---------------------------------------
// -- Sistema de Logs
// ---------------------------------------

function listLogs(){
    $.post("http://Night_AdminV2/LogsLista",JSON.stringify({}),(data) => {
		let logs = data.logslista
		$('.logs-box2').empty()
		logs.forEach((key,value) => {
			$('.logs-box2').prepend(`

				<div class="item-logs">
					<div class="identificador" style="background: ${key.cor};"></div>
					<img src="${key.img}" alt="">
					<div class="nome">${key.nome} [${key.user_id}]</div>
					<div class="separador" style="background: ${key.cor};"></div>
					<div class="motivo">${key.motivo}</div>
				</div>

			`)
		});
    });
}

// ---------------------------------------
// -- Sistema de Controle
// ---------------------------------------
function listaControle() {
    $.post("http://Night_AdminV2/ControleLista", JSON.stringify({}), (data) => {
        let usuarios = data.controlelista.sort((a, b) => (b.user_id > a.user_id ? 1 : -1));
        $('.box-controle').empty();

        usuarios.forEach((key) => {
            // Garante que o status seja sempre maiúsculo
            let status = key.status.toUpperCase();

            $('.box-controle').prepend(`
                <div class="item-controle">
                    <div class="item-header" style="width: 8%;">${key.user_id}</div>
                    <div class="item-header2">
                        <img src="${key.foto}" alt="">
                        <div class="nome-controle">${key.nome}</div>
                    </div>

                    <div class="item-header3">
                        <div class="status ${status}">${status}</div>
                    </div>

                    <div class="item-header4">
                        <i onclick="enviarIDPlayer(this)" data-passaporte="${key.user_id}" data-tipo="SADVS" data-nome="${key.nome}" class="far fa-hammer iconheader" style="margin-left: 38%;"></i>
                        <i onclick="enviarIDPlayer(this)" data-passaporte="${key.user_id}" data-tipo="VERPERFIL" data-nome="${key.nome}" class="far fa-exclamation-circle iconheader"></i>
                    </div>
                </div>
            `);
        });
    });
}

function enviarIDPlayer(data) {
	$.post("https://Night_AdminV2/EnviarID", JSON.stringify({
	  passaporte: data.dataset.passaporte,
	  tipo: data.dataset.tipo
	}), (data) => {
	  if (data.tipo == "SADVS") {
		$("#player-sendo-verificado8").html(`${data.nome} ${data.sobrenome} [${data.passaporte}]`);
		$(".aplicar-punicao").show(0);
		$(".format").fadeIn(700);
	  }

	  if (data.tipo == "VERPERFIL") {
		Sfechar();

		$("#nome-jogador").html(data.nome + " " + data.sobrenome);
		$("#celular-jogador").html(data.celular);
		$("#registro-jogador").html(data.registro);

		$("#carteira-jogador").html(data.carteira + " $");
		$("#banco-jogador").html(data.banco + " $");
		$("#coins-jogador").html(data.coins);
		$("#idade-jogador").html(data.idade);

		$("#nPlayer-VerPerfil2").html(data.nome + " " + data.sobrenome);

		if (data.emprego == false) {
		  $("#emprego-jogador").text('Desempregado');
		} else {
		  $("#emprego-jogador").text(data.emprego);
		}

		if (data.vip == false) {
		  $("#vip-jogador").text('Sem VIP');
		} else {
		  $("#vip-jogador").text(data.vip);
		}

		$("#SetIdentidade-Banner").attr('src', data.banner);
		$("#SetIdentidade-Img").attr('src', data.img);

		$("#pagina-VerPerfil").fadeIn(700);
	  }
	});
}

function closeViewInventory(){
	$(".format").fadeOut(500);
	$(".ver-inventario").fadeOut(500);
}

function closeViewGaragem(){
	$(".format").fadeOut(500);
	$(".ver-garagem").fadeOut(500);
}

function closeAviso(){
	$(".format").fadeOut(500);
	$(".criar-aviso").fadeOut(500);
}

function createAviso(){
	let $el = $('.criar-teleport:hover');
	let motivo = $("#aviso-input").val();
	if($el.length) {
		$.post("http://Night_AdminV2/addAviso",JSON.stringify({
			motivo:motivo
		}), (data) =>{ 
			if(data.retorno == 'done') {
				closeAviso()
				LimparInputs()
				Reload()
			} 
		});
	}
};


// ---------------------------------------
// -- Lista de Punicoes
// ---------------------------------------

function PunicoesLista(){
    $.post("http://Night_AdminV2/PunicoesLista", JSON.stringify({}), (data) => {
        let punicoes = data.punicoes.sort((a,b) => (a.id > b.id) ? 1 : -1);
        $('.box-punicoes').empty();
        punicoes.forEach((key,value) => {
            $('.box-punicoes').prepend(`
                <div class="item-controle">
                    <div class="item-header" style="width: 8%;">${key.user_id}</div>
                    <div class="item-header2">
                        <img src="${key.foto}" alt="">
                        <div class="nome-controle">${key.nome}</div>
                    </div>
                    <div class="item-header3">
                        <div class="status" style="background: ${key.background}; color: ${key.color};">${key.status} ${key.contagem}</div>
                    </div>
                    <div class="item-header4">
                        <i onclick="enviarIDInv5(this)" data-myname="${key.myname}" data-passaporte="${key.user_id}" data-nome="${key.nome}" data-motivo="${key.motivo}" data-staff="${key.staff}" data-data="${key.data}" data-duracao="${key.duracao || 'Indefinido'}" class="far fa-eye iconheader" style="margin-left: 40%;"></i>
                        <i onclick="DeleteAdv(this)" data-passaporte="${key.user_id}" data-contagem="${key.contagem}" data-status="${key.status}" class="far fa-trash iconheader"></i>
                    </div>
                </div>
            `);
        });
    });
}


function DeleteAdv(data) {
	$.post("https://Night_AdminV2/DeleteAdv",JSON.stringify({
		passaporte : data.dataset.passaporte,
		status : data.dataset.status,
		contagem: data.dataset.contagem
	}), (data) => {
			LimparInputs()
			Reload()
		}
	)
}

function enviarIDInv5(data) {
	$("#name27").html(data.dataset.myname);
	$("#player-sendo-verificado10").html(data.dataset.nome);

	$("#inf-punicao1").html(data.dataset.staff);
	$("#inf-punicao2").html(data.dataset.motivo);
	$("#inf-punicao3").html(data.dataset.data);
	$("#inf-punicao4").html(data.dataset.duracao);

	$(".ver-motivo-punicao").show(0);
	$(".format").fadeIn(700);
}

function closeVerMotivo(){
	$(".format").fadeOut(500);
	$(".ver-motivo-punicao").fadeOut(500);
}


// ---------------------------------------
// -- Lista de Itens
// ---------------------------------------

function ItensLista(){
    $.post("http://Night_AdminV2/ItensLista",JSON.stringify({}),(data) => {
	
		let itens = data.itens.sort((a,b) => (b.name > a.name) ? 1: -1);
		$('.itens-overflow').empty()
		itens.forEach((key,value) => {
			$('.itens-overflow').prepend(`

				<div class="item-inventario" onclick="FormatConfirmItem(this)" data-item="${key.item}" data-name="${key.name}" data-index="${key.index}" data-linkinventario="${key.linkinventario}">
				<div class="nome-inventario">${key.name}</div>
					<img id="img-2" src="${key.linkinventario}/${key.index}.png" alt="">
					<div class="quantidade-item" style="color: transparent;">1x</div>
					<div class="barra1"></div>
				</div>

			`)
		});
    });
}

function FormatConfirmItem(data) {
    $("#itempegar-nome").html(data.dataset.name);
    $("#itempegar-nome").attr('data-itemid', data.dataset.item);
    $("#itempegar-img").attr('src', data.dataset.linkinventario + "/" + data.dataset.index + `.png`);
    $.post("https://Night_AdminV2/enviarItem", JSON.stringify({
        item: data.dataset.item,
    }), (data) => {
        $(".format").fadeIn(500);
        $(".pegar-item").fadeIn(500);
    });
}

function closePegarItem(){
	$(".format").fadeOut(500);
	$(".pegar-item").fadeOut(500);
}

function PegarItemConfirmar(){
    let $el = $('.criar-teleport:hover');
    let quantidade = $("#quantidadepegar").val();
    let idjogador = $("#idjogador").val();
    let item = $("#itempegar-nome").attr('data-itemid');

    if($el.length) {
        $.post("http://Night_AdminV2/pegarItemConfirm", JSON.stringify({
            quantidade: quantidade,
            idjogador: idjogador,
            item: item
        }), (data) =>{ 
            if(data.retorno == 'done') {
                closePegarItem();
                LimparInputs();
                Reload();
            } 
        });
    }
};

// ---------------------------------------
// -- Lista de Logs Anuncios
// ---------------------------------------
// function AnunciosLogs(){
//     $.post("http://Night_AdminV2/AnunciosLogs", JSON.stringify({}), (data) => {
//         let anunciosLogs = data.anunciosLogs.sort((a,b) => (a.id > b.id) ? 1 : -1);
//         $('.box-anuncios-list').empty();

//         anunciosLogs.forEach((key) => {
//             let extraInfo = "";

//             if(key.modo === "Todos") {
//                 extraInfo = "Todos";
//             } else if(key.modo === "Individual") {
//                 extraInfo = `Individual | ID: ${key.destinatario}`;
//             } else if(key.modo === "Permissao") {
//                 extraInfo = `Permissão | Organização: ${key.organizacao}`;
//             }

//             $('.box-anuncios-list').prepend(`
//                 <div class="item-anuncio">
//                     <div class="title-anuncio">
//                         Anúncio ${key.admin} #${key.id} | ${extraInfo} | ${key.data}
//                     </div>
//                     <div class="desc-anuncio">${key.mensagem}</div>
//                 </div>
//             `);
//         });
//     });
// }
// ---------------------------------------
// -- Lista de Punicoes
// ---------------------------------------

function GaragemLista(){
    $.post("http://Night_AdminV2/garagemLista",JSON.stringify({}),(data) => {
		let garagem = data.garagem.sort((a,b) => (b.name > a.name) ? 1: -1);
		$('.garagem-overflow').empty()

		garagem.forEach((key,value) => {
			$('.garagem-overflow').prepend(`
				<div class="item-garagem" onclick="FormatConfirmGaragem(this)" data-name="${key.name}" data-index="${key.carro}" data-linkgaragem="${key.linkgaragem}">
				<div class="nome-garagem">${key.name}</div>
					<img id="img-2" src="${key.linkgaragem}/${key.carro}.png" alt="" onerror="this.onerror=null;this.src='./images/secretcar.png'">
					<div class="quantidade-garagem" style="color: transparent;">1x</div>
					<div class="barra1"></div>
				</div>
			`)
		});
    });
}

// ---------------------------------------
// -- Lista de Veiculos (ADD / SPAWN)
// ---------------------------------------
let modoVeiculoSelecionado = "";
let VehicleCatchName = "";

function closePegarCarro() {
    $(".format").fadeOut(500);
    $(".veiculo-adicionar").fadeOut(500);
    $(".pegar-carro").fadeOut(500);
}

function SelecionarModoVeiculo(pagina) {
    $(".pegar-carro").fadeOut(300);
    modoVeiculoSelecionado = pagina;

    if (pagina == "Spawnar") {
        SairPainel();
        $.post("http://Night_AdminV2/pegarCarroConfirmar", JSON.stringify({
            passaporte: "",
            modo: "Spawnar"
        }), (data) => { 

        });
        return;
    }

    if (pagina == "Adicionar") {
        $(".veiculo-adicionar").fadeIn(300);
    }
}

function FormatConfirmGaragem(data) {
    $("#carropegar-nome").html(data.dataset.name);
    $("#carropegar-img").attr('src', data.dataset.linkgaragem + "/" + data.dataset.index + ".png");

    $.post("https://Night_AdminV2/enviarCarro", JSON.stringify({
        carro: data.dataset.index
    }), (resp) => {
        VehicleCatchName = data.dataset.index;
        $("#veiculoNomeAdicionar").text(data.dataset.name);

        $(".format").fadeIn(500);
        $(".pegar-carro").fadeIn(500);
    });
}

function PegarGaragemConfirmar() {
    let passaporte = $("#passaporteGaragem").val();

    $.post("http://Night_AdminV2/pegarCarroConfirmar", JSON.stringify({
        passaporte: passaporte,
        modo: modoVeiculoSelecionado
    }), (data) => { 
        if (data.retorno == 'done') {
            closePegarCarro();
            if (modoVeiculoSelecionado == "Adicionar") {
                LimparInputs();
                Reload();
            }
        }
    });
}
// ---------------------------------------
// -- Lista de Punicoes
// ---------------------------------------
function ScriarAnuncio() {
    $(".format").fadeIn(500);
    $(".fazer-anuncio").fadeIn(500);
}

function closeAnuncios() {
    $(".format").fadeOut(500);
	$(".anuncio-todos").fadeOut(500);
    $(".format").fadeOut(500);
	$(".anuncio-individual").fadeOut(500);
    $(".format").fadeOut(500);
	$(".anuncio-organizacao").fadeOut(500);
	$(".format").fadeOut(500);
}

function SelecionarModoAnuncio(pagina){
    $(".fazer-anuncio").fadeOut(300);

    if(pagina == "Todos") {
        $(".anuncio-todos").fadeIn(300);
    }

    if(pagina == "Individual") {
        $(".anuncio-individual").fadeIn(300);
    }

    if(pagina == "Permissao") {
        $(".anuncio-organizacao").fadeIn(300);
    }
}

function FazerAnuncioTodos() {
    let texto = $("#anuncio-global-input").val();
    if(!texto) return alert("Digite a mensagem do anúncio global!");

    $.post("http://Night_AdminV2/fazeranuncioall", JSON.stringify({
        modo: "Todos",
        textoAnuncio: texto
    }), (data) => {
        if(data.retorno == 'done') {
            closeAnuncios();
            LimparInputs();
            AnunciosLogs();
        }
    });
}

function FazerAnuncioIndividual() {
    let id = $("#anuncio-id-input").val();
    let texto = $("#anuncio-individual-input").val();
    if(!id || !texto) return alert("Informe o ID do jogador e a mensagem!");

    $.post("http://Night_AdminV2/fazeranuncioall", JSON.stringify({
        modo: "Individual",
        extra: id,
        textoAnuncio: texto
    }), (data) => {
        if(data.retorno == 'done') {
            closeAnuncios();
            LimparInputs();
            AnunciosLogs();
        }
    });
}

function FazerAnuncioOrganizacao() {
    let org = $("#anuncio-organizacao-nome").val();
    let texto = $("#anuncio-organizacao-input").val();
    if(!org || !texto) return alert("Informe a organização e a mensagem!");

    $.post("http://Night_AdminV2/fazeranuncioall", JSON.stringify({
        modo: "Permissao",
        extra: org,
        textoAnuncio: texto
    }), (data) => {
        if(data.retorno == 'done') {
            closeAnuncios();
            LimparInputs();
            AnunciosLogs();
        }
    });
}

function AnunciosLogs(){
    $.post("http://Night_AdminV2/AnunciosLogs", JSON.stringify({}), (data) => {
        let anunciosLogs = data.anunciosLogs.sort((a,b) => a.id - b.id);
        $('.box-anuncios-list').empty();

        anunciosLogs.forEach((key) => {
            let extraInfo = "";

            if(key.modo === "Todos") {
                extraInfo = "Todos";
            } else if(key.modo === "Individual") {
                extraInfo = `Individual | ID: ${key.destinatario}`;
            } else if(key.modo === "Permissao") {
                extraInfo = `Organização: ${key.organizacao}`;
            }

            $('.box-anuncios-list').prepend(`
                <div class="item-anuncio">
                    <div class="title-anuncio">
                        Anúncio ${key.admin} #${key.id} | ${extraInfo} | ${key.data}
                    </div>
                    <div class="desc-anuncio">${key.mensagem}</div>
                </div>
            `);
        });
    });
}
// ---------------------------------------
// -- Editar Usuario
// ---------------------------------------

function editarIdentidade(tipo){

	if(tipo == "trocar-nome"){
		$(".trocar-nome").show(0);
	}

	if(tipo == "trocar-carteira"){
		$(".trocar-carteira").show(0);
	}

	if(tipo == "trocar-banco"){
		$(".trocar-banco").show(0);
	}

	if(tipo == "trocar-coins"){
		$(".trocar-coins").show(0);
	}

	if(tipo == "trocar-celular"){
		$(".trocar-celular").show(0);
	}

	if(tipo == "trocar-registro"){
		$(".trocar-registro").show(0);
	}

	if(tipo == "listaskins"){
		$(".lista-skin").show(0);
	}

	if(tipo == "enviarmensagem"){
		$(".enviar-mensagem").show(0);
	}

	$(".format").fadeIn(700);
}

function closeTrocar(tipo){
    $(".format").fadeOut(500);

	if(tipo == "nome"){
		$(".trocar-nome").fadeOut(500);
	}

	if(tipo == "carteira"){
		$(".trocar-carteira").fadeOut(500);
	}

	if(tipo == "banco"){
		$(".trocar-banco").fadeOut(500);
	}

	if(tipo == "coins"){
		$(".trocar-coins").fadeOut(500);
	}

	if(tipo == "celular"){
		$(".trocar-celular").fadeOut(500);
	}

	if(tipo == "registro"){
		$(".trocar-registro").fadeOut(500);
	}

	if(tipo == "screenshot"){
		$(".ver-screenshot").fadeOut(500);
		$(".img-screenshot").attr(`src`,"nui://Night_AdminV2/web-side/images/loading.gif");
	}

	if(tipo == "enviarmensagem"){
		$(".enviar-mensagem").fadeOut(500);
	}

	if(tipo == "listaskins"){
		$(".lista-skin").fadeOut(500);
	}

}

function TrocarNome(){
	let $el = $('.criar-teleport:hover');
	let PrimeiroNome = $("#nome-novo").val();
	let SegundoNome = $("#nome-novo2").val();
	if($el.length) {
		$.post("http://Night_AdminV2/trocarnome",JSON.stringify({
			PrimeiroNome:PrimeiroNome,
			SegundoNome:SegundoNome
		}), (data) =>{ 
			if(data.retorno == 'done') {
				$(".format").fadeOut(500);
				$(".trocar-nome").hide(0);
				$("#nome-jogador").html(data.nome + " " + data.sobrenome);
				SetNomes(data.nome2,data.sobrenome2)
				LimparInputs()
				Reload()
			} 
		});
	}
};

$(document).on('click','.trocar-carteira .select-carteira',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	if (isActive) return;
	$('.trocar-carteira .select-carteira').removeClass('active');
    if(!isActive) $el.addClass('active');
});

function TrocarCarteira(){
	let $el = $('.trocar-carteira .select-carteira.active');
	let valor = $("#carteira-novo").val();
	if($el.length) {
		$.post("http://Night_AdminV2/trocarcarteira",JSON.stringify({
			valor:valor,
			tipo: $el.attr('data-tipo')
		}), (data) =>{ 
			if(data.retorno == 'done') {
				$(".format").fadeOut(500);
				$(".trocar-carteira").hide(0);
				$("#carteira-jogador").html(data.carteira + " $");
				$('.trocar-carteira .select-carteira').removeClass('active');
				LimparInputs()
				Reload()
			} 
		});
	}
};

$(document).on('click','.trocar-banco .select-carteira',function(){
	let $el = $(this);
	let isActive = $el.hasClass('active');
	if (isActive) return;
	$('.trocar-banco .select-carteira').removeClass('active');
    if(!isActive) $el.addClass('active');
});

function TrocarBanco(){
	let $el = $('.trocar-banco .select-carteira.active');
	let valor = $("#banco-novo").val();
	if($el.length) {
		$.post("http://Night_AdminV2/trocarbanco",JSON.stringify({
			valor:valor,
			tipo: $el.attr('data-tipo')
		}), (data) =>{ 
			if(data.retorno == 'done') {
				$(".format").fadeOut(500);
				$(".trocar-banco").hide(0);
				$("#banco-jogador").html(data.banco + " $");
				$('.trocar-banco .select-carteira').removeClass('active');
				LimparInputs()
				Reload()
			} 
		});
	}
};

$(document).on('click','.trocar-coins .select-carteira',function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    if (isActive) return;
    $('.trocar-coins .select-carteira').removeClass('active');
    if(!isActive) $el.addClass('active');
});

function TrocarCoins(){
    let $el = $('.trocar-coins .select-carteira.active');
    let valor = $("#coins-novo").val();
    if($el.length) {
        $.post("http://Night_AdminV2/trocarcoins", JSON.stringify({
            valor: valor,
            tipo: $el.attr('data-tipo')
        }), function(data) { 
            if(data.retorno == 'done') {
                $(".format").fadeOut(500);
                $(".trocar-coins").hide(0);
                $("#coins-jogador").html(data.coins + " $");
                $('.trocar-coins .select-carteira').removeClass('active');
                LimparInputs();
                Reload();
            } 
        });
    }
};

function TrocarCelular(){
	let $el = $('.criar-teleport:hover');
	let celularnovo = $("#celular-novo").val();
	if($el.length) {
		$.post("http://Night_AdminV2/trocarcelular",JSON.stringify({
			celularnovo:celularnovo,
		}), (data) =>{ 
			if(data.retorno == 'done') {
				$(".format").fadeOut(500);
				$(".trocar-celular").hide(0);
				$("#celular-jogador").html(data.celular);
				LimparInputs()
				Reload()
			} 
		});
	}
};

function TrocarRegistro(){
	let $el = $('.criar-teleport:hover');
	let registronovo = $("#registro-novo").val();
	if($el.length) {
		$.post("http://Night_AdminV2/trocarregistro",JSON.stringify({
			registronovo:registronovo,
		}), (data) =>{ 
			if(data.retorno == 'done') {
				$(".format").fadeOut(500);
				$(".trocar-registro").hide(0);
				$("#registro-jogador").html(data.registro);
				LimparInputs()
				Reload()
			} 
		});
	}
};

// ---------------------------------------
// -- SISTEMA
// ---------------------------------------

function Reload(){
	listTeleport()
	listLogs()
	listaControle()
	PunicoesLista()
	ItensLista()
	GaragemLista()
	AnunciosLogs()
	ListaSkins()
	ListaBausfac()
	verGrousList()
}

function CloseAll(){
	$(".format").hide();
	$(".aplicar-punicao").hide();
	$(".fazer-anuncio").hide();
	$(".adicionar-tp-resquest").hide();
	$(".ver-inventario").hide();
	$(".ver-garagem").hide();
	$(".aplicar-punicao").hide();
	$(".aplicar-adv").hide();
	$(".veiculo-adicionar").hide();
	$(".anuncio-todos").hide();
	$(".anuncio-individual").hide();
	$(".anuncio-organizacao").hide();
	$(".aplicar-kick").hide();
	$(".aplicar-ban").hide();
	$(".fazer-anuncio").hide();
	$(".fazer-anuncio").hide();
	$(".criar-aviso").hide();
	$(".configuracao-usuario").hide();;
	$(".ver-motivo-punicao").hide();
	$(".pegar-item").hide();
	$(".pegar-carro").hide();
	$(".fazer-anuncio").hide();
	$(".pegar-carro").hide();
	// $(".ver-baucasas").hide();
	$(".ver-casas").hide();
	$(".ver-addempregos").hide();
	$(".ver-empregos").hide();
	$("#pagina-controle").hide();
	$("#pagina-punicoes").hide();
	$("#pagina-pegarItens").hide();
	$("#pagina-SetCarros").hide();
	$("#pagina-Anuncios").hide();
	$("#pagina-VerPerfil").hide();
	$(".setarID").hide();
	$(".trocar-nome").hide();
	$(".trocar-celular").hide();
	$(".trocar-registro").hide();
	$(".trocar-carteira").hide();
	$(".trocar-banco").hide();
	$(".trocar-coins").hide();
	$(".ver-baufac").hide();
	$("#pagina-Baus").hide();
	$("#pagina-gerenciar").hide();
	$(".ver-groups").hide();
}

function LimparInputs(){
	$("#passaporteGaragem").val('');
	$("#anuncioText").val('');
	$("#nome-teleport-create").val('');
	$('#motivo-punicao').val('');
	$("#motivo-kick").val('');
	$("#motivo-advertencia").val('');
	$("#aviso-input").val('');
	$("#idjogador").val('');
	$("#quantidadepegar").val('');
	$("#inf-punicao1").val('');
	$("#inf-punicao2").val('');
	$("#inf-punicao3").val('');
	$("#inf-punicao4").val('');
	$("#anuncioText").val('');
	$("#nome-novo").val('');
	$("#nome-novo2").val('');
	$("#emprego-novo").val('');
	$("#vip-novo").val('');
	$("#celular-novo").val('');
	$("#registro-novo").val('');
	$("#carteira-novo").val('');
	$("#banco-novo").val('');
	$("#carteira-novo").val('');
	$("#idDiscord").val('');
	$("#celular-novo").val('');
	$("#registro-novo").val('');
	$("#banco-novo").val('');
	$("#carteira-novo").val('');
	$("#nome-novo").val('');
	$("#nome-novo2").val('');
	$(".searchgaragem").val('');
	$(".searchitens").val('');
	$(".searchplayers").val('');
	$(".searchgerenciar").val('');
	$(".searchskins").val('');
	$(".searchbausfac").val('');
	$(".searchgerenciar").val('');
	$("#mensagemenviada").val('');
	// Anúncios
	$("#anuncio-global-input").val("");
    $("#anuncio-id-input").val("");
    $("#anuncio-individual-input").val("");
    $("#anuncio-organizacao-nome").val("");
    $("#anuncio-organizacao-input").val("");
	// Veiculos
	$("#spawnar-veiculo-input").val("");
    $("#adicionar-veiculo-input").val("");
    $("#passaporteGaragem").val("");
}

function closeFormat(){
	$(".format").fadeOut(500);
	$(".aplicar-punicao").fadeOut(500);
	$(".aplicar-adv").fadeOut(500);
	$(".aplicar-kick").fadeOut(500);
	$(".aplicar-ban").fadeOut(500);
	$(".veiculo-adicionar").fadeOut(500);
	$(".anuncio-todos").fadeOut(500);
	$(".anuncio-individual").fadeOut(500);
	$(".anuncio-organizacao").fadeOut(500);
	$(".fazer-anuncio").fadeOut(500);
	$(".adicionar-tp-resquest").fadeOut(500);
	$(".ver-inventario").fadeOut(500);
	$(".ver-garagem").fadeOut(500);
	$(".ver-casas").fadeOut(500);
	$(".aplicar-punicao").fadeOut(500);
	$(".criar-aviso").fadeOut(500);
	$(".configuracao-usuario").fadeOut(500);
	$(".ver-motivo-punicao").fadeOut(500);
	$(".pegar-item").fadeOut(500);
	$(".pegar-carro").fadeOut(500);
	$(".fazer-anuncio").fadeOut(500);
}

function Sfechar(){
	$("#pagina-inicio").fadeOut(300);
	$("#pagina-controle").fadeOut(300);
	$("#pagina-punicoes").fadeOut(300);
	$("#pagina-pegarItens").fadeOut(300);
	$("#pagina-SetCarros").fadeOut(300);
	$("#pagina-Anuncios").fadeOut(300);
	$("#pagina-VerPerfil").fadeOut(300);
	$("#pagina-Baus").fadeOut(300);
	$("#pagina-gerenciar").fadeOut(300);
}

function SetNomes(primeiro,segundo){
	$("#name1").html(primeiro + " " + segundo);
	$("#name2").html(primeiro + " " + segundo);
	$("#name2").html(primeiro + " " + segundo);
	$("#name3").html(primeiro + " " + segundo);
	$("#name4").html(primeiro + " " + segundo);
	$("#name5").html(primeiro + " " + segundo);
	$("#name6").html(primeiro + " " + segundo);
	$("#name7").html(primeiro + " " + segundo);
	$("#name8").html(primeiro + " " + segundo);
	$("#name9").html(primeiro + " " + segundo);
	$("#name10").html(primeiro + " " + segundo);
	$("#name11").html(primeiro + " " + segundo);
	$("#name12").html(primeiro + " " + segundo);
	$("#name13").html(primeiro + " " + segundo);
	$("#name14").html(primeiro + " " + segundo);
	$("#name15").html(primeiro + " " + segundo);
	$("#name16").html(primeiro + " " + segundo);
	$("#name17").html(primeiro + " " + segundo);
	$("#name18").html(primeiro + " " + segundo);
	$("#name19").html(primeiro + " " + segundo);
	$("#name20").html(primeiro + " " + segundo);
	$("#name21").html(primeiro + " " + segundo);
	$("#name22").html(primeiro + " " + segundo);
	$("#name23").html(primeiro + " " + segundo);
	$("#name24").html(primeiro + " " + segundo);
	$("#name25").html(primeiro + " " + segundo);
	$("#name26").html(primeiro + " " + segundo);
	$("#name27").html(primeiro + " " + segundo);
	$("#name28").html(primeiro + " " + segundo);
	$("#name29").html(primeiro + " " + segundo);
	$("#name30").html(primeiro + " " + segundo);
	$("#name31").html(primeiro + " " + segundo);
	$("#name32").html(primeiro + " " + segundo);
	$("#name33").html(primeiro + " " + segundo);
	$("#name34").html(primeiro + " " + segundo);
	$("#name35").html(primeiro + " " + segundo);
}

function pagina(pagina){

	Sfechar()

	if(pagina == "inicio") {
		$("#pagina-inicio").fadeIn(700);
	}

	if(pagina == "players") {
		$("#pagina-controle").fadeIn(700);
	}

	if(pagina == "punicoes") {
		$("#pagina-punicoes").fadeIn(700);
	}

	if(pagina == "itens") {
		$("#pagina-pegarItens").fadeIn(700);
	}

	if(pagina == "carros") {
		$("#pagina-SetCarros").fadeIn(700);
	}

	if(pagina == "baufac") {
		$("#pagina-Baus").fadeIn(700);
	}

	if(pagina == "gerenciar") {
		$("#pagina-gerenciar").fadeIn(700);
	}

	if(pagina == "anuncios") {
		$("#pagina-Anuncios").fadeIn(700);
	}

}

// --------------------------------
// -- [ SISTEMA VER INVENTARIO ] --
// --------------------------------

function VerInventario(verify){
    $.post("http://Night_AdminV2/PegarInv",JSON.stringify({}),(data) => {
        let inventario = data.inventario;

        $('.inventario-box').empty();
        $('.ver-inventario').show(0);
        $('.format').fadeIn(700);

        // Atualiza nome sempre, mesmo se inventário vazio
        $("#player-sendo-verificado").html(data.nome + "[" + data.user_id + "]");

        if (inventario && inventario.length > 0) {
            inventario.forEach((key) => {
                const maxDurability = 86400 * key.days;
                const newDurability = (maxDurability - key.durability) / maxDurability;
                var actualPercent = newDurability * 100;

                if (actualPercent <= 1)
                    actualPercent = 1;

                $('.inventario-box').prepend(`
                    <div class="item-inventario">
                        <div class="nome-inventario">${key.name}</div>
                        <img src="${key.linkinventario}/${key.index}.png" alt="">
                        <div class="quantidade-item">${key.amount}x</div>
                        <div class="remove-inventario" onclick="removerItem(this)" data-item="${key.item}" data-quantidade="${key.amount}"><i class="fas fa-trash-alt"></i></div>
                        <div class="barra1" style="background: ${actualPercent == 1 ? "#fc5858":colorPicker2(actualPercent)};">
                            <div class="barra2" style="width: ${actualPercent == 1 ? "100":actualPercent}%; background: ${actualPercent == 1 ? "#fc5858":colorPicker(actualPercent)};"></div>
                        </div>
                    </div>
                `);
            });
        } else {
            $('.inventario-box').html(`<div class="nenhum-item">Nenhum item encontrado</div>`);
        }
    });
}

function removerItem(data){
	$.post("http://Night_AdminV2/removerItem",JSON.stringify({
		item : data.dataset.item,
		quantidade : data.dataset.quantidade
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			VerInventario('reload')
		} 
	});
};

// --------------------------------
// -- [ SISTEMA VER GARAGEM ] --
// --------------------------------

function VerGaragem(verify){
    $.post("http://Night_AdminV2/PegarGaragem", JSON.stringify({}), (data) => {
        let garagem = data.garagem;

        // Sempre mostra a NUI
        $('.ver-garagem').show(0);
        $('.format').fadeIn(700);

        // Atualiza nome independente de ter veículos
        $("#player-sendo-verificado2").html(data.nome + "[" + data.user_id + "]");

        $('.garagem-box').empty();

        if (garagem && garagem.length > 0) {
            garagem.forEach((key) => {
                $('.garagem-box').prepend(`
                    <div class="item-garagem">
                        <div class="nome-garagem">${key.name}</div>
                        <img src="${key.linkgaragem}/${key.index}.png" alt="">
                        <div class="remove-casas" onclick="removerCarro(this)" data-item="${key.index}"><i class="fas fa-trash-alt"></i></div>
                        <div class="bau-casas" onclick="verBauCarro(this)" data-carro="${key.index}"><i class="fas fa-treasure-chest"></i></div>
                        <div class="barra1"></div>
                    </div>
                `);
            });
        } else {
            $('.garagem-box').html(`<div class="nenhum-veiculo">Nenhum veículo encontrado</div>`);
        }
    });
}

function removerCarro(data){
	$.post("http://Night_AdminV2/removerCarro",JSON.stringify({
		item : data.dataset.item,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			VerGaragem('reload')
		} 
	});
};

function verBauCarro(data){
	$.post("http://Night_AdminV2/verBauCarro",JSON.stringify({
		carro : data.dataset.carro,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			$('.ver-garagem').hide(0)
			verBauCarroList()
		} 
	});
};

function verBauCarroList(verify){
    $.post("http://Night_AdminV2/verBauCarroList", JSON.stringify({}), (data) => {
        let carroBau = data.carroBau;

        // Mostrar NUI sempre que a função for chamada (você pode ajustar o controle do show/hide conforme quiser)
        $('.ver-baucarro').show(0);
        $('.format').fadeIn(700);

        // Atualiza nome e ID antes do loop, mesmo que o array esteja vazio
        $("#player-sendo-verificado3").html(data.nome + "[" + data.user_id + "]");

        $('.baucarro-box').empty();

        if (carroBau && carroBau.length > 0) {
            carroBau.forEach((key) => {
                const maxDurability = 86400 * key.days;
                const newDurability = (maxDurability - key.durability) / maxDurability;
                var actualPercent = newDurability * 100;

                if (actualPercent <= 1)
                    actualPercent = 1;

                $('.baucarro-box').prepend(`
                    <div class="item-baucarro">
                        <div class="nome-baucarro">${key.name}</div>
                        <img src="${key.linkinventario}/${key.index}.png" alt="">
                        <div class="quantidade-item">${key.amount}x</div>
                        <div class="remove-baucarro" onclick="removerItemBauCarro(this)" data-item="${key.item}" data-quantidade="${key.amount}" data-slot="${key.slot}"><i class="fas fa-trash-alt"></i></div>
                        <div class="barra1" style="background: ${actualPercent == 1 ? "#fc5858" : colorPicker2(actualPercent)};">
                            <div class="barra2" style="width: ${actualPercent == 1 ? "100" : actualPercent}%; background: ${actualPercent == 1 ? "#fc5858" : colorPicker(actualPercent)};"></div>
                        </div>
                    </div>
                `);
            });
        } else {
            $('.baucarro-box').html(`<div class="nenhum-item">Nenhum item encontrado no baú</div>`);
        }
    });
}

function removerItemBauCarro(data){
	$.post("http://Night_AdminV2/removerItemBauCarro",JSON.stringify({
		item : data.dataset.item,
		quantidade : data.dataset.quantidade,
		slot : data.dataset.slot,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verBauCarroList('reload')
		} 
	});
};

function closeViewBauCarro(){
	$(".format").fadeOut(500);
	$(".ver-garagem").hide(0);
	$(".ver-baucarro").fadeOut(500);
}

// --------------------------------
// -- [ SISTEMA VER CASAS  ] --
// --------------------------------
function VerCasas(verify){
    $.post("http://Night_AdminV2/PegarCasas",JSON.stringify({}),(data) => {
        let casas = data.casas

        if(verify =~ 'reload'){
            $('.ver-casas').show(0)
            $('.format').fadeIn(700)
        }

        $('.casas-box').empty()
        casas.forEach((key) => {
            $("#player-sendo-verificado4").html(key.nome + " [" + key.user_id + "]");

            if(key.home){ // só cria box se tiver casa
                $('.casas-box').prepend(`
                    <div class="item-casas">
                        <div class="nome-casas">${key.home}</div>
                        <img src="nui://Night_AdminV2/web-side/images/house.png" alt="">
                        <div class="remove-casas" onclick="removerCasa(this)" data-casa="${key.home}"><i class="fas fa-trash-alt"></i></div>
                        <div class="bau-casas" onclick="verBauCasa(this)" data-casa="${key.home}"><i class="fas fa-treasure-chest"></i></div>
                        <div class="barra1"></div>
                    </div>
                `);
            }
        });
    });
}



function removerCasa(data){
	$.post("http://Night_AdminV2/removerCasa",JSON.stringify({
		casa : data.dataset.casa,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			VerCasas('reload')
		} 
	});
};

function verBauCasa(data){
	$.post("http://Night_AdminV2/verBauCasa", JSON.stringify({
		casa: data.dataset.casa
	}), (resp) => { 
		if (resp.retorno === 'done') {
			LimparInputs();
			Reload();
			$('.ver-casas').hide(0);
			verBauCasaList('reload'); // <<< importante
		}
	});
};

function verBauCasaList(verify){
	$.post("http://Night_AdminV2/verBauCasaList", JSON.stringify({}), (data) => {
		const casasBau = data.casasBau;

		$('.ver-baucasas').show(0);
		$('.format').fadeIn(700);

		$('.baucasas-box').empty();

        $("#player-sendo-verificado5").html(data.nome + "[" + data.user_id + "]");

		$('.baucasas-box').empty();

		if (casasBau && casasBau.length > 0) {
            casasBau.forEach((key) => {
                const maxDurability = 86400 * key.days;
                const newDurability = (maxDurability - key.durability) / maxDurability;
                var actualPercent = newDurability * 100;

                if (actualPercent <= 1)
                    actualPercent = 1;

                $('.baucasas-box').prepend(`
                    <div class="item-baucasas">
                        <div class="nome-baucasas">${key.name}</div>
                        <img src="${key.linkinventario}/${key.index}.png" alt="">
                        <div class="quantidade-item">${key.amount}x</div>
                        <div class="remove-baucasas" onclick="removerItemBauCasa(this)" data-item="${key.item}" data-quantidade="${key.amount}" data-slot="${key.slot}"><i class="fas fa-trash-alt"></i></div>
                        <div class="barra1" style="background: ${actualPercent == 1 ? "#fc5858" : colorPicker2(actualPercent)};">
                            <div class="barra2" style="width: ${actualPercent == 1 ? "100" : actualPercent}%; background: ${actualPercent == 1 ? "#fc5858" : colorPicker(actualPercent)};"></div>
                        </div>
                    </div>
                `);
            });
        } else {
            $('.baucasa-box').html(`<div class="nenhum-item">Nenhum item encontrado no baú</div>`);
        }
	});
}

function removerItemBauCasa(data){
	$.post("http://Night_AdminV2/removerItemBauCasa",JSON.stringify({
		item : data.dataset.item,
		quantidade : data.dataset.quantidade,
		slot : data.dataset.slot,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verBauCasaList('reload')
		} 
	});
};

function closeViewCasa(){
	$(".format").fadeOut(500);
	$(".ver-casas").fadeOut(500);
}

function closeViewBauCasa(){
	$(".format").fadeOut(500);
	$(".ver-casas").hide(0);
	$(".ver-baucasas").fadeOut(500);
}

function closeViewGroups(){
	$(".format").fadeOut(500);
	$(".ver-groups").hide(0);
}

function closeViewBauFac(){
	$(".format").fadeOut(500);
	$(".ver-casas").hide(0);
	$(".ver-baufac").fadeOut(500);
}

// --------------------------------
// -- [ SISTEMA VER EMPREGOS  ] --
// --------------------------------
function VerEmpregos(verify){
    $.post("http://Night_AdminV2/PegarEmpregos",JSON.stringify({}),(data) => {
		let empregos = data.empregos

		if(verify =~ 'reload') {
			$('.ver-empregos').show(0)
			$('.format').fadeIn(700)
		}

		$('.empregos-box').empty()
		empregos.forEach((key) => {
			$("#player-sendo-verificado6").html(key.nome + " [" + key.user_id + "]");

			if(key.emprego){
				$('.empregos-box').prepend(`
					<div class="item-empregos">
						<div class="nome-empregos">${key.empregotitle}</div>
						<div class="remove-empregos" onclick="removerCargo(this)" data-emprego="${key.emprego}"><i class="fas fa-user-times"></i></div>
						<div class="barra1"></div>
					</div>
				`);
			}
		});
    });
}

function opendiscordid(){
	$(".setarID").show(0);
    $(".format").fadeIn(700);
}

function closediscordid(){
    $(".format").fadeOut(500);
	$(".setarID").fadeOut(500);
}

function closediscordid2(){
    $(".format").fadeOut(500);
	$(".setarID2").fadeOut(500);
}

function removerCargo(data){
	$.post("http://Night_AdminV2/removerCargo",JSON.stringify({
		emprego : data.dataset.emprego,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			VerEmpregos('reload')
		} 
	});
};

function addemprego(data){
    $.post("http://Night_AdminV2/addEmprego",JSON.stringify({}),(data) => {
        let addemprego = data.listEmprego

        $('.ver-empregos').hide(0)

        if(verify =~ 'reload'){
            $('.ver-addempregos').show(0)
            $('.format').fadeIn(700)
        }

        $('.addempregos-box').empty()
        addemprego.forEach((key) => {
            $("#player-sendo-verificado7").html(key.nome + " [" + key.user_id + "]");

            if(key.emprego){
                $('.addempregos-box').prepend(`
                    <div class="item-addempregos">
                        <div class="nome-addempregos">${key.empregotitle}</div>
                        <div class="remove-addempregos" onclick="confirmarCargo(this)" data-emprego="${key.emprego}"><i class="fas fa-user-check"></i></div>
                        <div class="barra1"></div>
                    </div>
                `);
            }
        });
    });
}

function confirmarCargo(data){
	$.post("http://Night_AdminV2/confirmaremprego",JSON.stringify({
		emprego : data.dataset.emprego
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			$('.ver-addempregos').hide()
			VerEmpregos()
		} 
	});
};

function closeViewEmpregos(){
	$(".format").fadeOut(500);
	$(".ver-empregos").hide(0);
}

function closeViewaddEmpregos(){
	$(".format").fadeOut(500);
	$(".ver-addempregos").hide(0);
}

// --------------------------------
// -- [ OPCOES RAPIDAS ] --
// --------------------------------

function opcoesRapidas(tipo){
	$.post("http://Night_AdminV2/opcoesRapidas",JSON.stringify({
		tipo : tipo,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
		} 
	});
}

function screenshot(){
	$(".ver-screenshot").show(0);
	$(".format").fadeIn(700);
	$.post("http://Night_AdminV2/screenshot",JSON.stringify({
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			$(".img-screenshot").attr(`src`,data.imagem);
		} 
	});
}


function EnviarMensagem(tipo){
	let mensagem = $("#mensagemenviada").val();
	$.post("http://Night_AdminV2/enviarMensagem",JSON.stringify({
		mensagem : mensagem,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			$(".format").fadeOut(500);
			$(".enviar-mensagem").hide(0);
		} 
	});
}


// ---------------------------------------
// -- Lista de Skins
// ---------------------------------------

function ListaSkins(){
    $.post("http://Night_AdminV2/skinsLista",JSON.stringify({}),(data) => {
	
		let skins = data.skins.sort((a,b) => (b.sexo > a.sexo) ? 1: -1);
		$('.overflowskins').empty()
		skins.forEach((key,value) => {
			
			$('.overflowskins').prepend(`

				<div class="item-overflowskins" onclick="setarSkin(this)" data-set="${key.set}">
					<div class="nome-skin detalhes">${key.nome}</div>
					<div class="set-skin">${key.set}</div>
					<img class="img-skin" src="${key.linkskins}/${key.set}.png" alt="">
				</div>

			`)
			
		});
    });
}

function setarSkin(data){
	$.post("http://Night_AdminV2/setarSkin",JSON.stringify({
		set : data.dataset.set,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			$(".format").fadeOut(500);
			$(".lista-skin").hide(0);
		} 
	});
}

// ---------------------------------------
// -- Lista de Bau Fac
// ---------------------------------------

function ListaBausfac(){
    $.post("http://Night_AdminV2/bausfacLista",JSON.stringify({}),(data) => {
		let bausfac = data.bausfac.sort((a,b) => (b.bau > a.bau) ? 1: -1);
		$('.box-baus').empty()
		bausfac.forEach((key,value) => {
			
			$('.box-baus').prepend(`

				<div class="item-baus">
					<div class="item-header" style="width: 38%;"><i class="fas fa-treasure-chest" style="margin-right: 10px;color: ${key.color}text-shadow: 0px 0px 30px ${key.color};"></i>Bau ${key.bau}</div>

					<div class="item-header3">
						<div class="status" style="color: ${key.color} background: ${key.background}">${key.tipo}</div>
					</div>

					<div class="item-header4">
						<i class="far fa-eye iconheader" onclick="verBauFac(this)" data-bau="${key.bau}" style="margin-left: 44%;"></i>
					</div>

				</div>

			`)
			
		});
    });
}

function verBauFac(data){
	$.post("http://Night_AdminV2/RegisterBauFac",JSON.stringify({
		bau : data.dataset.bau,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verBauFacList()
		} 
	});
};

function verBauFacList(verify){
    $.post("http://Night_AdminV2/verbausfacLista",JSON.stringify({}),(data) => {
		let verbausfac = data.verbausfac

		if(verify =~ 'reload') {
			$('.ver-baufac').show(0)
			$('.format').fadeIn(700)
		}

		$('.baufac-box').empty()
		verbausfac.forEach((key,value) => {
			$("#name100").html(key.nome + " [" + key.user_id + "]");
			
			$('.baufac-box').prepend(`

				<div class="item-baufac">
					<div class="nome-baufac">${key.name}</div>
					<img src="${key.linkinventario}/${key.index}.png" alt="">
					<div class="quantidade-item">${key.amount}x</div>
					<div class="remove-baufac" onclick="removerItemBauFac(this)" data-item="${key.item}" data-quantidade="${key.amount}" data-slot="${key.slot}"><i class="fas fa-trash-alt"></i></div>
					<div class="barra1"></div>
				</div>
			
			`)
		});
    });
}

function removerItemBauFac(data){
	$.post("http://Night_AdminV2/removerItemBauFac",JSON.stringify({
		item : data.dataset.item,
		quantidade : data.dataset.quantidade,
		slot : data.dataset.slot
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verBauFacList('reload')
		} 
	});
};

// ---------------------------------------
// -- Lista de Groups
// ---------------------------------------

function verGrousList(verify){
    $.post("http://Night_AdminV2/verGrousList",JSON.stringify({}),(data) => {
		let groups = data.groups
		$('.box-gerenciar').empty()
		groups.forEach((key,value) => {
			
			$('.box-gerenciar').prepend(`

				<div class="item-gerenciar">
					<div class="item-header" style="width: 38%;"><i class="fas fa-tag" style="margin-right: 10px;color: ${key.color}text-shadow: 0px 0px 30px ${key.color};"></i>${key.empresa}</div>

					<div class="item-header3">
						<div class="status" style="color: ${key.color} background: ${key.background}">${key.contador} ONLINE</div>
					</div>

					<div class="item-header4">
						<i class="far fa-users iconheader" onclick="RegisterGroup(this)" data-empresa="${key.empresa}" style="margin-left: 44%;"></i>
					</div>

				</div>
			
			`)
		});
    });
}

function RegisterGroup(data){
	$.post("http://Night_AdminV2/RegisterGroup",JSON.stringify({
		empresa : data.dataset.empresa
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verPlayersGroup()
		} 
	});
};

function verPlayersGroup(verify){
    $.post("http://Night_AdminV2/verPlayersGroup",JSON.stringify({}),(data) => {
		let verPlayersGroup = data.verPlayersGroup

		if(verify =~ 'reload') {
			$('.ver-groups').show(0)
			$('.format').fadeIn(700)
		}

		$('.groups-box').empty()
		verPlayersGroup.forEach((key,value) => {
			$("#name101").html(key.myname);

			
			$('.groups-box').prepend(`

				<div class="item-groups">
					<div class="nome-groups">${key.nome} ${key.sobrenome} [${key.user_id}]</div>
					<div class="cargo-groups">${key.emprego}</div>
					<img class="img-groups" src="${key.img}" alt="">
					<div class="opcoes-div">
						<div class="opcoes-cargo upgrade" onclick="demitirGroups(this)" data-passaporte="${key.user_id}" data-tipo="upar" style="margin-left: -2%;"><i class="fas fa-angle-up"></i></div>
						<div class="opcoes-cargo downgrade" onclick="demitirGroups(this)" data-passaporte="${key.user_id}" data-tipo="rebaixar"><i class="fas fa-angle-down"></i></div>
						<div class="opcoes-cargo" onclick="demitirGroups(this)" data-passaporte="${key.user_id}" data-tipo="demitir"><i class="fas fa-times"></i></div>
					</div>
				</div>
			
			`)
		});
    });
}

function demitirGroups(data){
	$.post("http://Night_AdminV2/gerenciarGrupos",JSON.stringify({
		passaporte : data.dataset.passaporte,
		tipo : data.dataset.tipo,
	}), (data) =>{ 
		if(data.retorno == 'done') {
			LimparInputs()
			Reload()
			verPlayersGroup('reload')
		} 
	});
};



// ---------------------------------------
// -- SISTEMA ADVS
// ---------------------------------------

function paginaPunicao(pagina){
	$(".aplicar-punicao").fadeOut(300);

	if(pagina == "adv") {
		$(".aplicar-adv").fadeIn(300);
	}

	if(pagina == "ban") {
		$(".aplicar-ban").fadeIn(300);
	}

	if(pagina == "kick") {
		$(".aplicar-kick").fadeIn(300);
	}
}

function closePunicao(){
	$(".format").fadeOut(500);
	$(".aplicar-adv").fadeOut(500);
	$(".format").fadeOut(500);
	$(".aplicar-ban").fadeOut(500);
	$(".format").fadeOut(500);
	$(".aplicar-kick").fadeOut(500);
	$(".format").fadeOut(500);
}

function createKick(){
	let $el = $('.criar-teleport:hover');
	let motivo = $("#punicao-kick-input").val();
	if($el.length) {
		$.post("http://Night_AdminV2/addKick",JSON.stringify({
			motivo:motivo,
		}), (data) =>{ 
			if(data.retorno == 'done') {
				closePunicao()
				LimparInputs()
				Reload()
			} 
		});
	}
};

function createBan(){
    let $el = $('.criar-teleport:hover');
    let motivo = $("#punicao-ban-input").val();
    let tempoDias = parseInt($("#punicao-ban-tempo").val());

    if(!tempoDias || tempoDias < 1) {
        alert("Informe um tempo válido em dias!");
        return;
    }

    if($el.length) {
        $.post("http://Night_AdminV2/addBan", JSON.stringify({
            motivo: motivo,
            tempo: tempoDias
        }), (data) => { 
            if(data.retorno == 'done') {
                closePunicao();
                LimparInputs();
                Reload();
            } 
        });
    }
};

function createAdv(){
	let $el = $('.criar-teleport:hover');
	let motivo = $("#punicao-adv-input").val();
	let tempoDias = parseInt($("#punicao-adv-tempo").val());

	if(!tempoDias || tempoDias < 1) {
        alert("Informe um tempo válido em dias!");
        return;
    }

	if($el.length) {
		$.post("http://Night_AdminV2/addAdv",JSON.stringify({
			motivo:motivo,
            tempo: tempoDias
		}), (data) =>{ 
			if(data.retorno == 'done') {
				closePunicao()
				LimparInputs()
				Reload()
			} 
		});
	}
};

const colorPicker = (percent) => {
	var colorPercent = "#43e943";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#43e943";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#e9b543";

	if (percent <= 25)
		colorPercent = "#fd2e09";

	return colorPercent;
}

const colorPicker2 = (percent) => {
	var colorPercent = "rgba(15,15,15,0.8)";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "rgba(15,15,15,0.8)";

	if (percent >= 26 && percent <= 50)
		colorPercent = "rgba(15,15,15,0.8)";

	if (percent <= 25)
		colorPercent = "rgba(15,15,15,0.8)";

	return colorPercent;
}