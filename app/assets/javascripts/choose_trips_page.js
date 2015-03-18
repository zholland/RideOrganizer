$(document).on('ready page:load', function () {
    $('#trips-table').tablesorter({
        headers: {
            3: {
                sorter: false
            },
            4: {
                sorter: false
            }
        }
    });
});