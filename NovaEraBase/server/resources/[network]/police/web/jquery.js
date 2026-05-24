let textEditor;
var selectPage = "Prender",
    reversePage = "Prender";
$(document).ready(function () {
    (window.onerror = (t) => "ResizeObserver loop limit exceeded" === t || e(...arguments)),
        functionPrender(),
        window.addEventListener("message", function (t) {
            switch (t.data.action) {
                case "Open":
                    $("#mainPage").css("display", "block"), UpdatePoliceFines();
                    break;
                case "Close":
                    $("#mainPage").css("display", "none");
                    break;
                case "reloadPrison":
                    limpar(), functionPrender();
                    break;
                case "reloadFine":
                    functionMultar();
                    break;
                case "reloadProcurados":
                    functionProcurados();
                    break;
                case "reloadPortes":
                    functionPortes();
                    break;
                case "reloadSearch":
                    functionSearch(t.data.data);
            }
        }),
        (document.onkeyup = function (t) {
            27 === t.which && $.post("http://police/Close");
        }),
        localStorage.getItem("prenderTexto") && localStorage.removeItem("prenderTexto");
}),
    $(document).on("click", "#mainMenu .nav li", function () {
        let t = $(this).hasClass("active");
        $("#mainMenu .nav li").removeClass("active"), t || ($(this).addClass("active"), (reversePage = selectPage), $("#content").css("height", "540px"), $("#content").css("margin", "30px 10px 30px 10px"));
    });
const UpdatePoliceFines = () => {
        fetch("./police-fines.json")
            .then((t) => t.json())
            .then((t) => {
                let a = document.getElementById("modalLeft"),
                    o = document.getElementById("modalRight");
                if (!a || !o) return;
                (a.innerHTML = ""), (o.innerHTML = "");
                let i = document.createElement("h3");
                (i.innerText = "INFRA\xc7\xd5ES"), i.classList.add("colorH3"), a.appendChild(i);
                let r = document.createElement("h3");
                (r.innerText = "A\xc7\xd5ES FECHADAS"), r.classList.add("colorH3"), a.appendChild(r);
                let s = document.createElement("h3");
                for (let n of ((s.innerText = "CRIMES"), s.classList.add("colorH3"), o.appendChild(s), t.data)) {
                    let { infracao: l, multa: d, fianca: c, apreender_veiculo: p, descricao: u, categoria: m } = n.attributes,
                        v = document.createElement("p");
                    v.classList.add("colorCrimes");
                    let b = document.createElement("input");
                    (b.type = "checkbox"), (b.name = "crime[]"), (b.value = `${l.toUpperCase()}|${d}|${c}`), b.addEventListener("click", calcular), v.appendChild(b);
                    let f = document.createElement("span");
                    switch (((f.innerText = l.toUpperCase()), v.appendChild(f), m)) {
                        case "INFRA\xc7\xd5ES":
                            i.after(v);
                            break;
                        case "CRIMES":
                            s.after(v);
                            break;
                        case "A\xc7\xd5ES FECHADAS":
                            r.after(v);
                    }
                }
            })
            .catch((t) => console.log("Error:", t));
    },
    functionVisualizarPrisao = (t) => {
        "" !== t &&
            $.post("http://police/CheckPrison", JSON.stringify({ idprisao: parseInt(t) }), (t) => {
                !0 === t.result[0]
                    ? $("#content").html(`
					<div id="titleContent">Pris\xe3o: ${t.result[1]}</div>
					<div id="pageCenter">
	
						<div class="infoPrisao">
							<b>Passaporte:</b> ${t.result[2].nuser_id}<br>
							<b>Servi\xe7os:</b> ${t.result[2].services}<br>
							<b>Multas:</b> ${t.result[2].fines}<br>
							<br>
							<b>Oficial respons\xe1vel:</b> ${t.result[2].police}<br>
							<b>Demais oficiais:</b> ${null != t.result[2].cops && "" != t.result[2].cops ? t.result[2].cops : "Sem outros oficiais"}<br>
							<b>Associa\xe7\xe3o criminosa:</b> ${null != t.result[2].association && "" != t.result[2].association ? t.result[2].association : "Sem associa\xe7\xe3o"}<br>
							<b>Material gen\xe9tico:</b> ${0 == t.result[2].residual ? "N\xe3o coletado" : "Coletado"}<br>
							<br>
							<b>Data:</b> ${t.result[2].date}<br>
							<b>Motivos:</b> ${t.result[2].text}<br>
						</div>
						<div class="infoPrisaoFoto">
							<img class="foto" src="${t.result[2].url}" />
						</div>
					</div>
				`)
                    : $("#content").html(`
					<div id="titleContent">Pris\xe3o</div>
					N\xe3o conseguimos carregar as informa\xe7\xf5es desta pris\xe3o.
				`);
            });
    },
    functionVisualizarProcurado = (t) => {
        "" !== t &&
            $.post("http://police/CheckWarrant", JSON.stringify({ idprocurado: parseInt(t) }), (t) => {
                !0 === t.result[0]
                    ? $("#content").html(`
					<div id="titleContent">Informa\xe7\xf5es do procurado: ${t.result[1]}</div>
					<div id="pageCenter">
	
						<div class="infoBox">
							<b>Passaporte:</b> ${t.result[2].user_id}<br>
							<b>Nome:</b> ${t.result[2].identity}<br>
							<b>Status:</b> ${t.result[2].status}<br>
							<b>Oficial:</b> ${t.result[2].nidentity}<br>
							<b>Motivo:</b> ${t.result[2].reason}<br>
							<b>Data de expedi\xe7\xe3o:</b> ${t.result[2].timeStamp}<br>
						</div>
						<label class="buttonVoltar" onclick="functionProcurados();">Voltar</label>

					</div>
				`)
                    : $("#content").html(`
					<div id="titleContent">Procurados</div>
					N\xe3o conseguimos carregar as informa\xe7\xf5es deste procurado.
				`);
            });
    },
    functionSearch = (t) => {
        "" !== t &&
            $.post("http://police/Search", JSON.stringify({ passaporte: parseInt(t) }), (a) => {
                !0 === a.result[0]
                    ? $("#content").html(`
					<div id="titleContent">${a.result[1]}</div>
					<div id="pageLeftSearch">
						<div class="searchBox">
							<b>Passaporte:</b> ${formatarNumero(t)}<br>
							<b>Nome:</b> ${a.result[1]}<br>
							<b>Telefone:</b> ${a.result[2]}<br>
							<b>Multas:</b> $${a.result[3]}<br>
							<b>Porte de Arma:</b> ${0 == a.result[5] ? "N\xe3o" : "Sim"} <update class="portSearch" data-id="${t}">Atualizar</update><br>
						</div>
						${a.result[6]
                            .map(
                                (t) => `
						
							<div class="searchBox" style="margin-top: 5px;">
								<div class="fineSeachTitle3">
									<span style="width: 280px; float: left;"><b>Porte:</b> ${t.portType}</span>
									<span style="width: 280px; float: left;"><b>Serial:</b> ${t.weapon}-${t.serial}</span>
								</div>
							</div>
						`
                            )
                            .join("")}
						${a.result[4]
                            .map(
                                (t) => `
							<div class="recordBox">
								<div class="fineSeachTitle">
									<span style="width: 180px; float: left;"><b>Policial:</b> ${t.police}</span>
									<span style="width: 130px; float: left;"><b>Servi\xe7os:</b> ${formatarNumero(t.services)}</span>
									<span style="width: 130px; float: left;"><b>Multa:</b> $${formatarNumero(t.fines)}</span>
									<span style="width: 130px; float: left;">${t.date}</span>
									<span style="width: 55px; float: right; text-align: right;">
										<button id="buttonPrisao${t.id}" class="buttonPrisao"><i class="fa fa-eye"></i></button>
									</span>
								</div>
								<b>Motivo:</b><br> - ${t.text}
							</div>
						`
                            )
                            .join("")}
					</div>

					<div id="pageRight">
						<h2>OBSERVA\xc7\xd5ES:</h2>
						<b>1:</b> Todas as informa\xe7\xf5es encontradas s\xe3o de uso exclusivo policial, tudo que for encontrado na mesma s\xe3o informa\xe7\xf5es em tempo real.<br><br>
						<b>2:</b> Nunca forne\xe7a qualquer informa\xe7\xe3o dessa p\xe1gina para outra pessoa, apenas se a mesma for o propriet\xe1rio ou o advogado do mesmo.
					</div>
				`)
                    : $("#content").html(`
					<div id="titleContent">RESULTADO</div>
					N\xe3o foi encontrado informa\xe7\xf5es sobre o passaporte procurado.
				`);
            });
    },
    displayGoogleDoc = (t) => {
        $("#content").html(`<iframe src="https://docs.google.com/document/d/${t}/preview" style="width: 100%;height: 95%;border: none"></iframe>`);
    };
function calcular() {
    let t = 0,
        a = 0,
        o = document.getElementsByName("crime[]");
    for (let i = 0; i < o.length; i++)
        if (o[i].checked) {
            let r = o[i].value.split("|");
            (t += parseInt(r[1])), (a += parseInt(r[2]));
        }
    let s = parseInt(document.getElementById("drogas").value);
    s > 0 && ((t += 1e3 * s), (a += 25 * s));
    let n = parseInt(document.getElementById("sujo").value);
    n > 0 && ((t += 1500 * n), (a += 35 * n));
    let l = parseInt(document.getElementById("multas").value);
    l > 0 && ((t += 1500 * l), (a += 30 * l));
    let d = parseInt(document.getElementById("muni\xe7ao").value);
    d > 0 && ((t += 2e3 * d), (a += 40 * d));
    document.getElementById("prenderMultas").value = t;
    document.getElementById("prenderServices").value = a;
    let c = document.getElementsByName("crime[]"),
        p = "",
        u = "";
    for (let m = 0; m < c.length; m++) c[m].checked && (u = (p = c[m].value.split("|")[0]) + ", " + u);
    o = u;
    document.getElementById("prenderTexto").value = o;
    let v = localStorage.getItem("prenderTexto") ?? "",
        b = v.match(/<p data-criminal="true">(.*?)<\/p>/);
    b && (v = v.slice(0, b.index)), (v += `<p data-criminal="true">${o}</p>`), textEditor && textEditor.setData(v);
}
function limpar() {
    for (var t = document.getElementsByName("crime[]"), a = 0; a < t.length; a++) t[a].checked = !1;
    document.getElementById("drogas").value = 0;
    var o = document.getElementById("sujo");
    o.value = 0;
    var o = document.getElementById("multas");
    o.value = 0;
    var o = document.getElementById("muni\xe7ao");
    (o.value = 0), (document.getElementById("prenderMultas").value = "0"), (document.getElementById("prenderServices").value = "0"), (document.getElementById("prenderTexto").value = ""), localStorage.removeItem("prenderMultas");
}
$(document).on("click", ".buttonSearch", function (t) {
    let a = $("#searchPassaporte").val();
    functionSearch(a);
}),
    $(document).on("click", ".portSearch", function (t) {
        $.post("http://police/UpdatePort", JSON.stringify({ passaporte: t.target.dataset.id }));
    }),
    $(document).on("click", ".buttonPrisao", function (t) {
        t.preventDefault();
        let a = $(this).attr("id").replace("buttonPrisao", "");
        functionVisualizarPrisao(a);
    }),
    $(document).on("click", ".buttonProcurado", function (t) {
        t.preventDefault();
        let a = $(this).attr("id").replace("buttonProcurado", "");
        functionVisualizarProcurado(a);
    }),
    $(document).on("click", ".buttonExcluirProcurado", function (t) {
        t.preventDefault();
        let a = $(this).attr("id").replace("buttonExcluirProcurado", "");
        $.post("http://police/DeleteWarrant", JSON.stringify({ excluirpro: a }));
    }),
    $(document).on("click", ".buttonExcluirPorte", function (t) {
        t.preventDefault();
        let a = $(this).attr("id").replace("buttonExcluirPorte", "");
        $.post("http://police/DeleteGunlicense", JSON.stringify({ excluirporte: a }));
    }),
    $(document).on("click", ".buttoneditPort", function (t) {
        t.preventDefault();
        let a = $(this).attr("id");
        if (a) functionEditPorte(a.replace("buttoneditPort", ""));
    });
const functionPrender = () => {
    (selectPage = "Prender"),
        $("#content").html(`
		<div id="titleContent">PRENDER</div>
		<div id="pageLeft">
			<input class="inputTentativas" id="prenderPassaporte" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Passaporte."/>
			<input class="inputTentativas2" id="prenderUrl" type="text" value="" placeholder="Url da foto."/>

			<label class="buttonCrimes" for="modal-1">Adicionar crimes</label>
			
			<div style="display: inline-block">
				<input class="inputTentativas" id="prenderServices" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Servi\xe7os."/>
				<input class="inputTentativas2" id="prenderMultas" type="number" onKeyPress="if(this.value.length==7) return false;" value="" placeholder="Valor da multa."/>
			</div>
			<div class="textareaPrison" id="prenderTexto"></div>
			<div style="display: inline-block">
				<select class="inputPrison" name="prenderMaterial" id="prenderMaterial"><option value="N\xe3o">Sem coleta de material gen\xe9tico.</option><option value="Sim">Material gen\xe9tico coletado.</option></select>
				<input class="inputPrison" id="prenderAssociacao" type="text" value="" placeholder="Associa\xe7\xe3o (Ex: 1, 2, 3)."/>
			</div>
			<input class="inputPrison" id="prenderPenais" type="text" value="" placeholder="Oficiais Penais (Ex: 1, 2, 3)."/>
			<input class="inputPrison" id="prenderMilitares" type="text" value="" placeholder="Demais policiais (Ex: 1, 2, 3)."/>
			<button class="buttonPrison">Prender</button>
			<button class="buttonPrisonLimpar" onclick="limpar()">Limpar</button>
			
		</div>

		<div id="pageRight">
			<h2>OBSERVA\xc7\xd5ES:</h2>
			<b>1:</b> Antes de enviar o formul\xe1rio verifique corretamente se todas as informa\xe7\xf5es est\xe3o de acordo com o crime efetuado, voc\xea \xe9 respons\xe1vel por todas as informa\xe7\xf5es enviadas e salvas no sistema.<br><br>
			<b>2:</b> Ao preencher o campo de multas, verifique se o valor est\xe1 correto, ap\xf3s enviar o formul\xe1rio n\xe3o ser\xe1 poss\xedvel alterar ou remover a multa enviada.<br><br>
			<b>3:</b> Todas as pris\xf5es s\xe3o salvas no sistema ap\xf3s o envio, ent\xe3o lembre-se que cada formul\xe1rio enviado, o valor das multas, servi\xe7os e afins s\xe3o somados com a ultima pris\xe3o caso o mesmo ainda esteja preso.
		</div>
	`),
        setTimeout(() => {
            InlineEditor.create(document.querySelector("#prenderTexto"), { placeholder: "Todas as informa\xe7\xf5es dos crimes.", htmlSupport: { allow: [{ name: "p", attributes: { "data-criminal": !0 } }] }, removePlugins: ["Markdown"] })
                .then((t) => {
                    textEditor = t;
                    let a = localStorage.getItem("prenderTexto");
                    a && t.setData(a), t.model.document.on("change:data", () => localStorage.setItem("prenderTexto", t.getData()));
                })
                .catch(console.error);
        }, 100);
};
$(document).on("click", ".buttonPrison", function (t) {
    let a = $("#prenderPassaporte").val(),
        o = $("#prenderServices").val(),
        i = $("#prenderUrl").val(),
        r = $("#prenderMultas").val(),
        s = localStorage.getItem("prenderTexto") || "",
        n = $("#prenderMaterial").val(),
        l = $("#prenderAssociacao").val(),
        d = $("#prenderPenais").val(),
        c = $("#prenderMilitares").val();
    if (s.includes("script")) {
        localStorage.removeItem("prenderTexto"), textEditor?.setData("");
        return;
    }
    "" !== a && "" !== o && "" !== r && "" !== s && "" !== i && $.post("http://police/Prison", JSON.stringify({ passaporte: parseInt(a), servicos: parseInt(o), multas: parseInt(r), texto: s, associacao: l, material: n, url: i, penais: d, militares: c }));
});
const functionPortes = () => {
        (selectPage = "Portes"),
            $.post("http://police/SearchGunlicense", JSON.stringify({ type: "consultar" }), (t) => {
                !0 === t.result[0]
                    ? $("#content").html(`
				<div id="titleContent">Portes</div>
				<div id="pageCenter">
					<label class="buttonAddPortes" onclick="functionAddPorte();">Adicionar Porte</label>
					${t.result[1]
                        .map(
                            (t) => `
						<div class="centerBox">
							
							<div class="fineSeachTitle3" style="display: inline-block;">
								<span style="width: 480px; float: left;"><b>Passaporte:</b> ${t.user_id}</span>
								<span style="width: 380px; float: left;"><b>Nome:</b> ${t.identity}</span>
								<span style="width: 100px; float: right;">
									<button id="buttoneditPort${t.portId}" class="buttoneditPort"><i class="fa fa-pencil"></i></button>
									<button id="buttonExcluirPorte${t.portId}" class="buttonExcluirPorte"><i class="fa fa-trash"></i></button>
								</span>
								<span style="width: 480px; float: left;"><b>Tipo de porte:</b> ${t.portType}</span>
								<span style="width: 480px; float: left;"><b>Serial:</b> ${t.weapon}-${t.serial}</span>
								<span style="width: 480px; float: left;"><b>Oficial:</b> ${t.nidentity}</span>
								<span style="width: 480px; float: left;"><b>Data:</b> ${t.date}</span>
					
							</div>
						</div>
					`
                        )
                        .join("")}
				</div>
			`)
                    : $("#content").html(`
				<div id="titleContent">Portes</div>
				N\xe3o foi encontrado informa\xe7\xf5es sobre portes.
				<label class="buttonAddPortes" onclick="functionAddPorte();">Adicionar Porte</label>
			`);
            });
    },
    functionEditPorte = (t) => {
        "" !== t &&
            $.post("http://police/GetGunlicense", JSON.stringify({ idedporte: parseInt(t) }), (t) => {
                !0 === t.result[0]
                    ? $("#content").html(`
					<div id="titleContent">Editar Porte</div>
					<div id="pageCenter">
						<input type="hidden" class="inputFormCenter" id="porteId" value="${t.result[1].portId}"></input>
						<input class="inputFormCenter2" id="portePassaporte" value="${t.result[1].user_id}" placeholder="Passaporte"></input>
						<input class="inputFormCenter2" id="porteSerial" value="${t.result[1].serial}" placeholder="Serial de arma"></input>
						<input class="inputFormCenter2" id="porteStatus" value="${t.result[1].portType}" placeholder="Tipo de porte"></input>
						<input class="inputFormCenter2" id="porteArma" value="${t.result[1].weapon}" placeholder="Armamento"></input>
						<button class="buttonVoltar" onclick="functionPortes();">Voltar</button>
						<button class="buttonEditarPorte">Editar</button>
					</div>
				`)
                    : $("#content").html(`
					<div id="titleContent">RESULTADO</div>
					N\xe3o foi encontrado informa\xe7\xf5es sobre o passaporte procurado.
				`);
            });
    };
$(document).on("click", ".buttonEditarPorte", function (t) {
    let a = $("#porteId").val(),
        o = $("#portePassaporte").val(),
        i = $("#porteNome").val(),
        r = $("#porteSerial").val(),
        s = $("#porteStatus").val(),
        n = $("#porteArma").val(),
        l = $("#porteExame").val();
    "" !== o && "" !== a && "" !== i && "" !== r && "" !== s && "" !== l && $.post("http://police/EditGunlicense", JSON.stringify({ id: a, passaporte: parseInt(o), nome: i, serial: r, status: s, weapon: n, exame: l }));
});
const functionAddPorte = () => {
    (selectPage = "Porte"),
        $("#content").html(`
		<div id="titleContent">Adicionar Porte</div>
		<div id="pageCenter">
			<input class="inputFormCenter2" id="portePassaporte" value="" placeholder="Passaporte"></input>
			<input class="inputFormCenter2" id="porteSerial" value="" placeholder="Serial de arma"></input>
			<input class="inputFormCenter2" id="porteStatus" value="" placeholder="Tipo de porte"></input>
			<input class="inputFormCenter2" id="porteArma" value="" placeholder="Armamento"></input>

			<button class="buttonAddPorte">Adicionar</button>
		</div>
	`);
};
$(document).on("click", ".buttonAddPorte", function (t) {
    let a = $("#portePassaporte").val(),
        o = $("#porteNome").val(),
        i = $("#porteSerial").val(),
        r = $("#porteStatus").val(),
        s = $("#porteArma").val(),
        n = $("#porteExame").val();
    "" !== a && "" !== o && "" !== i && "" !== r && "" !== s && "" !== n && $.post("http://police/GiveGunlicense", JSON.stringify({ passaporte: parseInt(a), nome: o, serial: i, status: r, arma: s, exame: n }));
});
const functionProcurados = () => {
        (selectPage = "Procurados"),
            $.post("http://police/GetWarrant", JSON.stringify({ type: "consultar" }), (t) => {
                !0 == t.result[0]
                    ? $("#content").html(`
				<div id="titleContent">Procurados</div>
				<div id="pageCenter">
					<label class="buttonAddProcurado" onclick="functionAddProcurado();">Adicionar Procurado</label>
					${t.result[1]
                        .map(
                            (t) => `
						<div class="centerBox">
							
							<div class="fineSeachTitle2" style="display: inline-block;">
								<span style="width: 320px; float: left;"><b>Passaporte:</b> ${t.user_id}</span>
								<span style="width: 320px; float: left;"><b>Nome:</b> ${t.identity}</span>
								<span style="width: 320px; float: left;"><b>Status:</b> ${t.status}</span>
								<span style="width: 320px; float: left;"><b>Oficial:</b> ${t.nidentity}</span>
								<span style="width: 320px; float: left;"><b>Data:</b> ${t.timeStamp}</span>
								<span style="width: 320px; float: right;">
								<button id="buttonProcurado${t.id}" class="buttonProcurado"><i class="fa fa-eye"></i></button>
								<button id="buttonExcluirProcurado${t.id}" class="buttonExcluirProcurado"><i class="fa fa-trash"></i></button>
								</span>
							</div>
							<br />
							<div style="display: inline-block;">
								<b>Motivo:</b><br> - ${t.reason}
							</div>
						</div>
					`
                        )
                        .join("")}
				</div>
			`)
                    : $("#content").html(`
				<div id="titleContent">Procurados</div>
				N\xe3o foi encontrado informa\xe7\xf5es sobre procurados.
				<label class="buttonAddProcurado" onclick="functionAddProcurado();">Adicionar Procurado</label>
			`);
            });
    },
    functionAddProcurado = () => {
        (selectPage = "Procurado"),
            $("#content").html(`
		<div id="titleContent">Adicionar Procurado</div>
		<div id="pageLeft">
			<input class="inputFormCenter4" id="procuradoPassaporte" value="" placeholder="Passaporte."></input>
			<textarea class="textareaFormCenter" id="procuradoTexto" maxlength="500" placeholder="Todas as informa\xe7\xf5es."></textarea>
			<button class="buttonAddP">Adicionar</button>
		</div>
    
        <div id="pageRight">
            <h2>OBSERVA\xc7\xd5ES:</h2>
            <b>1:</b> Todas as informa\xe7\xf5es encontradas s\xe3o de uso exclusivo policial, tudo que for encontrado na mesma s\xe3o informa\xe7\xf5es em tempo real.<br><br>
            <b>2:</b> Nunca forne\xe7a qualquer informa\xe7\xe3o dessa p\xe1gina para outra pessoa, apenas se a mesma for o propriet\xe1rio ou o advogado do mesmo.
        </div>
	`);
    };
$(document).on("click", ".buttonAddP", function (t) {
    let a = $("#procuradoPassaporte").val(),
        o = $("#procuradoTexto").val();
    "" !== a && "" !== o && $.post("http://police/Warrant", JSON.stringify({ passaporte: parseInt(a), texto: o }));
});
const functionMultar = () => {
        (selectPage = "Multar"),
            $("#content").html(`
		<div id="titleContent">MULTAR</div>
		<div id="pageLeft">
			<input class="inputFine" id="multarPassaporte" type="number" onKeyPress="if(this.value.length==5) return false;" value="" placeholder="Passaporte."></input>
			<input class="inputFine2" id="multarMultas" type="number" onKeyPress="if(this.value.length==7) return false;" value="" placeholder="Valor da multa."></input>
			<textarea class="textareaFine" id="multarTexto" maxlength="500" value="" placeholder="Todas as informa\xe7\xf5es da multa."></textarea>
			<button class="buttonFine">Multar</button>
		</div>

		<div id="pageRight">
			<h2>OBSERVA\xc7\xd5ES:</h2>
			<b>1:</b> Antes de enviar o formul\xe1rio verifique corretamente se todas as informa\xe7\xf5es est\xe3o de acordo com a multa, voc\xea \xe9 respons\xe1vel por todas as informa\xe7\xf5es enviadas e salvas no sistema.<br><br>
			<b>2:</b> Ao preencher o campo de multas, verifique se o valor est\xe1 correto, ap\xf3s enviar o formul\xe1rio n\xe3o ser\xe1 poss\xedvel alterar ou remover a multa enviada.<br><br>
		</div>
	`);
    },
    functionRegisterBoletim = () => {
        let t = document.getElementById("boletim-victim-id"),
            a = document.getElementById("boletim-victim-name");
        if (t?.value !== "" || a?.value !== "") {
            let o = textEditor.getData();
            "" !== o &&
                ($.post("http://police/AddReport", JSON.stringify({ victim_id: t?.value, victim_name: a?.value, victim_report: o })).then(() => {
                    functionBoletins();
                }),
                localStorage.setItem("boletimTexto", ""));
        }
    },
    functionAddBoletim = () => {
        (selectPage = "Porte"),
            $("#content").html(`
		<div id="titleContent">Registrar novo Boletim</div>
		<div id="pageLeft">
			<input class="inputFine" id="boletim-victim-id" type="number" value="" placeholder="Passaporte da v\xedtima"/>
			<input class="inputFine2" id="boletim-victim-name" type="text" value="" placeholder="Nome da vitima"/>
			<div class="textareaBoletim" id="boletimTexto"></div>
			<button class="buttonAddPortes" style="float: left" onclick="functionBoletins()">Voltar</button>
			<button class="buttonReport" onclick="functionRegisterBoletim()">Registrar</button>
		</div>
	`),
            setTimeout(() => {
                InlineEditor.create(document.querySelector("#boletimTexto"), { placeholder: "Descreva o ocorrido.", removePlugins: ["Markdown"] })
                    .then((t) => {
                        textEditor = t;
                        let a = localStorage.getItem("boletimTexto");
                        a && t.setData(a), t.model.document.on("change:data", () => localStorage.setItem("boletimTexto", t.getData()));
                    })
                    .catch(console.error);
            }, 100);
    },
    functionBoletimSolved = (t) => {
        let a = document.getElementById(`report-status-${t}`),
            o = document.getElementById(`report-check-${t}`);
        if (a && o) {
            (a.style.color = "#2DC937"), (a.innerText = "Sim");
            let i = document.getElementById(`report-delete-${t}`);
            i &&
                ((i.style.visibility = "hidden"),
                setTimeout(() => {
                    i.style.visibility = "visible";
                }, 3e3)),
                o.remove(),
                $.post("http://police/ReportSolved", JSON.stringify({ id: t }));
        }
    },
    functionBoletimDelete = (t) => {
        let a = document.getElementById(`report-${t}`);
        a && (a.remove(), $.post("http://police/ReportRemove", JSON.stringify({ id: t })));
    };
function formatarData(t) {
    let a = t.getFullYear(),
        o;
    return `${a}-${String(t.getMonth() + 1).padStart(2, "0")}-${String(t.getDate()).padStart(2, "0")}`;
}
const functionBoletins = () => {
    $.post("http://police/Reports", JSON.stringify({ type: "consultar" }), (t) => {
        $("#content").html(`
			<div id="titleContent">BOLETIM DE OCORR\xcaNCIA</div>
			<div id="pageCenter">
				<label class="buttonAddPortes" onclick="functionAddBoletim()">Registrar Boletim</label>
				${t.map(
                    (t) => `<div class="centerBox" id="report-${t.id}">
					<div class="fineSeachTitle3" style="display: inline-block;">
						<span style="width: 480px; float: left;"><b>Passaporte:</b>${t.victim_id} </span>
						<span style="width: 380px; float: left;"><b>Oficial Resp:</b> ${t.police_name}</span>
						<span style="width: 100px; float: right;">
							${t.solved ? "" : `<button onclick="functionBoletimSolved(${t.id})" id="report-check-${t.id}" style="background-color: transparent;border: none;cursor: pointer;"><i class="fa fa-check"></i></button>`}
							<button id="report-delete-${t.id}" onclick="functionBoletimDelete(${t.id})" style="background-color: transparent;border: none;cursor: pointer;"><i class="fa fa-trash"></i></button>
						</span>
						<span style="width: 480px; float: left;"><b>Nome:</b> ${t.victim_name}</span>
						<span style="width: 480px; float: left;"><b>Data:</b> ${t.created_at}</span>
						<span style="width: 480px; float: left;"><b>Ocorrido:</b> ${t.victim_report}</span>
						<span style="width: 480px; float: left;"><b>Ult. Atualiza\xe7\xe3o:</b> ${t.updated_at}</span>
						<span style="width: 480px; float: left;"><b>Resolvido:</b> ${t.solved ? '<span style="color: #2dc937">Sim</span>' : `<span style="color: #cc3232" id="report-status-${t.id}">N\xe3o</span>`}</span>
					</div>
				</div>`
                )}
			</div>
		`);
    });
};
$(document).on("click", ".buttonFine", function (t) {
    let a = $("#multarPassaporte").val(),
        o = $("#multarMultas").val(),
        i = $("#multarTexto").val();
    "" !== a && "" !== o && "" !== i && $.post("http://police/Fine", JSON.stringify({ passaporte: parseInt(a), multas: parseInt(o), texto: i, driverlicense: 0 }));
});
const formatarNumero = (t) => {
    t = t.toString();
    let a = "",
        o = 0;
    for (let i = t.length; i > 0; i--) (a += t.substr(i - 1, 1) + (2 === o && 1 !== i ? "." : "")), (o = 2 === o ? 0 : o + 1);
    return a.split("").reverse().join("");
};
