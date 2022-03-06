import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["bookingOverlay", "bookingModal", "openBookingButton", "reset"]

  openBookingModal() {
    this.bookingModalTarget.classList.remove('d-none');
    this.bookingOverlayTarget.classList.remove('d-none');
    // ideally, we should check if openBookingButtonTarget exists or not
    this.openBookingButtonTarget.classList.add('d-none');
    }

  closeBookingModal() {
    const renameBookingController = this.application.getControllerForElementAndIdentifier(this.resetTarget, 'rename-booking');
    renameBookingController.clear();
    this.bookingModalTarget.classList.add('d-none');
    this.bookingOverlayTarget.classList.add('d-none');
    // ideally, we should check if openBookingButtonTarget exists or not
    this.openBookingButtonTarget.classList.remove('d-none');
  }
}
