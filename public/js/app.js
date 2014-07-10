(function () {
  var button = document.querySelector('#click');
  var content = document.querySelector('#content');

  button.addEventListener('click', function () {
    content.innerHTML = 'Change!';
  });
}());
