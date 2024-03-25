import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="admin--ticket-types-form"
export default class extends Controller {
  static targets = [ "flatRateConvenienceFeeLabel", "percentageConvenienceFeeLabel", "convenienceFeeTypeSelect", "convenienceFeeInput" ];

  connect() {
  }

  customizeInputsForConvenienceFeeType() {
    if (this.convenienceFeeTypeSelectTarget.value === "flat_rate") {
      this.flatRateConvenienceFeeLabelTarget.classList.remove("hidden");
      this.percentageConvenienceFeeLabelTarget.classList.add("hidden");
      this.convenienceFeeInputTarget.classList.add("pl-6");
      this.convenienceFeeInputTarget.value = Math.floor(this.convenienceFeeInputTarget.value) + ".00";
    } else {
      this.flatRateConvenienceFeeLabelTarget.classList.add("hidden");
      this.percentageConvenienceFeeLabelTarget.classList.remove("hidden");
      this.convenienceFeeInputTarget.classList.remove("pl-6");
      this.convenienceFeeInputTarget.value = Math.floor((this.convenienceFeeInputTarget.value * 100) / 100);
    }
  }
}
