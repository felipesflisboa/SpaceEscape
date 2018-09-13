###
Heart rect who displays a heart for every value
###
cc.Class {
    extends: cc.Component

    properties: {
        spriteArray: [cc.Sprite]

        Value:
            visible: false
            get: -> this._value
            set: (newValue) -> 
                return if this._value? && this._value==newValue
                this._value = newValue
                this.refresh() # if this.spriteArray[0]? # Solving scene refresh bugs
    }

    refresh: ->
        for i in [0...this.spriteArray.length]
            this.spriteArray[i].node.active = this.Value > i
}