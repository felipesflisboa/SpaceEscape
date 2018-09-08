GameManager = require('GameManager')
Persistence = require('Persistence')
FormatUtil = require('FormatUtil')

cc.Class {
    extends: require('Panel')

    properties:
        bestScoreLabel: cc.Label
        lastScoreLabel: cc.Label

    onLoad: ->
        this.bestScoreLabel.string = "Best:#{FormatUtil.exactDigits(Persistence.getBestScore(), 3)}"
        this.lastScoreLabel.string = "Last:#{FormatUtil.exactDigits(Persistence.getLastScore(), 3)}"

    onConfirm: ->
        this._super()
        GameManager.clearStaticGameData()
        cc.director.loadScene("Stage01")
}