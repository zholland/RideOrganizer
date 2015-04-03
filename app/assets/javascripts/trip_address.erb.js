(function() {

    function getScript(src) {
        document.write('<' + 'script src="' + src + '"><' + '/script>');
    }

    getScript("http://maps.gstatic.com/maps-api-v3/api/js/20/6/places.js");
})();

function loadAutoComplete() {

    var input = document.getElementById('trip_destination_address');

    if (input != null) {
        autocomplete = new google.maps.places.Autocomplete(input);
    }

}

google.maps.event.addDomListener(window, 'load', loadAutoComplete);
