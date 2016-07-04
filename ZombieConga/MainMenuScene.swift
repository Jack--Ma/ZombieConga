//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by JackMa on 16/7/4.
//  Copyright © 2016年 JackMa. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    override func didMoveToView(view: SKView) {
        let backgroundImage = SKSpriteNode(imageNamed: "MainMenu.png")
        backgroundImage.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(backgroundImage)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        let transition = SKTransition.doorwayWithDuration(1.5)
        self.view?.presentScene(gameScene, transition: transition)
    }
}