GameManager = require('GameManager')
Player = require('Player')
Persistence = require('Persistence')
ResultsLine = require('ResultsLine')

cc.Class {
    extends: require('Panel')

    properties:
        linePrefab: cc.Prefab
        table: cc.Layout
        result: require('IncreasingNumberLabel')
        gameOverNode: cc.Node
        gameClearNode: cc.Node

        IsGameOver:
            visible: false
            get: -> false # !CC_EDITOR && Player.hp == 0
        DebugTesting:
            visible: false
            get: -> !CC_EDITOR && !GameManager.startTime?

    onEnable: ->
        this.clear()
        this.initialize()

    clear: ->
        if this.lineArray?
            for line in this.lineArray
                line.node.destroy()
            this.lineArray.length = 0

    initialize: ->
        this.canConfirm = false
        this.gameOverNode.active = false
        this.gameClearNode.active = false
        this.result.forceValue(0)
        this.index = -1
        this.initializeLineArray()
        this.totalValue = this.calculateTotalValue()
        Persistence.setLastScore(this.totalValue)
        Persistence.setBestScore(this.totalValue) if this.totalValue > Persistence.getBestScore()
        setTimeout(this.animateNextLine.bind(this), 2000)
    
    initializeLineArray: ->
        this.lineArray = []
        if this.DebugTesting
            GameManager.startTime = new Date()
            GameManager.endTime = new Date()
            GameManager.lastStageNumber = 1
            GameManager.totalHits = 2
        if this.IsGameOver
            this.lineArray.push(this.createLine("Stage", GameManager.lastStageNumber, 1, true))
        else
            this.lineArray.push(this.createLine("Clear", GameManager.lastStageNumber, 99, true))
            this.lineArray.push(this.createLine("Hits", GameManager.totalHits, 10, false))
            this.lineArray.push(this.createLine("Time", this.calculateTimeBonus(), 1, false))

    createLine: (name, base, multiplier, sign) ->
        line = cc.instantiate(this.linePrefab).getComponent(ResultsLine)
        this.table.node.addChild(line.node)
        line.node.setSiblingIndex (this.lineArray.length)
        line.initialize(name, base, multiplier, sign)
        return line

    calculateTimeBonus: ->
        seconds = Math.round((GameManager.endTime.getTime() - GameManager.startTime.getTime())/1000)
        return seconds

    calculateTotalValue: ->
        ret = 0
        for line in this.lineArray
            ret += line.productValue*(if line.sign then 1 else -1)
        return Math.max(0,ret)

    animateNextLine: ->
        this.index++
        isTotal = this.index == this.lineArray.length
        if isTotal
            this.result.startAnimation(this.totalValue, this.onFinishAnimation.bind(this))
        else
            this.lineArray[this.index].startAnimation(this.animateNextLine.bind(this))

    onFinishAnimation: ->
        setTimeout(( () ->
            this.canConfirm = true
            (if this.IsGameOver then this.gameOverNode else this.gameClearNode).active = true
        ).bind(this), 2000)

    onConfirm: ->
        return if !this.canConfirm
        this._super()
        this.finish()
}