cc.Class {
    extends: cc.Component

    properties:
        pauseMask: cc.Node

    onLoad: ->
        this.hud = this.node.getComponentInChildren(require('HUD'))
        this.pauseMask.active = false
}