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
        callbackArray: null

        reset: ->
            this.left = false
            this.right = false
            this.down = false
            this.up = false
            this.callbackArray = []

        register: ->
            this.reset()
            this._singleton = new (require('Input'))()
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this._singleton.onKeyDown, this._singleton)
            cc.systemEvent.on(cc.SystemEvent.EventType.KEY_UP, this._singleton.onKeyUp, this._singleton)

        unregister: ->
            cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this._singleton.onKeyDown, this._singleton)
            cc.systemEvent.off(cc.SystemEvent.EventType.KEY_UP, this._singleton.onKeyUp, this._singleton)

        registerCallback: (callback, keys...) -> 
            for key in keys
                this.callbackArray[key] = callback

    onKeyDown: (event) -> this.handleKeyPress(event.keyCode, true)

    onKeyUp: (event) -> this.handleKeyPress(event.keyCode, false)

    handleKeyPress: (keyCode, value) ->
        if value && Input.callbackArray.length > keyCode && Input.callbackArray[keyCode]?
            Input.callbackArray[keyCode]()
        switch (keyCode)
            when cc.KEY.a, cc.KEY.left then Input.left = value
            when cc.KEY.d, cc.KEY.right then Input.right = value
            when cc.KEY.s, cc.KEY.down then Input.down = value
            when cc.KEY.w, cc.KEY.up then Input.up = value
}