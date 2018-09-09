
module.exports.secondsInterval = (startData, endData) -> 
    return Math.round(module.exports.millisecondsInterval(startData, endData)/1000)

###
Compare two dates and return the time in milliseconds.
Return 0 if startData is null.
Uses Date.now if endData is null.
###
module.exports.millisecondsInterval = (startData, endData) -> 
    return 0 if !startData?
    return (endData ? Date.now()) - startData