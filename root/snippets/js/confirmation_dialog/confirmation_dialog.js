async function confirmationDialog() {
	return new Promise((resolve) => {

		var overlay = document.createElement("div");
		overlay.style.position = "fixed";
		overlay.style.top = "0";
		overlay.style.left = "0";
		overlay.style.width = "100%";
		overlay.style.height = "100%";
		overlay.style.backgroundColor = "rgba(0,0,0,0.5)";
		overlay.style.zIndex = "10000";

		var modal = document.createElement("div");
		modal.style.minWidth = "{modal_width}";
		modal.style.minHeight = "{modal_height}";
		modal.style.backgroundColor = "{modal_bg_color}";
		modal.style.color = "{modal_text_color}";
		modal.style.position = "fixed";
		modal.style.top = "50%";
		modal.style.left = "50%";
		modal.style.transform = "translate(-50%, -50%)";
		modal.style.padding = "20px";
		modal.style.borderRadius = "8px";
		modal.style.boxShadow = "0 2px 10px rgba(0, 0, 0, 0.1)";
		modal.style.maxWidth = "80%";
		modal.style.maxHeight = "80%";
		modal.style.overflowY = "auto";
		modal.style.display = "flex";
		modal.style.flexDirection = "column";
		modal.style.zIndex = "10001";

		var modalTitle = document.createElement("h2");
		modalTitle.textContent = "{title_text}";
		modalTitle.style.color = "{title_text_color}";
		modalTitle.style.margin = "0 0 5px 0";

		var modalSubtitle = document.createElement("h3");
		modalSubtitle.textContent = "{subtitle_text}";
		modalSubtitle.style.color = "{subtitle_text_color}";
		modalSubtitle.style.margin = "0 0 15px 0";

		var textArea = document.createElement("textarea");
		textArea.readOnly = {textarea_readonly};
		textArea.value = "{textarea_text}";
		textArea.placeholder = "{textarea_placeholder}";
		textArea.style.backgroundColor = "{textarea_bg_color}";
		textArea.style.color = "{textarea_text_color}";
		textArea.style.border = "2px solid #666";
		textArea.style.boxSizing = "border-box";
		textArea.style.width = "100%";
		textArea.style.minHeight = "50px";
		textArea.style.padding = "10px";
		textArea.style.borderRadius = "4px";
		textArea.style.resize = "none";
		textArea.style.flexGrow = "1";
		textArea.onclick = function() { this.select(); };
				
		modal.appendChild(modalTitle);
		modal.appendChild(modalSubtitle);
		modal.appendChild(textArea);

		var buttonContainer = document.createElement("div");
		buttonContainer.style.marginTop = "20px";
		buttonContainer.style.overflow = "hidden";

		var acceptButton = document.createElement("button");
		acceptButton.textContent = "{accept_button_text}";
		acceptButton.style.backgroundColor = "{accept_button_bg_color}";
		acceptButton.style.color = "{accept_button_text_color}";
		acceptButton.style.border = "none";
		acceptButton.style.padding = "10px 20px";
		acceptButton.style.borderRadius = "5px";
		acceptButton.style.float = "left";
		acceptButton.style.margin = "4px";

		var cancelButton = document.createElement("button");
		cancelButton.textContent = "{cancel_button_text}";
		cancelButton.style.backgroundColor = "{cancel_button_bg_color}";
		cancelButton.style.color = "{cancel_button_text_color}";
		cancelButton.style.border = "none";
		cancelButton.style.padding = "10px 20px";
		cancelButton.style.borderRadius = "5px";
		cancelButton.style.float = "right";
		cancelButton.style.margin = "4px";

		acceptButton.onclick = function() {
			window.textAreaResult = textArea.value;
			resolve(window.textAreaResult);
			document.body.removeChild(modal);
			document.body.removeChild(overlay);
		};
		cancelButton.onclick = function() {
			window.textAreaResult = "";
			resolve(window.textAreaResult);
			document.body.removeChild(modal);
			document.body.removeChild(overlay);
		};

		acceptButton.addEventListener('mouseover', function() {
			acceptButton.style.backgroundColor = "{accept_button_bg_hover_color}";
			acceptButton.style.outline = "2px solid white"; 
		});
		acceptButton.addEventListener('mouseout', function() {
			acceptButton.style.backgroundColor = "{accept_button_bg_color}";
			acceptButton.style.outline = "none"; 
		});
		cancelButton.addEventListener('mouseover', function() {
			cancelButton.style.backgroundColor = "{cancel_button_bg_hover_color}";
			cancelButton.style.outline = "2px solid white";
		});
		cancelButton.addEventListener('mouseout', function() {
			cancelButton.style.backgroundColor = "{cancel_button_bg_color}";
			cancelButton.style.outline = "none"; 
		});

		buttonContainer.appendChild(acceptButton);
		buttonContainer.appendChild(cancelButton);

		modal.appendChild(buttonContainer);

		document.body.appendChild(overlay);
		document.body.appendChild(modal);
		
		document.documentElement.style.fontSize = "{font_size}";
		acceptButton.style.fontSize = "1rem";
		cancelButton.style.fontSize = "1rem";
		textArea.style.fontSize = "1rem";

		if ({textarea_readonly}) {
			acceptButton.focus();
		} else {
			textArea.focus();
		}
	});
}

confirmationDialog();
