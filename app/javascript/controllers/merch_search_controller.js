import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="merch-search"
export default class extends Controller {
  static targets = ["allCheckbox", "categoryIdCheckbox"];

  uncheckCategoriesIfAllSelected() {
    if (this.allCheckboxTarget.checked) {
      this.categoryIdCheckboxTargets.forEach((checkbox) => {
        checkbox.checked = false;
      });
    }
  }

  uncheckAllIfCategorySelected() {
    this.allCheckboxTarget.checked = !this.categoryIdCheckboxTargets.some((checkbox) => checkbox.checked);
  }

  submitForm() {
    this.element.requestSubmit();
  }
}
