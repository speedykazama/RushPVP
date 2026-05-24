$(document).ready(function(){
    $('#freq').focus(function() {
        $(this).val('');
    });

    $('#colorSelector').change(function() {
        let selectedBackground = $(this).val();
        $('#actionmenu').css('background-image', `url(${selectedBackground})`);
    });
  
    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "showMenu":
                $("#actionmenu").css("display", "block");
                playSound("mic_click_on.wav");
                break;
        }
    });  

    document.onkeyup = function(data) {
        const key = data.key;
        switch(key) {
            case 'Escape':
                $("#actionmenu").css("display", "none");
                $.post("http://radio/RadioClose");
                playSound("mic_click_off.wav");
                break;
            case 'Enter':
                $("#freq").blur();
                setFrequency();
                break;
        }
    }
});

$(document).on("click", ".ativar", debounce(function(){
    setFrequency();
}));

$(document).on("click", ".desativar", debounce(function(){
    $.post("http://radio/RadioInactive");
    playSound("mic_click_connect.wav"); // Toca o som ao desativar a frequência
}));

function debounce(func, immediate){
    var timeout;
    return function () {
        var context = this, args = arguments;
        var later = function(){
            timeout = null;
            if (!immediate) func.apply(context,args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later,500);
        if (callNow) func.apply(context,args);
    };
}

const setFrequency = debounce(() => {
    let Frequency = parseInt($('#freq').val());
    if (Frequency > 0){
        $.post("http://radio/RadioActive", JSON.stringify({ Frequency }));
        playSound("mic_click_connect.wav"); // Toca o som ao ativar a frequência
    }
});

function playSound(url) {
    const audio = new Audio(url);
    audio.volume = 0.5; // Ajusta o volume para 50%
    audio.play();
}