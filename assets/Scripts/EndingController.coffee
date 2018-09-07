Direction = require('Direction')

###
Do the ending animation
###
cc.Class {
    extends: cc.Component

    properties:
        shipNode: cc.Node
        spaceBaseNode: cc.Node
        backgroundNode: cc.Node

    onLoad: ->
        cc.view.enableAntiAlias(false)
        this.shipNode.active = false
        setTimeout(this.enableShip.bind(this), 1600)
        setTimeout(this.finish.bind(this), 9600)

    update: (dt) ->
        this.backgroundNode.position = this.backgroundNode.position.add(cc.Vec2.ONE.mul(0.9*dt))
        this.spaceBaseNode.position = this.spaceBaseNode.position.add(Direction.DOWN.mul(0.5*dt))
        this.shipNode.position = this.shipNode.position.add(Direction.RIGHT.mul(15*dt)) if this.shipNode.active

    enableShip: -> this.shipNode.active = true

    finish: -> cc.director.loadScene("Menu")
}