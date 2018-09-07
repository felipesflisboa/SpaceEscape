NodeUtil = require('NodeUtil')

###
This script generates a collider for each tile on tilemap
###
cc.Class {
    extends: cc.Component

    editor:
        requireComponent: cc.TiledLayer

    properties:
        createOnLoad: true
        colliderPrefab: 
            default: null
            type: cc.Prefab
            tooltip: "When null, uses a default PhysicsBoxCollider"

    onLoad: ->
        this.create() if this.createOnLoad

    create: ->
        this.layer = this.node.getComponent(cc.TiledLayer)
        this.tilemap = this.node.parent.getComponent(cc.TiledMap)
        this.tileSize = this.layer.getMapTileSize()
        this.mapSizeInTiles = new cc.Size(
            this.tilemap.node.width/this.tileSize.width, 
            this.tilemap.node.height/this.tileSize.height
        )

        cc.log("before ms="+new Date().getMilliseconds()+" date=") #remove
        cc.log(new Date()) #remove

        for x in [0...(this.mapSizeInTiles.width)]
            for y in [0...(this.mapSizeInTiles.height)]
                posInTiles = cc.p(x,y)
                this.createColliderTile(posInTiles) if this.layer.getTileGIDAt(posInTiles)

        cc.log("after ms="+new Date().getMilliseconds()+" date=") #remove
        cc.log(new Date()) #remove

    createColliderTile: (posInTiles) ->
        tile = if this.colliderPrefab? then cc.instantiate(this.colliderPrefab) else this.buildColliderTile()
        this.node.addChild(tile)
        tile.setPosition(this.calculateTilePosition(posInTiles))
        return tile

    buildColliderTile: () ->
        tile = new cc.Node()
        tile.setContentSize(this.tileSize)
        tileRigidBody = tile.addComponent(cc.RigidBody)
        tileRigidBody.type = cc.RigidBodyType.Static
        tileCollider = tile.addComponent(cc.PhysicsBoxCollider)
        tileCollider.size = this.tileSize
        return tile

    calculateTilePosition: (posInTiles) ->
        return cc.p(
            (-(this.mapSizeInTiles.width - 1)/2 + posInTiles.x)*this.tileSize.width,
            ((this.mapSizeInTiles.height - 1)/2 - posInTiles.y)*this.tileSize.height,
        )
}