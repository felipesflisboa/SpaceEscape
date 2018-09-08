GameManager = require('GameManager')
NodeUtil = require('NodeUtil')

cc.Class {
    extends: cc.Component

    properties:
        startNode: cc.Node

        Number:
            visible: false
            get: ->
                return 0 if CC_EDITOR
                if !this._number?
                    this._number = GameManager.i().sceneNameArray.indexOf(cc.director.getScene().name)
                    # For won't break when starting a scene as standalone in editor
                    this._number = 1 if this._number==-1
                return this._number

    onLoad: ->
        this.bgm = this.node.getComponent(cc.AudioSource)
        this.fixTilemapTextureAlias(this.node.getComponentInChildren(cc.TiledMap))

    initialize: ->
        this.node.getComponentInChildren(require('TilemapColliderCreator')).create()
        this.node.addChild(GameManager.i().player.node)
        GameManager.i().player.node.setPosition(this.calculateStartPosition())

    calculateStartPosition: ->
        return this.node.convertToNodeSpaceAR(this.startNode.convertToWorldSpaceAR(cc.p(0,-16)))

    fixTilemapTextureAlias: (tilemap) ->
        orly = tilemap.allLayers() #test
        for layer in tilemap.allLayers()
            # texture = layer.getTexture()
            texture = layer._sgNode._texture
            texture.setAliasTexParameters()
            # layer.setTexture(texture)
            layer._sgNode._texture = texture
}