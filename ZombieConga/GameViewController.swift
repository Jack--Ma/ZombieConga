//
//  GameViewController.swift
//  ZombieConga
//
//  Created by JackMa on 16/6/21.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainMenuScene = MainMenuScene(size: CGSize(width: 2048, height: 1536))
        mainMenuScene.scaleMode = .AspectFill
        let skView = self.view as? SKView
        skView?.showsFPS = true
        skView?.showsNodeCount = true
        skView?.ignoresSiblingOrder = true
        skView?.presentScene(mainMenuScene)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
