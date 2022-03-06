import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bookingPreviewOverlay", "bookingPreviewModal", "bookingPreviewButton"]

  openBookingPreviewModal(event) {
    this.bookingPreviewModalTarget.classList.remove('d-none');
    this.bookingPreviewOverlayTarget.classList.remove('d-none');
    this.bookingPreviewButtonTarget.classList.add('d-none');
  }

  closeBookingPreviewModal() {
    this.bookingPreviewModalTarget.classList.add('d-none');
    this.bookingPreviewOverlayTarget.classList.add('d-none');
    this.bookingPreviewButtonTarget.classList.remove('d-none');
  }
}
