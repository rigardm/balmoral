import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello from our first Stimulus controller")
  }

  static targets = ["newSpendingOverlay", "newSpendingModal", "openSpendingButton", "reset"]

  show(event) {
    this.newSpendingModalTarget.classList.remove('d-none');
    this.newSpendingOverlayTarget.classList.remove('d-none');
    }

  close(event) {
    this.newSpendingModalTarget.classList.add('d-none');
    this.newSpendingOverlayTarget.classList.add('d-none');
  }
  }
