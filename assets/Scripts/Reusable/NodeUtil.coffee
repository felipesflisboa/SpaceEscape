###
Change color, including alpha.
###
module.exports.changeColorAndAlpha = (node, newColor) ->
    node.color = cc.color(newColor.r, newColor.g, newColor.b)
    node.opacity = newColor.a

###
Change node parent, without changing position or rotation.
###
module.exports.changeParent = (node, newParent) ->
    return if node.parent == newParent
    getWorldRotation = (node) ->
        currNode = node
        resultRot = currNode.rotation
        loop
            currNode = currNode.parent
            resultRot += currNode.rotation
            break if !currNode.parent?
        resultRot = resultRot % 360
        return resultRot

    oldWorRot = getWorldRotation(node)
    newParentWorRot = getWorldRotation(newParent)
    newLocRot = oldWorRot - newParentWorRot

    oldWorPos = node.convertToWorldSpaceAR(cc.p(0,0))
    newLocPos = newParent.convertToNodeSpaceAR(oldWorPos)

    node.parent = newParent
    node.position = newLocPos
    node.rotation = newLocRot

###
GetComponentInChildren, but including self on search.
###
module.exports.getComponentInChildrenInclusive = (node, classValue) ->
    ret = node.getComponent(classValue)
    return ret if ret?
    ret = node.getComponentInChildren(classValue)
    return ret

###
GetComponentsInChildren, but including self on search.
###
module.exports.getComponentsInChildrenInclusive = (node, classValue) ->
    return node.getComponentsInChildren(classValue).concat(node.getComponents(classValue))

    
###
GetComponentInParent
###
module.exports.getComponentInParent = (node, classValue) ->
    currNode = node
    while currNode != cc.director.getScene()
        component = currNode.getComponent(classValue)
        return component if component?
        currNode = currNode.parent
    return null

###
Copy node B in node A, except name
###
module.exports.copyNodeProperties = (a, b) ->
    a.position = b.position
    a.rotation = b.rotation
    a.scale = b.scale
    a.anchor = b.anchor
    a.width = b.width
    a.height = b.height
    a.color = b.color
    a.opacity = b.opacity
    a.skew = b.skew
    a.group = b.group