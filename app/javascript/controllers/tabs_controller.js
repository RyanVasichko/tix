import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel", "icon"];
  static values = {
    activeTabClasses: { type: Array, default: ["border-indigo-500", "text-indigo-600"] },
    inactiveTabClasses: {
      type: Array,
      default: ["border-transparent", "text-gray-500", "hover:border-gray-300", "hover:text-gray-700"]
    },
    activeIconClasses: { type: Array, default: ["text-indigo-500"] },
    inactiveIconClasses: { type: Array, default: ["text-gray-400", "group-hover:text-gray-500"] },
    activeTab: { type: Number, default: 0 }
  };

  connect() {
    console.log(this.dataset);
    console.log(this.activeTabValue);
    this.displayActiveTab(this.activeTabValue);
  }

  change(event) {
    event.preventDefault();

    this.activeTabValue = this.tabTargets.indexOf(event.currentTarget);
  }

  activeTabValueChanged() {
    this.displayActiveTab();

    const url = new URL(window.location.href);
    url.searchParams.set("activeTab", this.activeTabValue);
    window.history.replaceState({}, "", url);
  }

  displayActiveTab() {
    this.panelTargets.forEach((el, i) => {
      if (this.activeTabValue == i) {
        el.classList.remove("hidden");
      } else {
        el.classList.add("hidden");
      }
    });

    this.tabTargets.forEach((el, i) => {
      if (this.activeTabValue == i) {
        el.classList.add("border-indigo-500", "text-indigo-600");
        el.classList.remove(...this.inactiveTabClassesValue);
        el.classList.add(...this.activeTabClassesValue);
      } else {
        el.classList.remove("border-indigo-500", "text-indigo-600");
        el.classList.add(...this.inactiveTabClassesValue);
      }
    });

    this.iconTargets.forEach((el, i) => {
      if (this.activeTabValue == i) {
        el.classList.add(...this.activeIconClassesValue);
        el.classList.remove(...this.inactiveIconClassesValue);
      } else {
        el.classList.remove(...this.activeIconClassesValue);
        el.classList.add(...this.inactiveIconClassesValue);
      }
    });
  }
}
