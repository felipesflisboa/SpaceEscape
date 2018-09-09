Player = require('Player')
Input = require('Input')
Direction = require('Direction')
MathUtil = require('MathUtil')
NodeUtil = require('NodeUtil')

###
Enemies who move around with a repetitive pattern.
###
cc.Class {
    extends: require('Character')

    properties:
        definedSpeed: 32
        commandList: [cc.Component.EventHandler]

        OnDestiny:
            visible: false
            get: -> 
                return false if CC_EDITOR
                extraFixValue = 0.01*this.speed
                return switch this.directionArray[this.index]
                    when Direction.UP then this.node.position.y >= this.destiny.y - extraFixValue
                    when Direction.DOWN then this.node.position.y <= this.destiny.y + extraFixValue
                    when Direction.RIGHT then this.node.position.x >= this.destiny.x - extraFixValue
                    when Direction.LEFT then this.node.position.x <= this.destiny.x + extraFixValue

    onLoad: ->
        this._super()
        this.speed = this.definedSpeed
        this.destiny = cc.Vec2.ZERO
        this.index = -1
        this.directionArray = []

    start: ->
        this._super()
        cc.Component.EventHandler.emitEvents(this.commandList, null)
        cc.error("#{this.node.name} directionArray won't sum 0!") if !this.directionsAreValid(this.directionArray)
        this.initializeNextDestiny()

    update: (dt) ->
        this._super()
        this.initializeNextDestiny() if this.OnDestiny #TODO, maybe a destiny fix to solve collision issue

    lateUpdate: (dt) ->
        this.collidedWithPlayerLastFrame = false # For avoiding colliding twice in the same frame

    ###
    Check if directions are valid, in other words, if the movement ends up were it begins.
    ###
    directionsAreValid: (directionArray) ->
        sum = cc.Vec2.ZERO
        for direction in directionArray
            sum.addSelf(direction)
        return sum.mag() == 0

    initializeNextDestiny: ->
        this.index = (this.index + 1) % this.directionArray.length
        this.destiny = this.node.position.add(this.directionArray[this.index].mul(16))
        this.direction = this.directionArray[this.index]

    onBeginContact: (contact, selfCollider, otherCollider) ->
        return if !cc.isValid(this.node) ||  this.collidedWithPlayerLastFrame
        player = NodeUtil.getComponentInParent(otherCollider.node, Player)
        if player?
            this.collidedWithPlayerLastFrame = true
            player.receiveDamage(1)
            this.explode()
}