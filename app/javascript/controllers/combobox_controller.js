import ApplicationController from "./application_controller";

// Connects to data-controller="combobox"
export default class extends ApplicationController {
  static targets = ["optionsList", "option", "optionCheck", "optionLabel", "input", "hiddenField"];

  connect() {
    super.connect();
  }

  filter() {
    const filterValue = this.inputTarget.value.toLowerCase();
    this.optionTargets.forEach((t) => {
      const containsText = t.innerText.toLowerCase().includes(filterValue);
      if (containsText) {
        t.classList.remove("hidden");
      } else {
        t.classList.add("hidden");
      }
    });
  }

  resetFilter() {
    this.optionTargets.forEach((t) => {
      t.classList.remove("hidden");
    });
  }

  optionSelected({ params }) {
    this.selectedOptionLabel = params.optionLabel;

    this.optionCheckTargets.forEach((oc) => {
      if (oc.dataset.optionValue == params.optionValue) {
        oc.classList.remove("hidden");
      } else {
        oc.classList.add("hidden");
      }
    });

    this.optionLabelTargets.forEach((ol) => {
      if (ol.dataset.optionValue == params.optionValue) {
        ol.classList.add("font-semibold");
      } else {
        ol.classList.remove("font-semibold");
      }
    });

    this.inputTarget.value = this.selectedOptionLabel;
    this.hiddenFieldTarget.value = params.optionValue;
    this.resetFilter();
    this.hideOptions();
  }

  showOptions() {
    this.filter();
    this.optionsListTarget.classList.remove("hidden");
  }

  hideOptionsOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.hideOptions();
    }

    this.inputTarget.value = this.selectedOptionLabel || '';
  }

  hideOptions() {
    this.optionsListTarget.classList.add("hidden");
  }

  toggleOptions() {
    if (this.optionsListTarget.classList.contains("hidden")) {
      this.showOptions();
    } else {
      this.hideOptions();
    }
  }

  focusInput() {
    this.inputTarget.focus();
  }
}
