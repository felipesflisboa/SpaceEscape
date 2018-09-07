###
Label who flashes, like a "Press Start" label
###
cc.Class {
    extends: cc.Component

    properties:
        secondsDisplaying: 1
        secondsAway: 1

    onLoad: -> this.disappears()

    display: ->
        return if !this.node?
        this.node.opacity = 255
        setTimeout(this.disappears.bind(this), this.secondsDisplaying*1000) 

    disappears: ->
        return if !this.node?
        this.node.opacity = 0
        setTimeout(this.display.bind(this), this.secondsAway*1000) 
}