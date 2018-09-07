FormatUtil = require('FormatUtil')

cc.Class {
    extends: cc.Component

    properties:
        typeLabel: cc.Label
        multiplyingLabel: cc.Label
        multiplierLabel: cc.Label
        product: require('IncreasingNumberLabel')

    initialize: (labelString, multiplying, multiplier, sign) ->
        this.sign = sign
        this.typeLabel.string = labelString
        this.typeLabel.string = "-"+this.typeLabel.string if !this.sign
        usedMultiplying = Math.min(999, multiplying)
        this.productValue = usedMultiplying * multiplier
        this.multiplyingLabel.string = FormatUtil.exactDigits(usedMultiplying, 3)
        this.multiplierLabel.string = FormatUtil.exactDigits(multiplier, 2)
        this.product.forceValue(0)

    startAnimation: (callback) -> this.product.startAnimation(this.productValue, callback)
}