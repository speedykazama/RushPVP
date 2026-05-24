$(document).ready(function() {
    window.addEventListener("message", function(event) {
        if (event.data.open == true) {
            $(".callsystem-body").fadeIn(500);
        } else if (event.data.open == false) {
            $(".callsystem-body").fadeOut(500);
        }

        if (event.data.update) {
            let update = event.data.update;

            let html = ``;

            for (let i = 0; i < update.length; i++) {
                html += `
                <div>
                    <div class="text">
                        <div class="called">${update[i].name} (${update[i].id}) - ${update[i].time}</div>
                        <div class="description">${update[i].description}</div>
                    </div>

                    <div data-id="${String(update[i].id)}" class="accept-btn">
                        <svg width="9" height="7" viewBox="0 0 9 7" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M7.78898 0.000220695C7.57513 -0.00496766 7.34775 0.0813578 7.16976 0.255664L3.12344 4.21968L1.82986 2.95228C1.51438 2.64308 1.04033 2.60985 0.766703 2.87744L0.184371 3.44783C-0.0886926 3.71552 -0.0545174 4.1806 0.260842 4.48969L2.63066 6.81087C2.89718 7.07272 3.36966 7.05318 3.61701 6.81087L8.73889 1.79252C9.05436 1.48343 9.08899 1.0189 8.81536 0.751318L8.23314 0.180378C8.11325 0.0635848 7.95534 0.00419475 7.78898 0.000220695V0.000220695Z" fill="white"/>
                        </svg>
                    </div>
                </div>
                `
            }

            $(".notify-length").html(String(update.length));
            $(".calls").html(html);
            updateClick();
        }
    });

    document.onkeyup = function(event) {
        if (event.keyCode == 27) {
            $.post("https://calladmin/close", JSON.stringify({}), function(data) {});
            $(".callsystem-body").fadeOut(500);
        } else if (event.keyCode == 9) {
            $.post("https://calladmin/notify", JSON.stringify({}), function(data) {
                if (data.notify) {
                    $(".informations .description").html(`PRESSIONE <span style="color: #3498eb;">[TAB]</span> PARA <span style="color: #3498eb;">DESATIVAR</span> AS NOTIFICAÇÕES`);
                } else {
                    $(".informations .description").html(`PRESSIONE <span style="color: #3498eb;">[TAB]</span> PARA <span style="color: #3498eb;">ATIVAR</span> AS NOTIFICAÇÕES`);
                }
            });
        }
    }
});

function updateClick() {
    $(".accept-btn").on("click", function(event) {
        $(".callsystem-body").fadeOut(500);
        $.post("https://calladmin/accept", JSON.stringify({id: Number($(this).attr("data-id"))}), function(data) {});
        $.post("https://calladmin/close", JSON.stringify({}), function(data) {});
    });
}