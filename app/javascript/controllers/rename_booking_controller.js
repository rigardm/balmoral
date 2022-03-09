import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["displayForm", "currentInfo", "currentFooter", "displayFooter", "form"]

  form(event) {
    this.currentInfoTarget.classList.add("d-none");
    if (this.hasDisplayFormTarget) {
      this.displayFormTarget.classList.remove("d-none");
    }
    if (this.hasCurrentFooterTarget) {
      this.currentFooterTarget.classList.add("d-none");
    }
    if (this.hasDisplayFooterTarget) {
      this.displayFooterTarget.classList.remove("d-none");
    }
  }

  submit() {
    if (this.hasDisplayFormTarget) {
      this.formTarget.submit();
    }
    this.currentInfoTarget.classList.remove("d-none");
    if (this.hasDisplayFormTarget) {
      this.displayFormTarget.classList.add("d-none");
    }
      if (this.hasCurrentFooterTarget) {
      this.currentFooterTarget.classList.remove("d-none");
    }
      if (this.hasDisplayFooterTarget) {
      this.displayFooterTarget.classList.add("d-none");
    }
  }

  clear() {
    this.currentInfoTarget.classList.remove("d-none");
    if (this.hasDisplayFormTarget) {
      this.displayFormTarget.classList.add("d-none");
    }
    if (this.hasCurrentFooterTarget) {
      this.currentFooterTarget.classList.remove("d-none");
    }
    if (this.hasDisplayFooterTarget) {
      this.displayFooterTarget.classList.add("d-none");
    }
  }
}
