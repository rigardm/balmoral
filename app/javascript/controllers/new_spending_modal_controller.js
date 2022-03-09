import { Controller } from "@hotwired/stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {
  static targets = ["newSpendingOverlay", "newSpendingModal", "openSpendingButton", "reset", "form"]

    connect() {
      // console.log("Hello from our first Stimulus controller")
      console.log(this.formTarget.action)
    }

    show(event) {
      this.newSpendingModalTarget.classList.remove('d-none');
      this.newSpendingOverlayTarget.classList.remove('d-none');
      }

    close(event) {
      this.newSpendingModalTarget.classList.add('d-none');
      this.newSpendingOverlayTarget.classList.add('d-none');
    }

    async submit(evt) {
      const options = {
        method: 'POST',
        headers: { accept: 'application/json', "X-CSRF-Token": csrfToken() },
        body: new FormData(this.formTarget)
      }

      const response = await fetch(this.formTarget.action, options);
      const data = await response.json();

      if (data.valid) {
        this.close();
        document.querySelector('#spendings').insertAdjacentHTML('afterbegin', data.spending)
      } else {
        this.formTarget.outerHTML = data.html
      }
    }
  }
