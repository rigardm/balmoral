const flashesFadeOut = () => {
  const flash = document.querySelector('.flash')
  if (flash) {
    setTimeout( function() {
      removeFlash(flash)
    }, 3000);
  }
};

const removeFlash = (flash) => {
  flash.classList.add('opacity-0')
  setTimeout( function() {
    flash.remove()
  }, 1000);
}

export { flashesFadeOut };
