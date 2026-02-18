				document.querySelectorAll("button.toggle")					.forEach(function (btn) {			btn.addEventListener("click", function () {
						setView(btn.getAttribute("data-view"));
					});
				});
