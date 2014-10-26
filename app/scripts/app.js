var $ = require('jquery');

app = exports = module.exports = Compute;

function Compute () {

};

Compute.prototype.add = function (a, b) {
  return a + b;
}

$('.example').text('example');
