###
Plays a BGM or selfdestruct if there is a BGMPlayer already playing the same music.
Used for won't reset music on each scene change.
###
BGMPlayer = cc.Class {
    extends: cc.Component

    editor:
        requireComponent: cc.AudioSource

    statics:
        lastClip: null

    onLoad: ->
        cc.log("onLoad")
        cc.log(this.name)
        this.audioSource = this.node.getComponent(cc.AudioSource)
        # For some reason, this only works correctly if the instances never are destroyed.
        #cc.game.addPersistRootNode(this.node)
        this.validateCurrentInstance()

    validateCurrentInstance: ->
        # return if BGMPlayer.lastClip!=null && this.audioSource.clip == BGMPlayer.lastClip
        cc.audioEngine.stopAll() if BGMPlayer.lastClip != BGMPlayer.lastClip
        BGMPlayer.lastClip = this.audioSource.clip
        this.play(this.audioSource)

    play: (audioSource) -> 
        node = new cc.Node()
        node.name = "AudioPlayer"
        node.addComponent(cc.AudioSource)
        ac = node.getComponent(cc.AudioSource)
        ac.clip = audioSource.clip
        cc.game.addPersistRootNode(node)
        cc.audioEngine.play(ac.clip, true, audioSource.volume)

    onDestroy: () -> cc.log("Destroy!")

###
#remove
    statics:
        lastClip: null

    onLoad: ->
        this.play(this.node.getComponent(cc.AudioSource))
        cc.game.addPersistRootNode(this.node)

    play: (audioSource) ->
        return if BGMPlayer.lastClip!=null && audioSource.clip == BGMPlayer.lastClip
        BGMPlayer.lastClip = audioSource.clip

        audioID = cc.audioEngine.play(audioSource.clip)
        cc.audioEngine.setVolume(audioID, audioSource.volume)
        cc.audioEngine.setLoop(audioID, true)


    statics:
        lastInstance: null

    onLoad: ->
        this.audioSource = this.node.getComponent(cc.AudioSource)
        this.validateCurrentInstance()

    validateCurrentInstance: ->
        if BGMPlayer.lastInstance==null || !cc.isValid(BGMPlayer.lastInstance)
            this.registerInstance(this)
            return
        ##if this.audioSource.clip == BGMPlayer.lastInstance.audioSource.clip
        ##    this.node.destroy()
        ##else 
            BGMPlayer.lastInstance.node.destroy()
            this.registerInstance(this)
            
    registerInstance: (instance) ->
        BGMPlayer.lastInstance = instance
        cc.game.addPersistRootNode(instance.node)
        cc.audioEngine.play(this.audioSource.clip)
###
}