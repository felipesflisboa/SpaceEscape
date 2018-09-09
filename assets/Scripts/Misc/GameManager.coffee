Input = require('Input')
DateUtil = require('DateUtil')
GameData = require('GameData')

GameManager = cc.Class {
    extends: cc.Component
    
    statics:
        _i: null
        data: null
        i: ->
            if this._i==null || !cc.isValid(this._i)
                this._i = cc.find('GameManager').getComponent(GameManager)
            return this._i
    
    properties:
        playerPrefab: cc.Prefab
        hudPrefab: cc.Prefab
        stageTimeEndingSFX: cc.AudioSource
        deathSFX: cc.AudioSource
        stageClearSFX: cc.AudioSource
        sceneNameArray: [cc.String]
        
        # Properties
        Canvas:
            visible: false
            get: ->
                return null if CC_EDITOR
                this._canvas ?= cc.find('Canvas').getComponent(cc.Canvas)
                return this._canvas
        Stage:
            visible: false
            get: ->
                return null if CC_EDITOR
                this._stage ?= this.Canvas.node.getComponentInChildren(require('Stage'))
                return this._stage
        Seconds:
            visible: false
            get: -> if CC_EDITOR then null else GameManager.data.Seconds
        StageRemainingSeconds:
            visible: false
            get: ->
                return 0 if CC_EDITOR
                return 40 - DateUtil.secondsInterval(this.stageStartTime, this.stageEndTime)
        TotalHits:
            visible: false
            get: -> if CC_EDITOR then 0 else GameManager.data.totalHits
            set: (value) -> GameManager.data.totalHits = value
        FinishingStage:
            visible: false
            get: -> !CC_EDITOR && this.stageEndTime?
        Occurring:
            visible: false
            get: -> !CC_EDITOR && GameManager.data.startTime? && !GameManager.data.endTime?
        Busy:
            visible: false
            get: -> !CC_EDITOR && (!this.Occurring || this.FinishingStage)

    onLoad: ->
        Input.register()
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onDebugKeyPress, this) if CC_DEBUG
        cc.director.getPhysicsManager().enabled = true
        cc.view.enableAntiAlias(false)

    start: ->
        this.player = cc.instantiate(this.playerPrefab).getComponent(require('Player'))
        this.hud = cc.instantiate(this.hudPrefab).getComponent(require('HUD'))
        this.Canvas.node.addChild(this.hud.node)
        this.Stage.initialize()
        this.initializeCamera()
        if !GameManager.data?
            GameManager.data = new GameData(this.Stage.Number)
            GameManager.data.initialize()
        this.stageStartTime ?= new Date()
        # Wait a frame for running all start functions before game start.
        setTimeout(this.startStage.bind(this), 1)

    enablePhysicsDebug: ->
        cc.director.getPhysicsManager().debugDrawFlags = (    
            cc.PhysicsManager.DrawBits.e_aabbBit |
            cc.PhysicsManager.DrawBits.e_pairBit |
            cc.PhysicsManager.DrawBits.e_centerOfMassBit |
            cc.PhysicsManager.DrawBits.e_jointBit |
            cc.PhysicsManager.DrawBits.e_shapeBit
        )
        cc.director.getPhysicsManager().attachDebugDrawToCamera(cc.Camera.main)

    startStage: ->
        this.hud.enableRefresh()
        this.schedule(this.stageTimeOverCheck, 0.2)

    initializeCamera: ->
        camera = (new cc.Node()).addComponent(cc.Camera)
        this.player.attachCamera(camera)
        camera.addTarget(this.Stage.node)

    onDebugKeyPress: (event) -> this.stageClear() if event.keyCode==cc.KEY.e

    stageTimeOverCheck: ->
        return if this.Busy || this.StageRemainingSeconds > 5
        if !this.stageTimeEndingSFX.isPlaying
            this.Stage.bgm.stop()
            this.stageTimeEndingSFX.play()
        return if this.StageRemainingSeconds > -1
        this.stageTimeEndingSFX.stop()
        this.player.timeOver()

    stageClear: ->
        this.finishStage()
        this.stageClearSFX.play()
        setTimeout(this.goIntoNextStage.bind(this), 1200) 

    goIntoNextStage: ->
        lastStage =  this.Stage.Number == this.sceneNameArray.length - 1
        if lastStage
            this.gameClear()
        else
            cc.director.loadScene(this.sceneNameArray[this.Stage.Number+1])

    onDeath: ->
        this.finishStage()
        this.deathSFX.play()
        setTimeout((() => cc.director.loadScene(cc.director.getScene().name)), 3000)

    finishStage: ->
        this.stageEndTime = new Date()
        this.Stage.bgm.stop()

    gameClear: ->
        GameManager.data.endTime = new Date()
        cc.director.loadScene("Ending")

    onDestroy: ->
        Input.unregister()
        cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this.onDebugKeyPress, this) if CC_DEBUG
}