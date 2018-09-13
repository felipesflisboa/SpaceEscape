GameManager = require('GameManager')
FormatUtil = require('FormatUtil')

cc.Class {
    extends: cc.Component

    properties:
        heartRect: require("HeartRect")
        totalHitsLabel: cc.Label
        stageLabel: cc.Label
        timeLabel: cc.Label
        stageRemainingTimeLabel: cc.Label

    enableRefresh: ->
        this.schedule(this.refresh, 0.2)
        this.refresh()

    refresh: ->
        this.heartRect.Value = GameManager.i().player.hp

        this.totalHitsLabel.string = FormatUtil.exactDigits(GameManager.i().TotalHits, 3)
        this.stageLabel.string = "STAGE #{GameManager.i().Stage.Number}"
        this.stageRemainingTimeLabel.string = Math.max(GameManager.i().StageRemainingSeconds,0)

        gameSeconds = GameManager.i().Seconds
        minutesString = FormatUtil.exactDigits(Math.floor(gameSeconds/60), 2)
        secondsString = FormatUtil.exactDigits(gameSeconds%60, 2)
        this.timeLabel.string = "#{minutesString}:#{secondsString}"
}