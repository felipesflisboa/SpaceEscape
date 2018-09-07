Input = require('Input')

GameManager = cc.Class {
    extends: cc.Component
    
    statics:
        _i: null
        startTime: null
        endTime: null
        lastStageNumber: null
        totalHits: 0
        gameOver: false
        i: ->
            if this._i==null || !cc.isValid(this._i)
                this._i = cc.find('GameManager').getComponent(GameManager)
            return this._i
        getSeconds: ->
            return 0 if !this.startTime?
            usedEndTimeMS = if this.endTime? then this.endTime.getTime() else Date.now()
            return Math.round((usedEndTimeMS - this.startTime.getTime())/1000)

        clearStaticGameData: ->
            this.startTime = null
            this.endTime = null
            this.lastStageNumber = null
            this.totalHits = 0
            this.gameOver = false
            require('Player').clearStaticGameData()
    
    properties:
        playerPrefab: cc.Prefab
        hudPrefab: cc.Prefab
        # bulletPrefab: cc.Prefab #remove
        stageTimeEndingSFX: cc.AudioSource
        gameOverSFX: cc.AudioSource
        stageClearSFX: cc.AudioSource
        sceneNameArray: [cc.String]
        # muteOnDebug: false #remove
        
        # Properties
        ###
        OnEditor: # Functions who executes only in editor
            get: ->
                return null if !CC_EDITOR
                cc.view.enableAntiAlias(false);
                return null
        ###
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
            get: -> if CC_EDITOR then null else GameManager.getSeconds()
        StageRemainingSeconds:
            visible: false
            get: ->
                return 0 if CC_EDITOR || !this.stageStartTime?
                usedEndTimeMS = if this.stageEndTime? then this.stageEndTime.getTime() else Date.now()
                return 40 - Math.round((usedEndTimeMS - this.stageStartTime.getTime())/1000)
        TotalHits:
            visible: false
            get: -> if CC_EDITOR then 0 else GameManager.totalHits
            set: (value) -> GameManager.totalHits = value
        Occurring:
            visible: false
            get: -> !CC_EDITOR && GameManager.startTime? && !GameManager.endTime?
        Busy:
            visible: false
            get: -> !CC_EDITOR && (!this.Occurring || this.finishingStage)

    onLoad: ->
        Input.register()
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onDebugKeyPress, this) if CC_DEBUG
        this.finishingStage = false
        cc.director.getPhysicsManager().enabled = true
        cc.view.enableAntiAlias(false)

    start: ->
        this.player = cc.instantiate(this.playerPrefab).getComponent(require('Player'))
        this.hud = cc.instantiate(this.hudPrefab).getComponent(require('HUD'))
        this.Canvas.node.addChild(this.hud.node)
        this.Stage.initialize()
        GameManager.lastStageNumber = this.Stage.Number
        this.initializeCamera()
        GameManager.startTime ?= new Date()
        this.stageStartTime ?= new Date()

        if CC_DEBUG && false
            cc.director.getPhysicsManager().debugDrawFlags = (    
                cc.PhysicsManager.DrawBits.e_aabbBit |
                cc.PhysicsManager.DrawBits.e_pairBit |
                cc.PhysicsManager.DrawBits.e_centerOfMassBit |
                cc.PhysicsManager.DrawBits.e_jointBit |
                cc.PhysicsManager.DrawBits.e_shapeBit
            )
            cc.director.getPhysicsManager().attachDebugDrawToCamera(cc.Camera.main)

        # Wait a frame for running all start functions before game start.
        setTimeout(this.startStage.bind(this), 1)

    # lateUpdate: (dt) ->
        # cc.audioEngine.stopAll() if this.muteOnDebug && CC_DEBUG #remove
        # cc.log("Debuggg!") if this.muteOnDebug && CC_DEBUG #remove

    startStage: ->
        this.finishingStage = false
        this.hud.enableRefresh()
        this.schedule(this.stageTimeOverCheck, 0.2)
        # this.schedule(this.instantiateTest, 4) #remove

    initializeCamera: ->
        camera = (new cc.Node()).addComponent(cc.Camera)
        this.player.attachCamera(camera)
        camera.addTarget(this.Stage.node)

    instantiateTest: -> #remove
        bullet = cc.instantiate(this.bulletPrefab).getComponent('Bullet')
        this.Stage.node.addChild(bullet.node)
        bullet.node.setPosition(cc.p(200,200))
        bullet.direction = cc.p(0, -1)
        return bullet

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
        GameManager.liveStartTime ?= new Date()
        this.stageClearSFX.play()
        setTimeout(this.goIntoNextStage.bind(this), 1200) 

    goIntoNextStage: ->
        lastStage =  this.Stage.Number == this.sceneNameArray.length - 1
        if lastStage
            this.clear()
        else
            cc.director.loadScene(this.sceneNameArray[this.Stage.Number+1])

    gameOver: ->
        this.finishStage()
        this.gameOverSFX.play()
        setTimeout((() => cc.director.loadScene(cc.director.getScene().name)).bind(this), 3000)

    finishStage: ->
        this.stageEndTime = new Date()
        this.finishingStage = true
        this.Stage.bgm.stop()

    clear: ->
        GameManager.gameOver = false
        GameManager.endTime = new Date()
        cc.director.loadScene("Ending")

    onDestroy: ->
        Input.unregister()
        cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this.onDebugKeyPress, this) if CC_DEBUG
}