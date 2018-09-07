###
Compare two floats using a precision.
###
module.exports.approximately = (a, b, precision=0.001) -> Math.abs(a - b) < precision

###
Repeat where t is always subtracted/sum of length until it is 0 <= t < length.

repeat(15,6) = 3, repeat(12,3) = 0, repeat(-2,3) = 1.
###
module.exports.repeat = (t, length) ->
	t += length while (t < 0)
	t -= length while (t >= length)
	return t