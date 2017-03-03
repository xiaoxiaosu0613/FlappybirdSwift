//
//  StartGameScene.swift
//  FlappyBirdSwift
//
//  Created by jamesSU on 2017/3/1.
//  Copyright © 2017年 Arp77. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class StartGameScene: SKScene {
    
    let startButton: SKLabelNode = {
        let button = SKLabelNode(text: "开始游戏")
        button.fontName = "Helvetica"
        return button
    }();
    
    override func didMove(to view: SKView) {
      self.backgroundColor = SKColor(colorLiteralRed: 0.61, green: 0.74, blue: 0.86, alpha: 1)
       startButton.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        self.addChild(startButton)
    }
    
    func startGame() {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
        let mainScene = GameScene(size: self.size)
        self.view?.presentScene(mainScene, transition: transition)
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
        let mainScene = GameScene(size: self.size)
        self.view?.presentScene(mainScene, transition: transition)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
