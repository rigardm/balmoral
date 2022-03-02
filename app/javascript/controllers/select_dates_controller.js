import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "body"]

  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
      });
      const arrival = event.currentTarget;
      arrival.classList.add("new-booking");
      this.bodyTarget.dataset.click = 'departure';
    } else {
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if (departureDate >= arrivalDate) {
        // Departure is after arrival, so we can proceed with the booking
        this.dateTargets.forEach((date)=>{
          if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
            date.classList.add("new-booking");
          }
        });
        this.bodyTarget.dataset.arrivalDate = arrivalDate
        this.bodyTarget.dataset.departureDate = departureDate
      } else {
        // Departure is before arrival, we need to reset the calendar
        arrival.classList.remove('new-booking');
      }
      this.bodyTarget.dataset.click = 'arrival';
    }
  }
}
