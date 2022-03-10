// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "chartkick/chart.js"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "controllers"
import "bootstrap"

import { flashesFadeOut } from '../components/flashes'
import { hideNavbarOnKeyboardShow} from '../components/keyboard'

document.addEventListener("turbolinks:load", ()=>{
  flashesFadeOut();
  hideNavbarOnKeyboardShow();
})

document.addEventListener("turbolinks:before-cache", () => {
  // tu cherches le ou les éléments qui ont la classe fade-in
  document.querySelectorAll('[class*="fade-in"]').forEach( (element) => {
 element.classList.remove('fade-in');
 element.style.opacity = 0;
  });
  // si tu en trouve un ou plusieurs, tu leurs enlève la classe
  // lui mettre une opacité à 0 quand il a pas la classe
})
