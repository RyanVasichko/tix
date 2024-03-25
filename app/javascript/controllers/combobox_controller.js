import ApplicationController from "controllers/application_controller";
import debounce from "debounce";

// Connects to data-controller="combobox"
export default class extends ApplicationController {
  static targets = ["optionsList", "option", "optionCheck", "optionLabel", "input", "hiddenField"];

  connect() {
    super.connect();
    this.createIndex();

    if (this.hiddenFieldTarget.value) {
      const comboboxParams = {
        optionValue: this.hiddenFieldTarget.value,
        optionLabel: this.optionLabelTargets.find((ol) => ol.dataset.optionValue == this.hiddenFieldTarget.value).innerText
      };
      this.optionSelected({ params: comboboxParams });
    }
  }

  createIndex() {
    this.index = new Map();
    this.optionTargets.forEach((option) => {
      const text = option.innerText.toLowerCase();
      if (!this.index.has(text)) {
        this.index.set(text, []);
      }
      this.index.get(text).push(option);
    });
  }

  filter() {
    const filterValue = this.inputTarget.value.toLowerCase();
    this.index.forEach((elements, text) => {
      const isVisible = text.includes(filterValue);
      elements.forEach(element => {
        element.classList.toggle("hidden", !isVisible);
      });
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
