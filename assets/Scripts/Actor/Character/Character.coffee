GameManager = require('GameManager')
NodeUtil = require('NodeUtil')
CharacterAnimationController = require('CharacterAnimationController')

###
Class for characters who moves
###
cc.Class {
    extends: require('Actor')
    # TODO sprite things
    properties:
        CanMove:
            visible: false
            get: -> !CC_EDITOR && this.canMove()

    canMove: -> GameManager.i().Occurring && !GameManager.i().paused

    start: -> {} # For override

    onLoad: ->
        this.direction = cc.Vec2.ZERO
        this.lastUsedDirection = cc.Vec2.ZERO
        this.lastSpeed = 0
        animation = NodeUtil.getComponentInChildrenInclusive(this.node, cc.Animation)
        if animation?.enabled
            this.animationController = new CharacterAnimationController()
            this.animationController.initialize(this, animation, 0.0016)

    update: (dt) ->
        usedDirection = if this.CanMove then this.direction else cc.Vec2.ZERO
        this.refreshVelocity(usedDirection) if usedDirection!=this.lastUsedDirection || this.lastSpeed!=this.speed

    refreshVelocity: (usedDirection) ->
        usedVelocity = usedDirection.mul(this.speed)
        this.RigidBody.linearVelocity = usedVelocity
        this.animationController.refresh() if this.animationController?
        this.lastSpeed = this.speed
        this.lastUsedDirection = usedDirection.clone()
}