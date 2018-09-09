GameManager = require('GameManager')
NodeUtil = require('NodeUtil')
Input = require('Input')

MAX_HP = 3

Player = cc.Class {
    extends: require('Character')

    properties:
        cameraContainer: cc.Node
        damageSFX: cc.AudioSource

        Flashing:
            visible: false
            get: ->
                return (
                    !CC_EDITOR &&
                    GameManager.i().Occurring &&
                    this.Alive &&
                    this.flashingEndTime? &&
                    this.flashingEndTime.getTime() > Date.now()
                )

        Alive:
            visible: false
            get: ->
                return false if CC_EDITOR
                return this.hp > 0

    canMove: -> this._super() && this.Alive && !GameManager.i().Busy

    onLoad: ->
        this._super()
        this.sprite = NodeUtil.getComponentInChildrenInclusive(this.node, cc.Sprite)
        this.flashingEndTime = new Date(0)
        this.hp = MAX_HP
        this.speed = 64

    start: ->
        this._super()

    update: (dt) ->
        this._super()
        this.updateInput()

    updateInput: ->
        if Input.up
            this.direction.y = 1
        else if Input.down
            this.direction.y = -1
        else
            this.direction.y = 0
        if Input.right
            this.direction.x = 1
        else if Input.left
            this.direction.x = -1
        else
            this.direction.x = 0

    attachCamera: (camera) -> this.cameraContainer.addChild(camera.node)

    detachCamera: () -> 
        worldContainerPosition = this.cameraContainer.convertToWorldSpaceAR(cc.Vec2.ZERO)
        this.node.removeChild(this.cameraContainer)
        this.node.parent.addChild(this.cameraContainer)
        this.cameraContainer.position = this.cameraContainer.parent.convertToNodeSpaceAR(worldContainerPosition)

    receiveDamage: (damage) ->
        return if !this.Alive
        this.hp -= damage
        GameManager.i().TotalHits++
        if this.Alive
            this.damageSFX.play()
            wasFlashingBefore = this.Flashing # Store previous results since counts resets
            this.resetFlashingCounter()
            this.goToNextFlashFrame() if !wasFlashingBefore
        else
            this.explode()

    resetFlashingCounter: -> this.flashingEndTime.setTime(Date.now() + 2000)

    goToNextFlashFrame: ->
        if !this.Flashing
            this.sprite.node.opacity = 255 if this.sprite?
            return
        this.sprite.node.opacity = if this.sprite.node.opacity==0 then 255 else 0
        setTimeout(this.goToNextFlashFrame.bind(this), 150)

    timeOver: ->
        return if !this.Alive
        GameManager.i().TotalHits++
        this.explode()

    explode: ->
        this.detachCamera()
        GameManager.i().onDeath()
        this._super()
        this.node.active = false

    finish: () ->
}