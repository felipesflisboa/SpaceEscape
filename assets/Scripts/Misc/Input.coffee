###
Defines inputs pressed.
Used for creating a better directional control 
###
Input = cc.Class {
    statics:
        _singleton: null
        left: false
        right: false
        down: false
        up: false
        pause: false
        escape: false

        reset: ->
            this.left = false
            this.right = false
            this.down = false
            this.up = false
            this.pause = false
            this.escape = false

        register: ->
            this.reset()
            this._singleton = new (require('Input'))()
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this._singleton.onKeyDown, this._singleton)
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this._singleton.onKeyUp, this._singleton)

        unregister: ->
            cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this._singleton.onKeyDown, this._singleton)
            cc.systemEvent.off(cc.SystemEvent.EventType.KEY_UP, this._singleton.onKeyUp, this._singleton)

    onKeyDown: (event) -> this.handleKeyPress(event.keyCode, true)

    onKeyUp: (event) -> this.handleKeyPress(event.keyCode, false)

    handleKeyPress: (keyCode, value) ->
        switch (keyCode)
            when cc.KEY.a, cc.KEY.left then Input.left = value
            when cc.KEY.d, cc.KEY.right then Input.right = value
            when cc.KEY.s, cc.KEY.down then Input.down = value
            when cc.KEY.w, cc.KEY.up then Input.up = value
            when cc.KEY.enter, cc.KEY.space then Input.pause = value
            when cc.KEY.escape then Input.escape = value

        if keyCode==cc.KEY.enter || keyCode==cc.KEY.space #remove
            cc.log(if value then "Input Paused!" else "Input Unpaused!")
}