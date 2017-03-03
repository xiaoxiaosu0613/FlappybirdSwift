//
//  Player.swift
//  FlappyBirdSwift
//
//  Created by jamesSU on 2017/3/1.
//  Copyright © 2017年 Arp77. All rights reserved.
//

import UIKit
import SpriteKit

class Player: SKSpriteNode {
    
    let categoryBitMask = 0x1 << 0
    let density = 1.15
    
    convenience init() {
        self.init(imageNamed: "bird")
        self.size = CGSize(width: 32, height: 25)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.density = CGFloat(density)
        self.physicsBody?.categoryBitMask = UInt32(categoryBitMask)
    }
    
}
