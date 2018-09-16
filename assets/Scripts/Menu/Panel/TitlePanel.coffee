GameManager = require('GameManager')
Persistence = require('Persistence')
FormatUtil = require('FormatUtil')

cc.Class {
    extends: require('Panel')

    properties:
        bestScoreLabel: cc.Label
        lastScoreLabel: cc.Label

    onLoad: ->
        this.bestScoreLabel.string = "Best:#{FormatUtil.exactDigits(Persistence.getBestScore(), 4)}"
        this.lastScoreLabel.string = "Last:#{FormatUtil.exactDigits(Persistence.getLastScore(), 4)}"

    onConfirm: ->
        this._super()
        GameManager.data = null
        cc.director.loadScene("Stage01")
}