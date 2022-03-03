import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "body", "button"]

  connect() {
    const today = document.querySelector('[class*="today"]');
    const day_display = parseInt(today.dataset.date.slice(-2), 10);
    today.insertAdjacentHTML('beforeend', `<div class="day-today">${day_display}</div>`);
  }


  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      this.buttonTarget.classList.add('d-none');
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
        if (date.lastChild.className === "meeting-proposed") {
          date.removeChild(date.lastChild);
        };
        //.forEach(element => element.remove);
      });
      const arrival = event.currentTarget;
      arrival.classList.add("new-booking");
      const day_display = parseInt(arrival.dataset.date.slice(-2), 10);
      arrival.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
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
           const day_display = parseInt(date.dataset.date.slice(-2), 10);
           date.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
          }
        });
        this.bodyTarget.dataset.arrivalDate = arrivalDate;
        this.bodyTarget.dataset.departureDate = departureDate;
        this.buttonTarget.classList.remove('d-none');
      } else {
        // Departure is before arrival, we need to reset the calendar
        arrival.classList.remove('new-booking');
          arrival.removeChild(arrival.lastChild);
      }
      this.bodyTarget.dataset.click = 'arrival';
    }
  }
}
