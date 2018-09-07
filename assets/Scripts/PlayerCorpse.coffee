###
A small dead animation who "jumps" into screen.
###
cc.Class {
    extends: cc.Component

    onLoad: ->
        jumpUp = cc.moveBy(0.6, cc.p(0, 16)).easing(cc.easeCubicActionOut())
        jumpFall = cc.moveBy(1.2, cc.p(0, -256)).easing(cc.easeCubicActionIn())
        this.node.runAction(cc.sequence([jumpUp, jumpFall, cc.callFunc(this.finish, this)]))

    finish: () -> this.node.destroy()
}