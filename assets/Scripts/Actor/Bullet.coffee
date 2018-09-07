cc.Class {
    extends: require('Actor')

    onLoad: ->
        this.direction = cc.p(0,0)
        this.speed = 300

    update: (dt) ->
        this.RigidBody.linearVelocity = this.direction.mul(this.speed)

    onBeginContact: (contact, selfCollider, otherCollider) ->
        # TODO explosion damage
        cc.log("Hit!");
        this.explode()
}