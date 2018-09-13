GameManager = require('GameManager')

cc.Class {
    extends: cc.Component

    properties:
        debugIndex: -1

        GameEnded:
            visible: false
            get: -> !CC_EDITOR && GameManager.data? && GameManager.data.endTime?

    onLoad: ->
        cc.view.enableAntiAlias(false)
        this.initializePanels()
        cc.systemEvent.on(cc.SystemEvent.EventType.KEY_DOWN, this.onInput, this)

    start: ->
        if CC_DEBUG && this.debugIndex>-1
            this.goToPanel(this.panelArray[this.debugIndex])
        else if this.GameEnded
            this.goToPanel(this.resultsPanel)
        else
            this.goToPanel(this.introPanel)

    initializePanels: ->
        this.resultsPanel = this.node.getComponentInChildren(require('ResultsPanel'))
        this.introPanel = this.node.getComponentInChildren(require('IntroPanel'))
        this.titlePanel = this.node.getComponentInChildren(require('TitlePanel'))
        this.panelArray = [this.resultsPanel, this.introPanel, this.titlePanel]
        for panel in this.panelArray
            panel.onFinish = this.goToNextPanel.bind(this)

    enablePanel: (panel) ->
        for p in this.panelArray
            p.node.active = panel == p

    goToPanel: (panel) ->
        this.currentPanelIndex = this.panelArray.indexOf(panel)
        this.enablePanel(panel)

    goToNextPanel: () ->
        this.goToPanel(this.panelArray[this.currentPanelIndex+1])

    onInput: (event) ->
        switch (event.keyCode)
            when cc.KEY.enter, cc.KEY.space, cc.KEY.ctrl then this.panelArray[this.currentPanelIndex].onConfirm()

    onDestroy: -> cc.systemEvent.off(cc.SystemEvent.EventType.KEY_DOWN, this.onInput, this)
}