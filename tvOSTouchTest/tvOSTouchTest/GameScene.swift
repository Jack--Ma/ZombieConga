//
//  GameScene.swift
//  tvOSTouchTest
//
//  Created by JackMa on 16/7/11.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    let pressLabel = SKLabelNode(fontNamed: "Chalkduster")
    let touchBox = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 100))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        pressLabel.text = "Move your finger!"
        pressLabel.fontSize = 200
        pressLabel.verticalAlignmentMode = .Center
        pressLabel.horizontalAlignmentMode = .Center
        pressLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(pressLabel)
        
        addChild(touchBox)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            touchBox.position = location
        }
    }
   
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            touchBox.position = location
        }
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
                case .UpArrow:
                    pressLabel.text = "Up arrow"
                case .DownArrow:
                    pressLabel.text = "Down arrow"
                case .LeftArrow:
                    pressLabel.text = "Left arrow"
                case .RightArrow:
                    pressLabel.text = "Right arrow"
                case .Select:
                    pressLabel.text = "Select"
                case .Menu:
                    pressLabel.text = "Menu"
                case .PlayPause:
                    pressLabel.text = "Play/Pause"
            }
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        self.removeAllActions()
        runAction(SKAction.sequence([
            SKAction.waitForDuration(1.0),
            SKAction.runBlock() {
                self.pressLabel.text = ""
            }
        ]))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
