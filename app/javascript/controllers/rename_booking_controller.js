import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["displayform", "currentinfo", "currentfooter","displayfooter","form"]

  form(event) {
  this.currentinfoTarget.classList.add("d-none");
  this.displayformTarget.classList.remove("d-none");
  this.currentfooterTarget.classList.add("d-none");
  this.displayfooterTarget.classList.remove("d-none");
  }

  submit() {
    this.formTarget.submit();
    this.currentinfoTarget.classList.remove("d-none");
    this.displayformTarget.classList.add("d-none");
    this.currentfooterTarget.classList.remove("d-none");
    this.displayfooterTarget.classList.add("d-none");
  }

  clear() {
    this.currentinfoTarget.classList.remove("d-none");
    this.displayformTarget.classList.add("d-none");
    this.currentfooterTarget.classList.remove("d-none");
    this.displayfooterTarget.classList.add("d-none");
  }
}
