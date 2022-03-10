import { Controller } from "@hotwired/stimulus"
import { flashesFadeOut } from '../components/flashes'

export default class extends Controller {
  static targets = [
    "date",
    "body",
    "bookButton",
    "arrival",
    "departure",
    "form",
    "modalInfo",
    "existingBookingModal",
    "existingBookingContainer",
    "newBookingModal",
    "newBookingOverlay"
  ]
  static values = {
    dailyPrice: Number,
    tribeCreditBalance: Number
   }

  connect() {
    const today = document.querySelector('[class*="today"]');
    if (today) {
      const day_display = parseInt(today.dataset.date.slice(-2), 10);
      today.insertAdjacentHTML('beforeend', `<div class="day-today">${day_display}</div>`);
    }
  }

  select(event) {
    if (this.bodyTarget.dataset.click === 'arrival') {
      // this is the FIRST click on the calendar
      // the user may have selected an arrival date
      this.bookButtonTarget.classList.add('d-none');
      this.modalInfoTarget.innerHTML = "";
      this.dateTargets.forEach((date)=>{
        date.classList.remove("new-booking");
        if (date.lastChild.className === "meeting-proposed") {
          date.removeChild(date.lastChild);
        };
      });
      const arrival = event.currentTarget;
      if (!arrival.classList.contains("has-events")) {
        // the user has not clicked on a booking
        arrival.classList.add("new-booking");
        const day_display = parseInt(arrival.dataset.date.slice(-2), 10);
        arrival.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
        this.bodyTarget.dataset.click = 'departure';
      } else {
        // the user has clicked on an existing booking
        // retrieve the corresponding booking id
        const bookingId = event.target.dataset.bookingId;
        // fetch simple_booking_modal partial
        const url = `/bookings/find?id=${bookingId}`
        fetch(url, {
          headers: {
            "Accept": "application/json"
          }
        })
        .then(response => response.json())
        .then((data) => {
          // insert simple_booking_modal with booking into the booking_modal empty div
          this.existingBookingModalTarget.innerHTML = data.html;
        });
        // display the modal
        const bookingModalController = this.application.getControllerForElementAndIdentifier(this.existingBookingContainerTarget, 'booking-modal');
        bookingModalController.openBookingModal();
      }
    } else {
      // this is the SECOND click. The user may have selected a departure date
      const arrival = document.querySelector('.new-booking')
      const arrivalDate = arrival.dataset.date;
      const departureDate = event.currentTarget.dataset.date;
      if ((departureDate >= arrivalDate)&&(this.#notAlreadyBooked(arrivalDate, departureDate))) {
        // Departure is after arrival and the period is not already booked
        // HERE: now we need to check if credits are sufficient for the booking.
        const arrDate = new Date(arrivalDate);
        const depDate = new Date(departureDate);
        const totalPrice = ((depDate - arrDate) / (60000 * 60 * 24) + 1) * this.dailyPriceValue;
        const creditBalance = this.tribeCreditBalanceValue;
        if (creditBalance >= totalPrice) {
          // credits are sufficient to book - so we can proceed with the booking in 4 steps
          // 1. highlight dates in the booking
          this.dateTargets.forEach((date)=>{
            if ((date.dataset.date>arrivalDate)&&(date.dataset.date<=departureDate)) {
              date.classList.add("new-booking");
              const day_display = parseInt(date.dataset.date.slice(-2), 10);
              date.insertAdjacentHTML('beforeend', `<div class="meeting-proposed">${day_display}</div>`);
            }
          });
          // 2. show the book button ("RESERVER"). If user click on the button, the new booking modal will show
          this.bookButtonTarget.classList.remove('d-none');
          // 3. fill in the invisible form contained in the new booking modal to create the booking
          this.arrivalTarget.value = arrivalDate;
          this.departureTarget.value = departureDate;
          // 4. insert HTML in the new booking modal as a new booking recap
          const html = this.#fillBookingModal(arrDate, depDate, totalPrice, creditBalance);
          this.modalInfoTarget.insertAdjacentHTML('afterbegin', html);
        } else {
          // HERE: credits are not sufficient enough.
          // window.alert("Crédits insuffisants. Choisissez de nouvelles dates.")
          const alert_html = `
          <div class="flash alert alert-info alert-dismissible fade show m-1" role="alert">
            <div class = "babeth">Babeth II (Balmoral)</div>
            Banane: Crédits insuffisants. Choisissez de nouvelles dates.
          </div>
          `
          this.element.insertAdjacentHTML('afterend', alert_html);
          flashesFadeOut();
          arrival.classList.remove('new-booking');
          arrival.removeChild(arrival.lastChild);}
      } else {
        // Departure is before arrival or it is already booked
        // So we need to reset the calendar
        if(!this.#notAlreadyBooked(arrivalDate, departureDate)) {
          const alert_html = `
          <div class="flash alert alert-info alert-dismissible fade show m-1" role="alert">
            <div class = "babeth">Babeth II (Balmoral)</div>
            Il y a déjà une réservation. Choisissez d'autres dates.
          </div>
          `
          this.element.insertAdjacentHTML('afterend', alert_html);
          flashesFadeOut();
        }
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

  newBookingModalShow(event) {
    event.preventDefault();
    this.newBookingModalTarget.classList.remove('d-none');
    this.newBookingOverlayTarget.classList.remove('d-none');
  }

  submit() {
    this.newBookingModalTarget.classList.add('d-none');
    this.newBookingOverlayTarget.classList.add('d-none');
    this.formTarget.submit();
  }

  cancel() {
    window.location.reload();
  }

  #fillBookingModal(arrDate, depDate, totalPrice, creditBalance) {
    const arr = arrDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
    const dep = depDate.toLocaleString('fr-FR', { weekday:"long", day: '2-digit', month: 'long' });
    const nb_of_days = ((depDate - arrDate) / (60000 * 60 * 24) + 1);
    const bookingInfoHtml = `
    <h1 class="text-center px-3 py-1 mt-4 mb-3">Votre réservation</h1>
    <div class="d-flex flex-column align-items-center px-3 py-1">
      <div class="calendar-simple booking-content">
        <?xml version="1.0" encoding="UTF-8"?>
        <svg width="28px" height="25px" viewBox="0 0 35 37" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
          <!-- Generator: Sketch 50.2 (55047) - http://www.bohemiancoding.com/sketch -->
          <title>calendar</title>
          <desc>Created with Sketch.</desc>
          <defs></defs>
          <g id="Vivid.JS" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
            <g id="Vivid-Icons" transform="translate(-122.000000, -409.000000)">
              <g id="Icons" transform="translate(37.000000, 169.000000)">
                <g id="calendar" transform="translate(78.000000, 234.000000)">
                  <g transform="translate(7.000000, 6.000000)" id="Shape">
                    <polygon fill="#FBC24C" points="0 37 0 3.009 35 3.009 35 37"></polygon>
                    <path d="M3.007,13.013 L7.991,13.013 L7.991,18 L3.007,18 L3.007,13.013 Z M10.998,13.013 L16.012,13.013 L16.012,18 L11,18 L11,13.013 L10.998,13.013 Z M18.988,13.013 L24,13.013 L24,18 L18.988,18 L18.988,13.013 Z M3.007,21.013 L7.991,21.013 L7.991,26 L3.007,26 L3.007,21.009 L3.007,21.013 Z M10.998,21.013 L16.012,21.013 L16.012,26 L11,26 L11,21.009 L10.998,21.013 Z M18.988,21.013 L24,21.013 L24,26 L18.988,26 L18.988,21.009 L18.988,21.013 Z M3.007,29 L7.991,29 L7.991,33.987 L3.007,33.987 L3.007,29 Z M11,29 L16.014,29 L16.014,33.987 L11,33.987 L11,29 Z M18.99,29 L24,29 L24,33.987 L18.988,33.987 L18.988,29 L18.99,29 Z M27.011,13.009 L31.994,13.009 L31.994,18 L27.009,18 L27.009,13.013 L27.011,13.009 Z M27.011,21.009 L31.994,21.009 L31.994,26 L27.009,26 L27.009,21.009 L27.011,21.009 Z M27.011,29.009 L31.994,29.009 L31.994,33.996 L27.009,33.996 L27.009,29 L27.011,29.009 Z M0,3 L35,3 L35,10 L0,10 L0,3 Z" fill="#FFFFFF"></path>
                    <path d="M8,0 L12,0 L12,6 L8,6 L8,0 Z M23,0 L27,0 L27,6 L23,6 L23,0 Z" fill="#2F2E41"></path>
                  </g>
                </g>
              </g>
            </g>
          </g>
        </svg>
      </div>
      <div class="booking-content">
        <p>Du <b>${arr}</b></p>
        <p>Au <b>${dep}</b></p>
        <p><b>(${nb_of_days} jour${ nb_of_days === 1 ? "" : "s" })</b></p>
      </div>
    </div>
    <hr>
    <div class=" px-3 py-1">
      <p class="credit-balance text-start"><strong>Crédits:</strong></p>
      <p class="credit-balance text-start"><strong>${creditBalance}</strong> crédits disponibles</p>
      <p class="credit-balance text-start"><span class="balmoral-yellow-text"><strong>${totalPrice}</strong></span> crédits requis</p>
      <p class="credit-balance text-start tribe-green"><span class="tribe-green-text"><strong>${creditBalance - totalPrice}</strong></span> crédits restants</p>
    </div>
    <div class="credit-line-wrapper">
      <div class="credit-base-line">
        <div class="credit-balance-line">
          <div class="credit-price-line">
          </div>
        </div>
      </div>
    </div>
    `;
    return bookingInfoHtml
  }
}
