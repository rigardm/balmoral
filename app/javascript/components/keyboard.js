const hideNavbarOnKeyboardShow = () => {
  document.addEventListener('focusin', (e) => {
   document.querySelector('.bottom-bar').classList.add("d-none");
   document.querySelector('.message-input').style.paddingBottom = '0vh' ;
   window.scrollTo(0,document.body.scrollHeight);
  });
  document.addEventListener('focusout', (e) => {
    document.querySelector('.bottom-bar').classList.remove("d-none");
    document.querySelector('.message-input').style.paddingBottom = '13vh';
    window.scrollTo(0,document.body.scrollHeight);
  });
}

export {hideNavbarOnKeyboardShow}
