$(function () {
    var a = $("body"), b = $("#show-login-form-link"), c = $("#login-form");
    showingLoginForm = false, setTimeout(function () {
        b.css({width:b.width()})
    }, 2e3), b.click(function () {
        showingLoginForm = !showingLoginForm;
        var a = $(this), b = 160, d = showingLoginForm ? a.position().top + a.outerHeight() - 2 : -180, e = a.data("" + (showingLoginForm ? "close" : "default"));
        setTimeout(function () {
            a.toggleClass("selected"), a.text(e)
        }, b), c.animate({top:d})
    }), c.find("button").click(function () {
        var a = $(this);
        return a.text(a.data("loading")),
	  $.ajax({
		   type:"post",
		   url:"/sessions",
		   dataType:"html",
		   data:c.serialize(),
		   //success: function(b){},
		   //fail: function() {c.find(".forgot").slideDown(), a.text(a.data("default"))},
        })
    }), a.mouseup(function (a) {
        c.has(a.target).length === 0 && a.target.id !== "show-login-form-link" && showingLoginForm && ($("#show-login-form-link").click(), c.find(".forgot").slideUp())
    })
});

$(document).delegate('.img_download', 'click', function() {
  var txt_field = $("#file_field");
  //txt_field.attr("value","burn!");
  });