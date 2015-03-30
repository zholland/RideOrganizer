(function() {

    function getScript(src) {
        document.write('<' + 'script src="' + src + '"><' + '/script>');
    }

    getScript("https://maps.googleapis.com/maps/api/js?key=AIzaSyC6qUy4aKjMOkd8ffdu6rBa44TuhfR3hOA");
    //getScript("https://maps.gstatic.com/maps-api-v3/api/js/20/5/places.js");
})();