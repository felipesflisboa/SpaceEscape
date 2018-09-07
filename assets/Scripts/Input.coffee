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

        register: () ->
            this._singleton = new (require('Input'))()
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this._singleton.onKeyDown, this._singleton)
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this._singleton.onKeyUp, this._singleton)

        unregister: () ->
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
}