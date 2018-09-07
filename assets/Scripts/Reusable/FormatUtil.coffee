###
Format a number with a fixed number of total digits, being bigger or lower.
###
module.exports.exactDigits = (number, digits) -> ("0".repeat(digits-1) + number).slice(-digits)