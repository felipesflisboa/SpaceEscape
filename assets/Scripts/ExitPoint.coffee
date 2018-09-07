GameManager = require('GameManager')
Player = require('Player')
NodeUtil = require('NodeUtil')

###
Stage exit point
###
cc.Class {
    extends: cc.Component

    onBeginContact: (contact, selfCollider, otherCollider) ->
        player = NodeUtil.getComponentInParent(otherCollider.node, Player)
        GameManager.i().stageClear() if player?
}