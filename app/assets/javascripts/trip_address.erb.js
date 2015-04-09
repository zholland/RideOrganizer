function loadAutoComplete() {

    var input = document.getElementById('trip_destination_address');

    if (input != null) {
        autocomplete = new google.maps.places.Autocomplete(input);
    }

}

google.maps.event.addDomListener(window, 'load', loadAutoComplete);
