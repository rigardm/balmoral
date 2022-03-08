import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["displayForm", "currentInfo", "currentFooter", "displayFooter", "form"]

  form(event) {
    this.currentInfoTarget.classList.add("d-none");
    this.displayFormTarget.classList.remove("d-none");
    this.currentFooterTarget.classList.add("d-none");
    this.displayFooterTarget.classList.remove("d-none");
  }

  submit() {
    this.formTarget.submit();
    this.currentInfoTarget.classList.remove("d-none");
    this.displayFormTarget.classList.add("d-none");
    this.currentFooterTarget.classList.remove("d-none");
    this.displayFooterTarget.classList.add("d-none");
  }

  clear() {
    this.currentInfoTarget.classList.remove("d-none");
    this.displayFormTarget.classList.add("d-none");
    this.currentFooterTarget.classList.remove("d-none");
    this.displayFooterTarget.classList.add("d-none");
  }
}
