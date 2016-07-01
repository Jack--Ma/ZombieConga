//
//  GameScene.swift
//  ZombieConga
//
//  Created by JackMa on 16/6/21.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let catCollisionSound: SKAction = SKAction.playSoundFileNamed(
        "hitCat.wav", waitForCompletion: false)
    let enemyCollisionSound: SKAction = SKAction.playSoundFileNamed(
        "hitCatLady.wav", waitForCompletion: false)
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    var lastTouchLocation: CGPoint = CGPointZero
    
    let zombieMovePointsPerSec: CGFloat = 480.0
    let zombieRotateRadiansPerSec: CGFloat = 4.0 * π
    
    var velocity = CGPointZero
    let playableRect: CGRect
    let zombieAnimation: SKAction
    
    var invincible = false
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0  //16:9屏幕下
        let playableHeight = size.width / maxAspectRatio    //可显示的高度
        let playableMargin = (size.height-playableHeight) / 2.0 //无法显示的高度，上下边缘部分
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
        var textures: [SKTexture] = []
        for i in 1...4 {
            textures.append(SKTexture(imageNamed: "zombie\(i)"))
        }
        textures.append(textures[2])
        textures.append(textures[1])
        zombieAnimation = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        backgroundColor = SKColor.blackColor()
        
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        self.addChild(background)
        
        zombie.position = CGPoint(x: 400, y: 400)
        self.addChild(zombie)
        
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnEnemy), SKAction.waitForDuration(2.0)])))
        runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.runBlock(spawnCat), SKAction.waitForDuration(1.0)])))
        debugDrawPlayableArea()
    }
   
    //绘制女巫
    func spawnEnemy() {
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "enemy"
        enemy.position = CGPoint(x: size.width + enemy.size.width/2,
                                 y: CGFloat.random(
                                    min: CGRectGetMinY(playableRect) + enemy.size.height/2,
                                    max: CGRectGetMaxY(playableRect) - enemy.size.height/2))
        addChild(enemy)
        
        let actionMove = SKAction.moveToX(-enemy.size.width/2, duration: 2.0)
        let actionRemove = SKAction.removeFromParent()
        
        enemy.runAction(SKAction.sequence([actionMove, actionRemove]))
    }
    
    //绘制红色边界线
    func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGPathCreateMutable()
        CGPathAddRect(path, nil, playableRect)
        shape.path = path
        shape.strokeColor = SKColor.redColor()
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        //到达位置时，停止zombie
        if (lastTouchLocation - zombie.position).length() <= zombieMovePointsPerSec * CGFloat(dt) {
            zombie.position = lastTouchLocation
            velocity = CGPointZero
            stopZombieAnimation()
            return
        }
        moveSprite(zombie, velocity: velocity)
        rotateSprite(zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
        moveTrain()
    }
    
    override func didEvaluateActions() {
        checkCollosion()
    }
    
    //移动zombie
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
//        print("Amount to move: \(amountToMove)")
        sprite.position += amountToMove
    }
    
    func startZombieAnimation() {
        if zombie.actionForKey("animation") == nil {
            zombie.runAction(SKAction.repeatActionForever(zombieAnimation), withKey: "animation")
        }
    }
    
    func stopZombieAnimation() {
        zombie.removeActionForKey("animation")
    }
    
    //控制zombie在可显示区域内
    func boundsCheckZombie() {
        if zombie.position.x <= 0.0 {
            zombie.position.x = 0.0
            velocity.x = -velocity.x
        }
        if zombie.position.x >= size.width {
            zombie.position.x = size.width
            velocity.x = -velocity.x
        }
        if zombie.position.y <= CGRectGetMinY(playableRect) {
            zombie.position.y = CGRectGetMinY(playableRect)
            velocity.y = -velocity.y
        }
        if zombie.position.y >= CGRectGetMaxY(playableRect) {
            zombie.position.y = CGRectGetMaxY(playableRect)
            velocity.y = -velocity.y
        }
    }
    
    //旋转zombie
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(sprite.zRotation, angle2: direction.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        
        sprite.zRotation += shortest.sign() * amountToRotate
    }
    
    //产生cat
    func spawnCat() {
        let cat = SKSpriteNode(imageNamed: "cat")
        cat.name = "cat"
        cat.position = CGPoint(x: CGFloat.random(min: CGRectGetMinX(playableRect), max: CGRectGetMaxX(playableRect)),
                               y: CGFloat.random(min: CGRectGetMinY(playableRect), max: CGRectGetMaxY(playableRect)))
        
        cat.setScale(0)
        addChild(cat)
        
        let appear = SKAction.scaleTo(1.0, duration: 0.5)
        let disappear = SKAction.scaleTo(0, duration: 0.5)
        let removeFromParent = SKAction.removeFromParent()
        
        cat.zRotation = -π/16.0
        let leftWiggle = SKAction.rotateByAngle(π/8.0, duration: 0.5)
        let rightWiggle = leftWiggle.reversedAction()
        let fullWiggle = SKAction.sequence([leftWiggle, rightWiggle])
        
        let scaleUp = SKAction.scaleBy(1.2, duration: 0.25)
        let scaleDown = scaleUp.reversedAction()
        let fullScale = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleDown])
        let group = SKAction.group([fullScale, fullWiggle])//同时进行两个action
        let groupWait = SKAction.repeatAction(group, count: 10)//重复10次
        
        cat.runAction(SKAction.sequence([appear, groupWait, disappear, removeFromParent]))
    }
    
    func zombieHitCat(cat: SKSpriteNode) {
        cat.name = "train"
        cat.removeAllActions()
        cat.setScale(1.0)
        cat.zRotation = 0
//        cat.removeFromParent()
        let turnGreen = SKAction.colorizeWithColor(SKColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        cat.runAction(turnGreen)
        runAction(catCollisionSound)
    }
    
    func zombieHitEnemy(enemy: SKSpriteNode) {
        enemy.removeFromParent()
        runAction(enemyCollisionSound)
        
        invincible = true
        let blinkTimes = 10.0
        let duration = 3.0
        let blinkAction = SKAction.customActionWithDuration(duration) { (node, time) in
            let slice = Double(duration) / Double(blinkTimes)
            let remainder = Double(time) % slice
            node.hidden = remainder > slice / 2
        }
        let setHidden = SKAction.runBlock() {
            self.zombie.hidden = false
            self.invincible = false
        }
        zombie.runAction(SKAction.sequence([blinkAction, setHidden]))
        
    }
    
    func checkCollosion () {
        var hitCats: [SKSpriteNode] = []
        
        enumerateChildNodesWithName("cat") { (node, _) in
            let cat = node as! SKSpriteNode
            if CGRectIntersectsRect(cat.frame, self.zombie.frame) {
                hitCats.append(cat)
            }
        }
        for cat in hitCats {
            zombieHitCat(cat)
        }
        if invincible {
            return
        }
        var hitEnemies: [SKSpriteNode] = []
        enumerateChildNodesWithName("enemy") { (node, _) in
            let enemy = node as! SKSpriteNode
            if CGRectIntersectsRect(CGRectInset(node.frame, 20, 20), self.zombie.frame) {
                hitEnemies.append(enemy)
            }
        }
        for enemy in hitEnemies {
            zombieHitEnemy(enemy)
        }
    }
    
    func moveTrain() {
        var targetPosition = zombie.position
        enumerateChildNodesWithName("train") { (node, stop) in
            if !node.hasActions() {
                let actionDuration = 0.3
                let offset = targetPosition - node.position
                let direction = offset.normalized()
                let amountToMoveSec = direction * self.zombieMovePointsPerSec
                let amountToMove = amountToMoveSec * CGFloat(actionDuration)
                let moveAction = SKAction.moveByX(amountToMove.x, y: amountToMove.y, duration: actionDuration)
                node.runAction(moveAction)

            }
            targetPosition = node.position
        }
    }
    // MARK: touch action
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        lastTouchLocation = touchLocation
        sceneTouched(touchLocation)
    }
    
    //change velocity
    func sceneTouched(touchLocation: CGPoint) {
        moveZombieToward(touchLocation)
    }
    
    func moveZombieToward(location: CGPoint) {
        startZombieAnimation()

        let offset = location - zombie.position
        let length = offset.length()
        let direction = offset / length
        
        velocity = direction * zombieMovePointsPerSec
    }
    
}
