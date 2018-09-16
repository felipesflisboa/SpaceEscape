DateUtil = require('DateUtil')

###
Current game data retained between stages
###
GameData = cc.Class {
    properties:

        Seconds:
            visible: false
            get: -> if CC_EDITOR then 0 else DateUtil.secondsInterval(this.startTime, this.endTime)
        Finished:
            visible: false
            get: -> !CC_EDITOR && this.endTime?
            
    static:
        generateDebugInstance: ->
            ret = new GameData()
            ret.initialize()
            ret.lastStageNumber = 1
            ret.endTime = new Date()
            ret.totalHits = 2
            return ret

    initialize: ->
        this.startTime = new Date()
        this.endTime = null
        this.lastStageNumber = 0
        this.totalHits = 0
}