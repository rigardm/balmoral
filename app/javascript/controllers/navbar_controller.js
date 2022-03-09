import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "home", "messages", "calendar", "spendings" ]

  connect() {
    this.homeTarget.classList.remove('selected-nav');
    this.messagesTarget.classList.remove('selected-nav');
    this.calendarTarget.classList.remove('selected-nav');
    this.spendingsTarget.classList.remove('selected-nav');
    if (document.URL.match(/calendar|booking/)) {
      this.calendarTarget.classList.add('selected-nav');
    } else if (document.URL.includes('channel')) {
      this.messagesTarget.classList.add('selected-nav');
    } else if (document.URL.includes('spending')) {
      this.spendingsTarget.classList.add('selected-nav');
    } else {
      this.homeTarget.classList.add('selected-nav');
    }
  }
}
