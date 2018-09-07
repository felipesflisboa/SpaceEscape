BGMPlayer = require('BGMPlayer')

###
Plays a BGM or selfdestruct if there is a BGMPlayer already playing the same music.
Used for won't reset music on each scene change.
###
BGMCreator = cc.Class {
    extends: cc.Component

    editor:
        requireComponent: cc.AudioSource

    statics:
        lastPlayer: null

        
    properties:
        ClipEqualsFromLast:
            visible: false
            get: -> !CC_EDITOR && this.audioSource.clip == BGMCreator.lastPlayer.audioSource.clip

    onLoad: ->
        this.audioSource = this.node.getComponent(cc.AudioSource)
        this.validateCurrentInstance()

    validateCurrentInstance: ->
        if cc.isValid(BGMCreator.lastPlayer) && this.ClipEqualsFromLast
            BGMCreator.lastPlayer.play()
            return 
        cc.audioEngine.stopAll() if cc.isValid(BGMCreator.lastPlayer) && !this.ClipEqualsFromLast
        this.createPlayer(this.audioSource).play()

    createPlayer: (audioSource) ->
        ret = new cc.Node().addComponent(BGMPlayer)
        ret.initialize(audioSource)
        BGMCreator.lastPlayer = ret
        return ret
}