(function(){
  document.addEventListener('scroll', onScroll)
  onScroll()

  function onScroll(){
    if(document.documentElement.scrollTop > 0){
      document.documentElement.classList.remove('scroll-top')
    } else {
      document.documentElement.classList.add('scroll-top')
    }
  }
})()
