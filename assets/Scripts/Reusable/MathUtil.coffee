###
Compare two floats using a precision.
###
module.exports.approximately = (a, b, precision=0.001) -> Math.abs(a - b) < precision