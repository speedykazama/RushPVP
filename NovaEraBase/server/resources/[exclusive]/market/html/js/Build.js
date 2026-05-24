const Build = {
    Essentials: {
        Currency: (string) => {
            return string.toLocaleString('en-US', {
                style: 'currency',
                currency: 'USD'
            })
        },
        Category: (string) => {
            if (!string) return "Sem categoria"
            switch (string) {
                case "item_food":
                    return "Alimentos"
                case "item_weapon":
                    return "Armas"
                case "item_weapon-ammo":
                    return "Munições"
                case "item_acessory":
                    return "Acessórios"
                case "item_drugs":
                    return "Remédios"
                case "item_tool":
                    return "Ferramentas"
                case "item_resource":
                    return "Recursos"
                default:
                    return "Sem categoria"
            }
        }
    },
    Home: {
        Create: () => {
            $.post("https://market/marketGetCategories").done(function (data) {
                $("#category-list").html("");
                $("#offers-list").html("");

                Build.NewOffer.Destroy();
                Build.MyOffers.Destroy();
                Build.MySolds.Destroy();

                $("#category-list").show();
                $("#offers-list").hide();

                let html = ``;
                for (var key in data) {
                    let value = data[key];

                    html += `
                <div class="item select-product item-filter" data-product="${value.name}" data-name="${value.name}" data-category="${value.category}">
                    <img src="nui://vrp/config/inventory/${value.index}.png" width="50px" height="50px">
                    <span>${value.name} <br><small>${Build.Essentials.Category(value.category)}</small></span>
                    <button>ver ofertas <div class="arrow">${value.offers}</div></button>
                </div>
                `;
                }

                $("#category-list").html(html);

                $(".select-product").on("click", function (e) {
                    e.preventDefault()
                    let product = $(this).data("product")

                    $.post("http://market/marketGetOffers", JSON.stringify({ product: product })).done(function (data) {
                        $("#offers-list").html("");
                        let html = `
                        <h1>Lista de ofertas</h1>
                        <div class="tableMax">
                            <table>
                                <tr>
                                    <th>Vendedor</th>
                                    <th>Produto</th>
                                    <th>Preço uni</th>
                                    <th>Estoque</th>
                                </tr>                      
                            `;
                        for (var key in data) {
                            let value = data[key]
                            html += `
                            <tr class="buy-item" data-offerid="${value.id}" data-maxamount="${value.amount}">
                                <td>${value.seller}</td>
                                <td>${value.name}</td>
                                <td>${Build.Essentials.Currency(value.price)}</td>
                                <td>${value.amount}</td>
                            </tr>`;
                        }

                        html += `</table></div>`;

                        $("#offers-list").html(html);
                        $("#offers-list").show();

                        $('.buy-item').on("click", function (event) {
                            event.stopPropagation();
                            event.stopImmediatePropagation();

                            let offerid = $(this).data("offerid")
                            let maxamount = $(this).data("maxamount")

                            Swal.fire({
                                title: "Informe a quantidade de compra",
                                input: "text",
                                inputPlaceholder: "Quantidade máx. " + maxamount,
                                showCancelButton: true,
                                showLoaderOnConfirm: true,
                                preConfirm: function (result) {
                                    return new Promise(function (resolve, reject) {
                                        if (parseInt(result) !== 0 && parseInt(result) <= parseInt(maxamount)) {
                                            $.post('http://market/marketBuyProduct', JSON.stringify({ offerid: parseInt(offerid), amount: parseInt(result) })).done(function (response) {
                                                if (response === "max_weight") {
                                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você não tem espaço em sua mochila.' })
                                                } else if (response === "no_money") {
                                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você não tem dinheiro.' })
                                                } else if (response === "try") {
                                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente Novamente.' })
                                                } else if (response === "no_stock") {
                                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Não há mais produto em estoque.' })
                                                } else if (response === "owner_nobuy") {
                                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você não pode comprar produto seu.' })
                                                } else {
                                                    Swal.fire({ icon: 'success', title: 'Compra Efetuada', text: 'Você comprou.' }).then(function (confirm) {
                                                        resolve();
                                                        Build.Home.Create()
                                                    })
                                                }
                                            }).catch(function (error) {
                                                reject();
                                            })
                                        } else {
                                            resolve("Informe um valor válido");
                                        }
                                    });
                                },
                                allowOutsideClick: () => !Swal.isLoading()
                            });
                        })
                    })
                })
            })

            $("#btn_new_offer").on("click", function (e) {
                Build.Home.Destroy();
                Build.MyOffers.Destroy();
                Build.MySolds.Destroy();
                Build.NewOffer.Create();
            })

            $("#btn_my_offers").on("click", function (e) {
                Build.Home.Destroy();
                Build.NewOffer.Destroy();
                Build.MySolds.Destroy();
                Build.MyOffers.Create();
            })

            $("#btn_home").on("click", function (e) {
                Build.MyOffers.Destroy();
                Build.NewOffer.Destroy();
                Build.MySolds.Destroy();
                Build.Home.Create();
            })

            $("#btn_my_solds").on("click", function (e) {
                Build.MyOffers.Destroy();
                Build.NewOffer.Destroy();
                Build.Home.Destroy();
                Build.MySolds.Create();
            })

            $('#search').keyup(function () {
                let input = $(this).val();
                if ($.trim(input).length) {
                    $('.item-filter').hide().filter('[data-name*="' + input + '"]').show();
                }
            }).keydown(function (event) {
                if (!$(event.target).val()) {
                    $('.item-filter').show();
                }
            })

            $("select#filter").change(function (event) {
                let input = $(this).children(":selected").data("category")

                if (!input) return

                if (input === "all") {
                    $('.item-filter').show();
                } else {
                    $('.item-filter').hide().filter('[data-category*="' + input + '"]').show();
                }


            })

        },
        Destroy: () => {
            $("#category-list").html("").hide();
            $("#offers-list").html("").hide();
        }
    },
    NewOffer: {
        Create: () => {
            $.post("https://market/marketGetInventoryItems").done(function (data) {
                $("#inventory-user").html("");
                let html = ``;
                for (var key in data) {
                    let value = data[key]
                    html += `
                        <div class="item select-item item-filter" data-item="${value.name}" data-name="${value.name}" data-category="${value.category}">
                        <div><img src="nui://vrp/config/inventory/${value.index}.png" width="50px" height="50px"></div>
                        <div>${value.index}</div>
                        <div>qtd: ${value.amount}</div>                        
                        </div>`;
                        var NameIndex = value.name
                }
                $("#inventory-user").html(html);
                $(".newOffer").show();

                $(".select-item").on("click", function (e) {
                    $("#inventory-user .item").removeClass('selected-user');
                    $(this).addClass('selected-user');
                    let index = $(this).data("item")
                    // let index = $(this).data("item")
                    let item = data[index]
                    if (item) {
                        $("#form-offer").html(`
                            <p>Produtos já cadastrados serão atualizados o preço e estoque, cuidado.</p>
                            <label>produto</label>
                            <input placeholder="${item.name
                            }" disabled>
                            <label>quantidade</label>
                            <input id="input_qt" placeholder="0" value="0">
                            <label>preço UNI</label>
                            <input id="input_price" placeholder="0" value="0">
                            <button>Criar</button>
                        `);

                        $("#form-offer button").on("click", function (e) {
                            e.preventDefault()
                            let imp_amount = $("#form-offer input#input_qt").val()
                            let imp_price = $("#form-offer input#input_price").val()

                            $(this).attr("disabled", "disabled")

                            if (parseInt(imp_amount) > 0) {
                                if (parseInt(imp_amount) <= parseInt(item.amount)) {
                                    if (parseInt(imp_price) > 0) {
                                        $.post("http://market/marketNewOffer", JSON.stringify({ key: index, amount: imp_amount, price: imp_price })).done(function (response) {
                                            if (response === "no_amountitem") {
                                                Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você não possui a quantidade informada.' })
                                                $(this).removeAttr("disabled")
                                            } else if (response == "no_itemdurability") {
                                                Swal.fire({ icon: 'error', title: 'Atenção', text: 'Este Item Nao Possui Durabilidade Suficiente.' })
                                                $(this).removeAttr("disabled")
                                            } else if (response == "no_blacklist") {
                                                Swal.fire({ icon: 'error', title: 'Atenção', text: 'Este Item Esta na BlackList.' })
                                                $(this).removeAttr("disabled")
                                            } else if (response == "max_itemlimit") {
                                                Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você atingiu o máximo de registro de vendas para esse produto.' })
                                                Build.NewOffer.Create()
                                            } else if (response.includes('O valor deve ser')) {
                                                Swal.fire({ icon: 'error', title: 'Atenção', text: response })
                                                $(this).removeAttr("disabled")
                                            } else {
                                                Swal.fire({ icon: 'success', title: 'Produto Cadastrado', text: 'Seu produto ja está a venda.' }).then(function (confirm) {
                                                    Build.NewOffer.Create()
                                                })
                                            }
                                        })
                                    } else {
                                        Swal.fire({ icon: 'error', title: 'Atenção', text: 'Informe um preço maior que zero.' })
                                        $(this).removeAttr("disabled")
                                    }
                                } else {
                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você não possui a quantidade informada.' })
                                    $(this).removeAttr("disabled")
                                }
                            } else {
                                Swal.fire({ icon: 'error', title: 'Atenção', text: 'Informe a quantidade maior que zero.' })
                                $(this).removeAttr("disabled")
                            }
                        })
                    }
                })
            })
        },
        Destroy: () => {
            $("#inventory-user").html("");
            $(".newOffer").hide();
        }
    },
    MyOffers: {
        Create: () => {
            $.post("https://market/marketGetMyOffers").done(function (data) {
                $("#offers-user").html("");
                Build.Home.Destroy();
                Build.NewOffer.Destroy();

                let html = ``;
                for (var key in data) {
                    let value = data[key];
                    html += `
                <div class="item item-filter" data-name="${value.index}" data-category="${value.category}">
                    <img src="nui://vrp/config/inventory/${value.index}.png" width="40px" height="40px">
                    <span>${value.name} <br>
                    <small>preço uni: ${Build.Essentials.Currency(value.oldprice)}</small><br>
                    <small>qtd: ${value.amount}</small><br>
                    <small>${value.category}</small>
                    </span>
                    <button class="btn-alter btn_change_price" data-product="${key}" data-oldprice="${value.oldprice}">Alterar Preço uni</button>
                    <button class="btn-alter btn_remove_offer" data-product="${key}">Remover Anuncio</button>
                </div>
                `;
                }
                $("#offers-user").html(html);
                $("#offers-user").show();

                $(".item .btn_change_price").on("click", function (e) {
                    let key = $(this).data("product")
                    let oldprice = $(this).data("oldprice")
                    Swal.fire({
                        title: "Informe o novo preço",
                        input: "text",
                        inputPlaceholder: "preço atual: " + Build.Essentials.Currency(oldprice),
                        showCancelButton: true,
                        showLoaderOnConfirm: true,
                        preConfirm: function (result) {
                            return new Promise(function (resolve, reject) {
                                if (parseInt(result) !== 0 && parseInt(result) > 0) {
                                    $.post('http://market/marketproductPrice', JSON.stringify({ key: key, price: parseInt(result) })).done(function (response) {
                                        if (response === "noitems") {
                                            Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente, item não encontrado.' })
                                        } else if (response === "try") {
                                            Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente.' })
                                        } else {
                                            Swal.fire({ icon: 'success', title: 'Alteração Efetuada', text: 'Preço alterado com sucesso.' }).then(function (confirm) {
                                                resolve();
                                                Build.MyOffers.Create()
                                            })
                                        }
                                    }).catch(function (error) {
                                        reject();
                                    })
                                } else {
                                    resolve("Informe um valor válido");
                                }
                            });
                        },
                        allowOutsideClick: () => !Swal.isLoading()
                    });
                })
                $(".item .btn_remove_offer").on("click", function (e) {
                    let key = $(this).data("product")

                    Swal.fire({
                        title: 'Deseja realmente remover o anuncio?',
                        text: "impossivel desfazer essa ação!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: `Deletar`,
                    }).then((result) => {
                        /* Read more about isConfirmed, isDenied below */
                        if (result.value) {
                            $.post('http://market/marketRemoveMyOffer', JSON.stringify({ key: key })).done(function (response) {
                                if (response === "noitems") {
                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente, item não encontrado.' })
                                } else if (response === "weight") {
                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Sem espaço na mochila.' })
                                } else if (response === "try") {
                                    Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente.' })
                                } else {
                                    Swal.fire({ icon: 'success', title: 'Alteração Efetuada', text: 'Preço alterado com sucesso.' }).then(function (confirm) {
                                        Build.MyOffers.Create()
                                    })
                                }
                            })
                        }
                    })
                })
            })
        },
        Destroy: () => {
            $("#offers-user").html("").hide();
        }
    },
    MySolds: {
        Create: () => {

            $.post("https://market/marketGetMySolds").done(function (data) {

                let Div = $("#solds-user")
                Div.html("");

                let html = `
                <table>
                    <tr>
                        <th>Produto</th>
                        <th>Quantidade</th>
                        <th>Valor unitario</th>
                        <th>Valor total</th>                                
                        <th>Data venda</th>                                
                        <th>Recolhido Valor</th>                                
                    </tr>
                `;
                for (var key in data) {
                    let value = data[key]
                    html += `
                    <tr class="select_product_sold" data-index="${value.id}">
                        <td>${value.name}</td>
                        <td>${value.amount}</td>
                        <td>${Build.Essentials.Currency(value.price)}</td>
                        <td>${Build.Essentials.Currency(value.amount * value.price)}</td>
                        <td>${value.sold_date}</td>
                        <td>${(value.finish == 0 ? "Clique para recolher" : value.finish_date)}</td>
                    </tr>
                    `;
                }
                html += `</table>`;

                Div.html(html).show();

                $(".select_product_sold").on("click", function (e) {
                    e.preventDefault()

                    let index = $(this).data("index")
                    if (!index) return;
                    $.post('http://market/marketResgateMySoldItem', JSON.stringify({ index: index })).done(function (response) {
                        if (response === "noitems") {
                            Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente, item não encontrado.' })
                        } else if (response === "try") {
                            Swal.fire({ icon: 'error', title: 'Atenção', text: 'Tente novamente.' })
                        } else if (response === "finished") {
                            Swal.fire({ icon: 'error', title: 'Atenção', text: 'Você já resgatou essa venda.' })
                        } else {
                            Swal.fire({ icon: 'success', title: 'Concluido', text: 'Você recebeu sua grana.' }).then(function (confirm) {
                                Build.MySolds.Create()
                            })
                        }
                    })
                })


            })
        },
        Destroy: () => {
            $("#solds-user").html("").hide();
        }
    }
}


export default Build;