(function (global, $) {

  var $menu     = $('main_gnb li.m'),
      $contents = $('.scroll'),
      $doc      = $('html, body');
  $(function () {
      // 해당 섹션으로 스크롤 이동
      $menu.on('click','a', function(e){
          var $target = $(this).parent(),
              idx     = $target.index(),
              section = $contents.eq(idx),
              offsetTop = section.offset().top;
          $doc.stop()
                  .animate({
                      scrollTop :offsetTop
                  }, 800);
          return false;
      });
  });

  // Go to the TOP
  var btnTop = $('.btn-top');
  btnTop.on('click','m', function(e){
      e.preventDefault();
      $doc.stop()
              .animate({
                  scrollTop : 0
              },800)
  });

}(window, window.jQuery));

$(function(){
  // 스크롤 시 header fade-in
  $(document).on('scroll', function(){
      if($(window).scrollTop() > 0){
          $("#main_header").removeClass("deactive");
          $("#main_header").addClass("active");
      }else{
          $("#main_header").removeClass("active");
          $("#main_header").addClass("deactive");
      }
  })
});