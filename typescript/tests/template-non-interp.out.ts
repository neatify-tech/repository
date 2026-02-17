export {};
const templateEnabled = true;
const templateRunning = true;
function templateNonInterpOuter() {
	if (templateEnabled) {
		while (templateRunning) {
			const template = `alpha
   beta
     gamma`;
			return template;
		}
	}
}
