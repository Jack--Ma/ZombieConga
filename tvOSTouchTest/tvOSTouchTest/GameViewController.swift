//
//  GameViewController.swift
//  tvOSTouchTest
//
//  Created by JackMa on 16/7/11.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    let gameScene = GameScene(size: CGSize(width: 2048, height: 1536))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        gameScene.scaleMode = .AspectFill
        skView.presentScene(gameScene)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        gameScene.pressesBegan(presses, withEvent: event)
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        gameScene.pressesEnded(presses, withEvent: event)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}
