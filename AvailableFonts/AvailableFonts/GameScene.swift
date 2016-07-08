//
//  GameScene.swift
//  AvailableFonts
//
//  Created by JackMa on 16/7/8.
//  Copyright (c) 2016年 JackMa. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var familyIndex: Int = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        showCurrentFamily()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    func showCurrentFamily() {
        removeAllChildren()
        let familyName = UIFont.familyNames()[familyIndex]
        print("Family: \(familyName)")
        
        let fontNames = UIFont.fontNamesForFamilyName(familyName)
        
        for (index, fontName) in fontNames.enumerate() {
            let label = SKLabelNode(fontNamed: fontName)
            label.text = fontName
            label.position = CGPoint(x: size.width/2, y: size.height*CGFloat(index+1)/CGFloat(fontNames.count+1))
            label.fontSize = 50
            label.verticalAlignmentMode = .Center
            addChild(label)
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        familyIndex += 1
        
        if familyIndex >= UIFont.familyNames().count {
            familyIndex = 0
        }
        showCurrentFamily()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
