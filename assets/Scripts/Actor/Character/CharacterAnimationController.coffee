###
Controls character animation
###
cc.Class {       
    initialize: (character, animation, speedMultiplier) ->
        this.character = character
        this.speedMultiplier = speedMultiplier
        this.animation = animation
        this.currentState = null
        
    refresh: ->
        direction = if this.character.CanMove then this.character.direction else cc.Vec2.ZERO
        name = switch
            when direction.y == 1 then 'WalkUp'
            when direction.y == -1 then 'WalkDown'
            when direction.x == 1 then 'WalkRight'
            when direction.x == -1 then 'WalkLeft'
            else null
        if(name?)
            this.play(name)
        else
            this.animation.pause()

    play: (name) -> 
        if(this.currentState?.name==name)
            this.animation.resume() if this.currentState.isPaused
            return
        this.currentState = this.animation.play(name)
        this.currentState.speed = this.character.speed*this.speedMultiplier # TODO max/min
}