$(document).ready(function(){

    window.addEventListener("message", function(event){
        switch (event.data.action){
            case "openIdentity":
                $("#mainPage").css("display","block");
                break;

            case "closeSystem":
                $("#mainPage").css("display","none");
                break;
        };
    });

    document.onkeyup = function(data){
        if (data.which == 27){
            $.post("http://identity/closeSystem");
        };
    };

});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateName') {
        document.querySelector('.items h2').textContent = event.data.identity;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateId') {
        document.querySelector('.userid h1').textContent = event.data.userid;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updatePhone') {
        document.querySelector('.cellphone h2').textContent = event.data.phone;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateAge') {
        document.querySelector('.age h2').textContent = event.data.age;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateRg') {
        document.querySelector('.identity h2').textContent = event.data.rg;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateBank') {
        document.querySelector('.bank h2').textContent = event.data.bank;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateCash') {
        document.querySelector('.carteira h2').textContent = event.data.cash;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateGroup') {
        document.querySelector('.group h2').textContent = event.data.group;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateVip') {
        document.querySelector('.vip h2').textContent = event.data.vip;
    }
});

window.addEventListener('message', function(event) {
    if (event.data.action == 'updateAdmin') {
        document.querySelector('.admin h2').textContent = event.data.admin;
    }
});
