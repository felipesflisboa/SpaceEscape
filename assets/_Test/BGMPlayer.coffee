###
Used for BGMCreator to plays a BGM and persists into scene. 
###
BGMPlayer = cc.Class {
    extends: cc.Component

    initialize: (audioSource) ->
        this.node.name = "BGMPlayer"
        this.audioSource = this.node.addComponent(cc.AudioSource)
        this.audioSource.clip = audioSource.clip
        this.audioSource.volume = audioSource.volume
        # For some reason, this only works correctly if the instances never are destroyed.
        cc.game.addPersistRootNode(this.node)

    play: ->
        # if this.audioID?
          #  cc.audioEngine.resume(this.audioID)
          #  cc.audioEngine.setLoop(this.audioID, true)
        # else
            this.audioID = cc.audioEngine.play(this.audioSource.clip, true, this.audioSource.volume)
            cc.audioEngine.setLoop(this.audioID, true)

###
    play: ->
        if this.audioID?
            this.audioSource.resume()
        else
            this.audioSource.play()
            this.audioID = 1
###
}