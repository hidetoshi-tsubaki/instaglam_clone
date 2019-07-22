$(function () {
  $('.openModal').on('click', function () {
    $('#modalArea').fadeIn();
  });
  $('.closeModal , #modalBg').on('click', function () {
    $('#modalArea').fadeOut();
  });
  $('.open_user_menu').on('click', function () {
    $('#user_menu_area').fadeIn();
    $('fa-user').addClass('close_user_menu');
    $('fa-user').removeClass('open_user_menu');
  });
  $('.close_user_menu, #user_menu_area').on('click', function () {
    $('#user_menu_area').fadeOut();
    $('fa-user').addClass('open_user_menu');
    $('fa-user').removeClass('close_user_menu');
  });

  $(function () {
    setTimeout("$('#notice').fadeOut('slow')", 2000);
    setTimeout("$('#alert').fadeOut('slow')", 2000);
  });
});