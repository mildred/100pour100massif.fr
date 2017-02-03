(function(){
  document.addEventListener('scroll', onScroll)
  onScroll()

  var timeout = null
  function onScroll(){
    if(!timeout) timeout = setTimeout(setScrollTop, 10)
  }

  function setScrollTop(){
    timeout = null
    if(document.documentElement.scrollTop > 0){
      document.documentElement.classList.remove('scroll-top')
    } else {
      document.documentElement.classList.add('scroll-top')
    }
  }
})()
