// fix sub nav on scroll
var $win = $(window);
var $nav = $('.subnav');
var $toolkit = $("#toolkit");
var isFixed = 1;
var toolkitTop = $toolkit.length && $toolkit.offset().top - 105;

function processScroll() {
  var scrollTop = $win.scrollTop();
  if (scrollTop >= toolkitTop && !isFixed) {
    isFixed = 1;
    $nav.show();
    $toolkit.addClass('ajaxtool-fixed');
    $("#rightcolumndiv").addClass("offset6");
  } else if (scrollTop <= toolkitTop && isFixed) {
    isFixed = 0;
    $nav.hide();
    $toolkit.removeClass('ajaxtool-fixed');
    $("#rightcolumndiv").removeClass("offset6");
  }
}

processScroll();
$win.on('scroll', processScroll);
