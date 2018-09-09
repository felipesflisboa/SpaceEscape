Enemy = require('Enemy')
Direction = require('Direction')

###
Used for calling events on Enemy class
###
cc.Class {
    extends: cc.Component

    editor:
        requireComponent: Enemy

    onLoad: ->
        this.enemy = this.node.getComponent(Enemy)

    up: (event, customEventData) ->
        this.addTileStep(Direction.UP, this.parseEvent(customEventData))
    left: (event, customEventData) ->
        this.addTileStep(Direction.LEFT, this.parseEvent(customEventData))
    down: (event, customEventData) ->
        this.addTileStep(Direction.DOWN, this.parseEvent(customEventData))
    right: (event, customEventData) ->
        this.addTileStep(Direction.RIGHT, this.parseEvent(customEventData))
            
    circleUpRight: (event, customEventData) ->
        directionArray = [Direction.UP, Direction.RIGHT, Direction.DOWN, Direction.LEFT]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleRightDown: (event, customEventData) ->
        directionArray = [Direction.RIGHT, Direction.DOWN, Direction.LEFT, Direction.UP]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleDownLeft: (event, customEventData) ->
        directionArray = [Direction.DOWN, Direction.LEFT, Direction.UP, Direction.RIGHT]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleLeftUp: (event, customEventData) ->
        directionArray = [Direction.LEFT, Direction.UP, Direction.RIGHT, Direction.DOWN]
        this.addTileStep(directionArray, this.parseEvent(customEventData))

    circleUpLeft: (event, customEventData) ->
        directionArray = [Direction.UP, Direction.LEFT, Direction.DOWN, Direction.RIGHT]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleLeftDown: (event, customEventData) ->
        directionArray = [Direction.LEFT, Direction.DOWN, Direction.RIGHT, Direction.UP]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleDownRight: (event, customEventData) ->
        directionArray = [Direction.DOWN, Direction.RIGHT, Direction.UP, Direction.LEFT]
        this.addTileStep(directionArray, this.parseEvent(customEventData))
    circleRightUp: (event, customEventData) ->
        directionArray = [Direction.RIGHT, Direction.UP, Direction.LEFT, Direction.DOWN]
        this.addTileStep(directionArray, this.parseEvent(customEventData))

    addTileStep: (directionArray, tileCount) ->
        directionArray = [directionArray] if !Array.isArray(directionArray)
        for dir in directionArray
            for i in [0...tileCount]
                this.enemy.directionArray.push(dir)

    parseEvent: (data) ->
        return if !data then 1 else parseInt(data)
}
