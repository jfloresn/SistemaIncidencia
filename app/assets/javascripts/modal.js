function modal(id, contentBody, title, onClickOkButton, visibleButtons, sizePopup) {
    var modal = document.createElement('div');
    modal.id = id;
    modal.setAttribute("tabindex", "-1");
    modal.setAttribute("role", "dialog");
    modal.setAttribute("aria-labelledby", "myModalLabel");
    modal.setAttribute("aria-hidden", "true");
    modal.className = 'modal fade';

    var modalDialog = document.createElement('div');
    modalDialog.className = 'modal-dialog';
    // modalDialog.setAttribute("role", "document");

    switch (sizePopup) {
        case 1:
            modalDialog.className += ' modal-sm';
            break;
        case 2:
            modalDialog.className += ' modal-md';
            break;
        case 3:
            modalDialog.className += ' modal-lg';
            break;
    }

    var modalContent = document.createElement('div');
    modalContent.className = 'modal-content';

    var modalHeader = document.createElement('div');
    modalHeader.className = "modal-header";

    var modalTitle = document.createElement('h5');
    modalTitle.className = "modal-title";
    modalTitle.innerHTML = title;


    // var button = document.createElement("button");
    // button.("close");
    // button.setAttribute("aria-hidden", "true");
    // button.setAttribute("data-dismiss", "modal");
    // button.InnerHtml = "<span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Cerrar</span>";
    // // modalHeader.InnerHtml = string.Concat(button, modalTitle);
    // button.appendChild(modalTitle);
    modalHeader.appendChild(modalTitle);

    var modalBody = document.createElement("div");
    modalBody.id = (contentBody);
    modalBody.className = "modal-body";

    var modalFooter = document.createElement("div");
    modalFooter.className = "modal-footer";

    var buttonCancel = document.createElement("input");
    buttonCancel.className = "btn buttonsModal  btn-default";
    buttonCancel.setAttribute("type", "button");
    buttonCancel.setAttribute("data-dismiss", "modal");
    buttonCancel.setAttribute("value", "Cancelar");

    var buttonok = document.createElement("input");
    buttonok.className = "btn buttonsModal btn-primary";
    buttonok.setAttribute("type", "button");
    buttonok.setAttribute("onClick", onClickOkButton);
    buttonok.setAttribute("value", "Aceptar");


    modalFooter.appendChild(buttonCancel);
    modalFooter.appendChild(buttonok);

    if (visibleButtons) {

        modalFooter.appendChild(buttonCancel);
        modalFooter.appendChild(buttonok);

        modalContent.appendChild(modalHeader);
        modalContent.appendChild(modalBody);
        modalContent.appendChild(modalFooter);

        // modalFooter.InnerHtml = string.Concat(buttonCancel.ToString(), buttonok.ToString());
        // modalContent.InnerHtml = string.Concat(modalHeader.ToString(), modalBody.ToString(), modalFooter.ToString());
    } else {
        modalContent.appendChild(modalHeader);
        modalContent.appendChild(modalBody);
        // modalContent.InnerHtml = string.Concat(modalHeader.ToString(), modalBody.ToString());
    }

    modalDialog.appendChild(modalContent);


    modal.appendChild(modalDialog);

    var workspace = document.getElementById('workspace');
    workspace.appendChild(modal);
}