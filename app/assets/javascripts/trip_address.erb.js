(function() {

    function getScript(src) {
        document.write('<' + 'script src="' + src + '"><' + '/script>');
    }

    getScript("https://maps.gstatic.com/maps-api-v3/api/js/20/5/places.js");
})();


if (document.get)

function loadAutoComplete() {

    var input = document.getElementById('trip_destination_address');

    autocomplete = new google.maps.places.Autocomplete(input);
}


google.maps.event.addDomListener(window, 'load', loadAutoComplete);
