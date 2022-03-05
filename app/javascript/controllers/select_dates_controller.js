import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "body", "button", "arrival", "departure", "form", "modalInfo", "bookingPreview", "previewButton"]
  static values = { dailyPrice: Number }

  connect() {
    const today = document.querySelector('[class*="today"]');
    const day_display = parseInt(today.dataset.date.slice(-2), 10);
    today.insertAdjacentHTML('beforeend', `<div class="day-today">${day_display}</div>`);
  }

  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      // the user may have selected an arrival date
      this.buttonTarget.classList.add('d-none');
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
        if (date.lastChild.className === "meeting-proposed") {
          date.removeChild(date.lastChild);
        };
        //.forEach(element => element.remove);
      });
      const arrival = event.currentTarget;
      if (!arrival.classList.contains("has-events")) {
        arrival.classList.add("new-booking");
        const day_display = parseInt(arrival.dataset.date.slice(-2), 10);
        arrival.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
        this.bodyTarget.dataset.click = 'departure';
      } else {
        // the user has clicked on an existing booking
        // retrieve the récupérer l'id du booking correspondant:
        const bookingId = event.target.dataset.bookingId;
        // fetcher
        const url = `/bookings/find?id=${bookingId}`
        fetch(url, {
          headers: {
            "Accept": "application/json"
          }
        })
        .then(response => response.json())
        .then((data) => {
          // insert booking_preview partial with booking inside preview modal
          this.bookingPreviewTarget.innerHTML = data.html;
        });
        // afficher la modale
        this.previewButtonTarget.click();
      }
    } else {
      // the user may have selected a departure date
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if ((departureDate >= arrivalDate)&&(this.#notAlreadyBooked(arrivalDate, departureDate))) {
        // Departure is after arrival and the period is not already booked
        // So we can proceed with the booking
        this.dateTargets.forEach((date)=>{
          if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
            date.classList.add("new-booking");
            const day_display = parseInt(date.dataset.date.slice(-2), 10);
            date.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
          }
        });
        this.buttonTarget.classList.remove('d-none');
        this.arrivalTarget.value = arrivalDate;
        this.departureTarget.value = departureDate;
        // insert HTML in the modal info:
        const arrDate = new Date(arrivalDate);
        const depDate = new Date(departureDate);
        const arr = arrDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const dep = depDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
        const totalPrice = ((depDate - arrDate) / (60000 * 60 * 24) + 1) * this.dailyPriceValue;
        const html = `
          <div class="row">
            <div class="col-12">
              <h3>Votre réservation</h3>
            </div>
          </div>
          <div class="row">
            <div class="col-2">
              Du
            </div>
            <div class="col-10 text-start">
              ${arr}
            </div>
          </div>
          <div class="row">
            <div class="col-2">
              Au
            </div>
            <div class="col-10 text-start">
              ${dep}
            </div>
          </div>
          <div class="row">
            <div class="col-2">
              <i class="fas fa-key"></i>
            </div>
            <div class="col-10 text-start">
              ${totalPrice} (résa)
            </div>
          </div>
        `;
        this.modalInfoTarget.insertAdjacentHTML('afterbegin', html);
      } else {
        // Departure is before arrival or it is already booked
        // So we need to reset the calendar
        arrival.classList.remove('new-booking');
        arrival.removeChild(arrival.lastChild);
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

  submit() {
    this.formTarget.submit();
  }
}
