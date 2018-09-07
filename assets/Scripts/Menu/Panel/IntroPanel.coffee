###
A simple paged subpanel
###
cc.Class {
    extends: require('Panel')
        
    properties:
        subpanelArray: [cc.Node]

    onEnable: ->
        this.index = 0
        this.refreshActiveSubpanel()

    refreshActiveSubpanel: () ->
        for i in [0...this.subpanelArray.length]
            this.subpanelArray[i].active = i == this.index

    onConfirm: ->
        this._super()
        last =  this.index == this.subpanelArray.length - 1
        if last
            this.finish()
        else
            this.index++
            this.refreshActiveSubpanel()

    finish: -> this.onFinish()
}