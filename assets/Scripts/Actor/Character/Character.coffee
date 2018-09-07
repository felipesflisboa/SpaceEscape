GameManager = require('GameManager')
NodeUtil = require('NodeUtil')

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

    start: -> {}

    onLoad: ->
        this.direction = cc.Vec2.ZERO
        this.lastUsedDirection = cc.Vec2.ZERO
        this.lastSpeed = 0
        
        this.animation = NodeUtil.getComponentInChildrenInclusive(this.node, cc.Animation)
        # For disable the animation system onLoad when isn't enabled, since, when paused, it disables itself
        this.animation = null if this.animation? && !this.animation.enabled
        this.currentAnimationState = null

    update: (dt) ->
        usedDirection = if this.CanMove then this.direction else cc.Vec2.ZERO
        this.refreshVelocity(usedDirection) if usedDirection!=this.lastUsedDirection || this.lastSpeed!=this.speed

    refreshVelocity: (usedDirection) ->
        usedVelocity = usedDirection.mul(this.speed)
        this.RigidBody.linearVelocity = usedVelocity
        this.refreshAnimation() if this.animation?
        this.lastSpeed = this.speed
        this.lastUsedDirection = usedDirection.clone()
        
    refreshAnimation: ->
        animationDirection = if this.CanMove then this.direction else cc.Vec2.ZERO
        animationName = switch
            when animationDirection.y == 1 then 'WalkUp'
            when animationDirection.y == -1 then 'WalkDown'
            when animationDirection.x == 1 then 'WalkRight'
            when animationDirection.x == -1 then 'WalkLeft'
            else null
        if(animationName?)
            this.playAnimation(animationName)
        else
            this.animation.pause()

    playAnimation: (name) -> 
        if(this.currentAnimationState?.name==name)
            this.animation.resume() if this.currentAnimationState.isPaused
            return
        this.currentAnimationState = this.animation.play(name)
        if !this.currentAnimationState? || !this.speed?
            cc.log("Bug!") #remove
        this.currentAnimationState.speed = this.speed/600 # TODO max/min
}