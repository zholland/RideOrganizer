(function() {

    function getScript(src) {
        document.write('<' + 'script src="' + src + '"><' + '/script>');
    }

    getScript("https://maps.googleapis.com/maps/api/js?libraries=places&key=AIzaSyC6qUy4aKjMOkd8ffdu6rBa44TuhfR3hOA");
})();