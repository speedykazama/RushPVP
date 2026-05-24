import Build from "./Build.js"

$(document).ready(function () {
    "use restrict"

    const main = $('#ui');
    main.hide()


    window.addEventListener("message", function(event) {
        var data = event.data;
        switch (data.action) {
            case "openMarket": 
                main.show()
                Build.Home.Create()
                break;
            case "closeMarket": main.hide()
                break;
            default:
                break;
        }

    })

    $("body").on("keyup", function (key) {
        if (key.which === 27) {
            main.hide()
            Build.Home.Destroy();
            Build.NewOffer.Destroy();
            $.post("http://market/closeMarket")
        }
    });

});
