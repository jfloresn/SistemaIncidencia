function controllerPostAction(url, data, controlContent, showLoading, hideLoading, functionOnSucess) {
    controllerGenericAction("POST", url, JSON.stringify(data), "html", controlContent, showLoading, hideLoading, functionOnSucess);
}

function controllerGetAction(url, data, controlContent, showLoading, hideLoading, functionOnSucess) {
    controllerGenericAction("GET", url, data, "html", controlContent, showLoading, hideLoading, functionOnSucess);
}

function controllerSaveAction(url, data, showLoading, hideLoading, functionOnSucess) {
    controllerGenericAction("POST", url, JSON.stringify(data), "json", "", showLoading, hideLoading, functionOnSucess);
}

function controllerGenericAction(type, url, data, dataType, controlContent, showLoading, hideLoading, functionOnSucess) {
    debugger;
    $.ajax({
        beforeSend: function() {
            if (showLoading == true)
                $("#ajaxLoadingPanel").show();
        },
        complete: function() {
            if (hideLoading == true)
                setTimeout(function() {
                    $("#ajaxLoadingPanel").hide();
                }, 200);
        },
        type: type,
        contentType: "application/json; charset=utf-8",
        url: url,
        data: data,
        dataType: dataType,
        success: function(response, textStatus, jqXHR) {
            debugger;
            if (controlContent != "")
                $("#" + controlContent).html(response);

            if (typeof functionOnSucess == 'function')
                functionOnSucess(response);
        },
        error: function(xhr, status, error) {
            if (error.toString() == "")
                error = xhr.statusText;
            // MsgAlert(3, error.toString());
            $(".messageError").show();
            $(".messageError").html(error.toString());
            setTimeout(function() { $(".messageError").hide(); }, 2000);
        }
    });
}

function message(type, message) {
    // 1: success
    // 2: information
    // 3: error
    switch (type) {
        case 1:
            $(".messageSuccess").show();
            $(".messageSuccess").html(message);
            setTimeout(function() { $(".messageSuccess").hide(); }, 2000);
            break;
        case 2:
            $(".messageInformation").show();
            $(".messageInformation").html(message);
            setTimeout(function() { $(".messageInformation").hide(); }, 2000);
            break;
        case 3:
            $(".messageError").show();
            $(".messageError").html(message);
            setTimeout(function() { $(".messageError").hide(); }, 2000);
            break;
    }
}

/*Estado Incidencia Formatter*/
function EstadoIncidenciaFormatter(cellvalue, options, rowObject) {
    switch (rowObject.codigoEstadoIncidencia) {
        case "01":
            return '<div class="rowFormat" style="background: #E99630;border:1px solid #716D2E;">' + cellvalue + '</div>';
        case "02":
            return '<div class="rowFormat" style="background: #50ADCC;border:1px solid #296B68;">' + cellvalue + '</div>';
        case "03":
            return '<div class="rowFormat" style="background: #3B7ABA;border:1px solid #40549C;">' + cellvalue + '</div>';
        case "04":
            return '<div class="rowFormat" style="background: #4FA243;border:1px solid #174D1F;">' + cellvalue + '</div>';
        case "05":
            return '<div class="rowFormat" style="background: #D1443A;border:1px solid #128913;">' + cellvalue + '</div>';
        default:
            return '<div>' + cellvalue + '</div>';
    }
};

function EstadoIncidenciaUnformatter(cellvalue, options) {
    return $(cellvalue).text();
};

/*Estado Aprobacion Incidencia Formatter*/
function EstadoAprobacionIncidenciaFormatter(cellvalue, options, rowObject) {
    switch (rowObject.codigoEstadoAproIncidencia) {
        case "01":
            return '<div class="rowFormat" style="background: #E99630;border:1px solid #716D2E;">' + cellvalue + '</div>';
        case "02":
            return '<div class="rowFormat" style="background: #4FA243;border:1px solid #174D1F;">' + cellvalue + '</div>';
        case "03":
            return '<div class="rowFormat" style="background: #D1443A;border:1px solid #9C4040;">' + cellvalue + '</div>';
        case "04":
            return '<div class="rowFormat" style="background: #4FA243;border:1px solid #174D1F;">' + cellvalue + '</div>';
        default:
            return '<div>' + cellvalue + '</div>';
    }
};

function EstadoAprobacionIncidenciaUnformatter(cellvalue, options) {
    return $(cellvalue).text();
};

function nobackbutton() {
    window.location.hash = "no-back-button";
    window.location.hash = "Again-No-back-button" //chrome
    window.onhashchange = function() { window.location.hash = "no-back-button"; }

}