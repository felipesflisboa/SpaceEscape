FormatUtil = null

###
A number label who increase.
Call with 'startAnimation' or 'forceValue'.
###
cc.Class {
    extends: cc.Component

    editor:
        requireComponent: cc.Label

    properties:
        numberPerSecond: 100
        digitsNumber:
            default: 0
            type: cc.Integer
            tooltip: "When isn't 0, calls FormatUtil.exactDigits with the digitsNumber"
        sfx: 
            default: null
            type: cc.AudioSource
            tooltip: "For playing with number animation"

    onLoad: ->
        this.label = this.node.getComponent(cc.Label)
        this.animating = false
        FormatUtil = require('FormatUtil') if this.digitsNumber>0

    startAnimation: (value, callback) ->
        this.value = value
        this.callback = callback
        this.animating = true
        this.sfx.play() if this.sfx?
    
    ###
    Stop all animations and set the label into a number
    ###
    forceValue: (value) ->
        this.value = value
        this.complete()

    update: (dt) ->
        return if !this.animating
        this.current += this.numberPerSecond * dt
        this.refresh()
        this.complete() if this.current >= this.value

    refresh: ->
        currentInt = Math.floor(this.current)
        if this.digitsNumber>0
            this.label.string = FormatUtil.exactDigits(currentInt, this.digitsNumber)
        else
            currentInt.toString()

    complete: ->
        this.current = this.value
        this.refresh()
        this.animating = false
        this.sfx.stop() if this.sfx?
        this.callback?()
        this.callback = null
}