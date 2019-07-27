function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('#prev_img,#prev_user_img').attr('src', e.target.result);
    }
    reader.readAsDataURL(input.files[0]);
  }
};
$(function () {
  $('#post_img, #user_img').on('change', function () {
    $('#prev_img,#prev_img_box,#prev_user_img,#prev_user_img_box').removeClass('hidden');
    $('.present_img').remove();
    readURL(this);
  });
});
