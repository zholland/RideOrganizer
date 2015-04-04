function initNewTravellerRows() {
    $('<tr id="new-driver-row">').appendTo('#drivers-table tbody')
        .append($('<td>').html('<a class="new-driver" href="#" id="newdrivername" data-title="Enter name"></a>'))
        .append($('<td>').html('<a class="new-driver" href="#" id="newdriveremail" data-title="Enter email"></a>'))
        .append($('<td>').html('<a class="new-driver" href="#" id="newdriveraddress" data-title="Enter address"></a>'))
        .append($('<td>').html('<a class="new-driver" href="#" id="newdrivernumber_of_passengers" data-title="Enter vehicle capacity"></a>'))
        .append($('<td>').html('<button class="btn btn-primary table-button" id="save-new-driver">Save</button>'));

    $('<tr id="new-passenger-row">').appendTo('#passengers-table tbody')
        .append($('<td>').html('<a class="new-passenger" href="#" id="newpassengername" data-title="Enter name"></a>'))
        .append($('<td>').html('<a class="new-passenger" href="#" id="newpassengeremail" data-title="Enter email"></a>'))
        .append($('<td>').html('<a class="new-passenger" href="#" id="newpassengeraddress" data-title="Enter address"></a>'))
        .append($('<td>').html('<button class="btn btn-primary table-button" id="save-new-passenger">Save</button>'));
}

function updateTravellers(travellers) {
    // Remove existing rows
    $('#drivers-table tbody').children().remove();
    $('#passengers-table tbody').children().remove();

    var driverIds = [];
    var passengerIds = [];
    var i;
    for (i = 0; i < travellers.length; i++) {
        if (travellers[i].number_of_passengers != null) {
            $('<tr id="traveller-' + travellers[i].id + '">').appendTo('#drivers-table tbody')
                .append($('<td>').html('<a href="#" id="name-' + travellers[i].id + '">' + travellers[i].name + '</a>'))
                .append($('<td>').html('<a href="#" id="email-' + travellers[i].id + '">' + travellers[i].email + '</a>'))
                .append($('<td>').html('<a href="#" id="address-' + travellers[i].id + '">' + travellers[i].address + '</a>'))
                .append($('<td>').html('<a href="#" id="number_of_passengers-' + travellers[i].id + '">' + travellers[i].number_of_passengers + '</a>'))
                .append($('<td>').html('<a href="destroy_traveller/' + travellers[i].id + '" data-remote="true" data-method="delete" onclick="removeRow(' + travellers[i].id + ')">Delete</a>'));
            driverIds[driverIds.length] = travellers[i].id
        } else {
            $('<tr id="traveller-' + travellers[i].id + '">').appendTo('#passengers-table tbody')
                .append($('<td>').html('<a href="#" id="name-' + travellers[i].id + '">' + travellers[i].name + '</a>'))
                .append($('<td>').html('<a href="#" id="email-' + travellers[i].id + '">' + travellers[i].email + '</a>'))
                .append($('<td>').html('<a href="#" id="address-' + travellers[i].id + '">' + travellers[i].address + '</a>'))
                .append($('<td>').html('<a href="destroy_traveller/' + travellers[i].id + '" data-remote="true" data-method="delete" onclick="removeRow(' + travellers[i].id + ')">Delete</a>'));
            passengerIds[passengerIds.length] = travellers[i].id
        }
    }
    initNewTravellerRows();
    return {drivers: driverIds, passengers: passengerIds};
}

function removeRow(id) {
    $('#traveller-' + id).remove();
}

function getEditNameOptions(id) {
    return {
        type: 'text',
        name: 'name',
        url: 'edit_name',
        pk: id,
        title: 'Enter name'
    }
}

function getEditEmailOptions(id) {
    return {
        type: 'text',
        name: 'email',
        url: 'edit_email',
        pk: id,
        title: 'Enter email'
    }
}

function getEditAddressOptions(id) {
    return {
        type: 'text',
        name: 'address',
        url: 'edit_address',
        pk: id,
        title: 'Enter address'
    }
}

function getEditNumPassengersOptions(id) {
    return {
        type: 'text',
        name: 'number_of_passengers',
        url: 'edit_number_of_passengers',
        pk: id,
        title: 'Enter vehicle capacity'
    }
}

function initEditable(travellerIds) {
    if (!$.isEmptyObject(travellerIds)) {
        var i;
        var driverIds = travellerIds.drivers;
        var passengerIds = travellerIds.passengers;

        for (i = 0; i < driverIds.length; i++) {
            $('#name-' + driverIds[i]).editable(getEditNameOptions(driverIds[i]));
            $('#email-' + driverIds[i]).editable(getEditEmailOptions(driverIds[i]));
            $('#address-' + driverIds[i]).editable(getEditAddressOptions(driverIds[i]));
            $('#number_of_passengers-' + driverIds[i]).editable(getEditNumPassengersOptions(driverIds[i]));
        }

        for (i = 0; i < passengerIds.length; i++) {
            $('#name-' + passengerIds[i]).editable(getEditNameOptions(passengerIds[i]));
            $('#email-' + passengerIds[i]).editable(getEditEmailOptions(passengerIds[i]));
            $('#address-' + passengerIds[i]).editable(getEditAddressOptions(passengerIds[i]));
        }
    }

    //init editables
    $('.new-driver').editable({
        url: '/post'
    });

    $('.new-passenger').editable({
        url: '/post'
    });

    $('#new-driver-name').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-driver-email').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-driver-address').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-driver-number_of_passengers').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-passenger-name').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-passenger-email').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    $('#new-passenger-address').editable('option', 'validate', function(v) {
        if(!v) return 'Required field!';
    });

    //automatically show next editable
    $('.new-driver').on('save.newuser', function(){
        var that = this;
        setTimeout(function() {
            $(that).closest('td').next().find('.new-driver').editable('show');
        }, 200);
    });

    //automatically show next editable
    $('.new-passenger').on('save.newuser', function(){
        var that = this;
        setTimeout(function() {
            $(that).closest('td').next().find('.new-passenger').editable('show');
        }, 200);
    });

    $('#save-new-driver').click(function() {
        $('.new-driver').editable('submit', {
            url: 'new_driver',
            ajaxOptions: {
                method: 'POST',
                dataType: 'json' //assuming json response
            },
            success: function(travellers) {
                var travellerIds = updateTravellers(travellers);
                initEditable(travellerIds);
            },
            error: function() {
                alert('error');
            }
        });
    });

    $('#save-new-passenger').click(function() {
        $('.new-passenger').editable('submit', {
            url: 'new_passenger',
            ajaxOptions: {
                method: 'POST',
                dataType: 'json' //assuming json response
            },
            success: function(travellers) {
                var travellerIds = updateTravellers(travellers);
                initEditable(travellerIds);
            },
            error: function(errors) {
                alert('error');
                var msg = '';
                if(errors && errors.responseText) { //ajax error, errors = xhr object
                    msg = errors.responseText;
                } else { //validation error (client-side or server-side)
                    $.each(errors, function(k, v) { msg += k+": "+v+"<br>"; });
                }
                $('#msg').removeClass('alert-success').addClass('alert-error').html(msg).show();
            }
        });
    });
}

$(document).on('ready page:load', function () {
    //toggle `popup` / `inline` mode
    $.fn.editable.defaults.mode = 'popup';
    initNewTravellerRows();
    initEditable({});
    $(window).keydown(function(event){
        if(event.keyCode == 13) {
            event.preventDefault();
            return false;
        }
    });
});