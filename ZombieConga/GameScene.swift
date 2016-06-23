//
//  GameScene.swift
//  ZombieConga
//
//  Created by JackMa on 16/6/21.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    var lastUpdateTime: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    let zombieMovePointsPerSec: CGFloat = 480.0
    var velocity = CGPointZero
    let playableRect: CGRect
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0  //16:9屏幕下
        let playableHeight = size.width / maxAspectRatio    //可显示的高度
        let playableMargin = (size.height-playableHeight) / 2.0 //无法显示的高度，上下边缘部分
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight)
        
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
        
        debugDrawPlayableArea()
    }
   
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
        moveSprite(zombie, velocity: velocity)
        boundsCheckZombie()
        rotateSprite(zombie, direction: velocity)
    }
    
    //移动zombie
    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = velocity * CGFloat(dt)
//        print("Amount to move: \(amountToMove)")
        sprite.position += amountToMove
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
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = direction.angel
    }
    
    // MARK: touch action
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self)
        sceneTouched(touchLocation)
    }
    
    //change velocity
    func sceneTouched(touchLocation: CGPoint) {
        moveZombieToward(touchLocation)
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = location - zombie.position
        let length = offset.length()
        let direction = offset / length
        
        velocity = direction * zombieMovePointsPerSec
    }
    
}
