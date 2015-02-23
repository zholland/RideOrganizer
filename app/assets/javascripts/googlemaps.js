/**
 * Created by EmilyMillard on 15-02-22.
 */


handler = Gmaps.build('Google');
handler.buildMap({ internal: {id: 'one_marker'}}, function(){
    markers = handler.addMarkers([
        {
            lat: 0,
            lng: 0,
            picture: {
                url: "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
                width:  36,
                height: 36
            },
            infowindow: "hello!"
        }
    ]);
});