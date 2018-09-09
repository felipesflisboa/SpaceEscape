GameManager = require('GameManager')
GameData = require('GameData')
Player = require('Player')
Persistence = require('Persistence')
ResultsLine = require('ResultsLine')

cc.Class {
    extends: require('Panel')

    properties:
        linePrefab: cc.Prefab
        table: cc.Layout
        result: require('IncreasingNumberLabel')
        gameClearNode: cc.Node

        Data:
            visible: false
            get: -> GameManager.data
            set: (newValue) -> GameManager.data = newValue
        DebugTesting:
            visible: false
            get: -> !CC_EDITOR && !this.Data?

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
        this.gameClearNode.active = false
        this.result.forceValue(0)
        this.index = -1
        this.initializeLineArray()
        this.totalValue = this.calculateTotalValue()
        Persistence.setLastScore(this.totalValue)
        Persistence.setBestScore(this.totalValue) if this.totalValue > Persistence.getBestScore()
        setTimeout(this.animateNextLine.bind(this), 2000)
    
    initializeLineArray: ->
        this.Data = GameData.generateDebugInstance() if this.DebugTesting
        this.lineArray = []
        this.lineArray.push(this.createLine("Clear", this.Data.lastStageNumber, 99, true))
        this.lineArray.push(this.createLine("Hits", this.Data.totalHits, 10, false))
        this.lineArray.push(this.createLine("Time", this.Data.Seconds(), 1, false))

    createLine: (name, base, multiplier, sign) ->
        line = cc.instantiate(this.linePrefab).getComponent(ResultsLine)
        this.table.node.addChild(line.node)
        line.node.setSiblingIndex (this.lineArray.length)
        line.initialize(name, base, multiplier, sign)
        return line

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
        setTimeout(( () =>
            this.canConfirm = true
            this.gameClearNode.active = true
        ), 2000)

    onConfirm: ->
        return if !this.canConfirm
        this._super()
        this.finish()
}