###
Base Class
###
cc.Class {
    extends: cc.Component
    properties:
        explosionPrefab: cc.Prefab

        # Properties
        RigidBody:
            visible: false
            get: ->
                return false if CC_EDITOR
                this._rigidBody ?= this.node.getComponent(cc.RigidBody)
                return this._rigidBody

    explode: () ->
        if this.explosionPrefab
            explosion = cc.instantiate(this.explosionPrefab)
            this.node.parent.addChild(explosion)
            explosion.setPosition(this.node.position)
        this.finish()

    finish: () -> this.node.destroy()
}