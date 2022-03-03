import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "body", "button"]

  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      // the user has selected an arrival date
      this.buttonTarget.classList.add('d-none');
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
      });
      const arrival = event.currentTarget;
      if (!arrival.classList.contains("has-events")) {
        arrival.classList.add("new-booking");
        this.bodyTarget.dataset.click = 'departure';
      }
    } else {
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if ((departureDate >= arrivalDate)&&(this.#notAlreadyBooked(arrivalDate, departureDate))) {
        // Departure is after arrival and the period is not already booked
        // So we can proceed with the booking
        this.dateTargets.forEach((date)=>{
          if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
            date.classList.add("new-booking");
          }
        });
        this.bodyTarget.dataset.arrivalDate = arrivalDate;
        this.bodyTarget.dataset.departureDate = departureDate;
        this.buttonTarget.classList.remove('d-none');
      } else {
        // Departure is before arrival or it is already booked
        // So we need to reset the calendar
        arrival.classList.remove('new-booking');
      }
      this.bodyTarget.dataset.click = 'arrival';
    }
  }

    #notAlreadyBooked = ((arrivalDate, departureDate) => {
    let notBooked = true;
    this.dateTargets.forEach((date)=>{
      if ((date.dataset.date>=arrivalDate)&&(date.dataset.date<=departureDate)) {
        if (date.classList.contains('has-events')) {
          notBooked = false;
        }
      }
    });
    return notBooked;
  });
}
