//
//  GameScene.swift
//  FlappyBirdSwift
//
//  Created by jamesSU on 2017/3/1.
//  Copyright © 2017年 Arp77. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode = {
        let label = SKLabelNode(fontNamed: "Helvetica")
        return label
    }();
    private var player : Player?
    private var spinnyNode : SKShapeNode?
    private var score : Int = 0 {
        didSet {
           self.label.text = "\(score)"
        }
    }
    private var groud : SKSpriteNode = {
        let groud = SKSpriteNode(imageNamed: "Ground")
        groud.physicsBody = SKPhysicsBody(rectangleOf: groud.size)
        groud.physicsBody?.affectedByGravity = false
        groud.physicsBody?.isDynamic = false
        return groud
    }();
    let pipCategoryBitMask = 0x1 << 1
    let groudCategoryBitMask = 0x1 << 2
    var pipeTimer : Timer?
    var scoreTimer : Timer?
    var pipeSoundAction : SKAction?
    var punchSoundAction : SKAction?
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor(colorLiteralRed: 0.61, green: 0.74, blue: 0.86, alpha: 1)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.contactDelegate = self
        
        pipeSoundAction = SKAction.playSoundFileNamed("pipe.mp3", waitForCompletion: false)
        punchSoundAction = SKAction.playSoundFileNamed("punch3.mp3", waitForCompletion: false)
        
        //设置中心矩形,前两个值是中心矩形起始位置/总尺寸，后两个点是矩形尺寸/总尺寸，一般都是四角不缩放,中心部分缩放
       let groudH: CGFloat = 56.0
       groud.centerRect = CGRect(x: 26.0/groudH, y: 26.0/groudH, width: 4.0/groudH, height: 4.0/groudH)
       groud.xScale = self.size.width / groudH
       groud.position = CGPoint(x: self.size.width/2, y: groud.size.height/2)
       groud.physicsBody?.categoryBitMask = UInt32(groudCategoryBitMask)
       self.addChild(groud)
        
       label.position =  CGPoint(x: self.size.width/2, y: self.size.height - 50)
       self.addChild(label)
        
       player = Player()
       player?.physicsBody?.affectedByGravity = false
       player?.physicsBody?.collisionBitMask = UInt32(groudCategoryBitMask) | UInt32(pipCategoryBitMask)
       player?.physicsBody?.contactTestBitMask = UInt32(groudCategoryBitMask) | UInt32(pipCategoryBitMask)
       player?.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
       self.addChild(player!)
        
       groud.physicsBody?.collisionBitMask =  UInt32(player!.categoryBitMask)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (player?.physicsBody?.velocity.dy)! > CGFloat(400.0) {
            player?.physicsBody?.velocity = CGVector(dx: (player?.physicsBody?.velocity.dx)!, dy: 400.0)
        }
        
        if (player?.position.y)! >= self.size.height {
            player?.position = CGPoint(x: (player?.position.x)!, y: self.size.height)
        }
    }
    
    func addPipe() {
        let gapH: CGFloat = 150.0
        let centerY = random(min: gapH, max: self.size.height - gapH)
        let pipeTopHeight = centerY - (gapH / 2)
        let pipeBottomHeight = self.size.height - (centerY + (gapH / 2))
        bulidPipe(topOrBottom: true, height: pipeTopHeight)
        bulidPipe(topOrBottom: false, height: pipeBottomHeight)
    }
    
   @discardableResult func bulidPipe(topOrBottom: Bool, height: CGFloat) -> SKSpriteNode {
    
        let pipeWidth = 56.0
        let pipeTop = SKSpriteNode.init(imageNamed: topOrBottom ? "PipeTop" : "PipeBottom" )
        pipeTop.centerRect = CGRect(x: 26.0/pipeWidth, y: 26.0/pipeWidth, width: 4.0/pipeWidth, height: 4.0/pipeWidth)
        pipeTop.yScale = height/56.0
        pipeTop.position = topOrBottom ? CGPoint(x: self.size.width + (pipeTop.size.width / 2) , y: self.size.height - (pipeTop.size.height / 2)) : CGPoint(x: self.size.width + (pipeTop.size.width / 2) , y: (pipeTop.size.width / 2) + (56.0 - 2))
        self.addChild(pipeTop)
        
        pipeTop.physicsBody = SKPhysicsBody(rectangleOf: pipeTop.size)
        pipeTop.physicsBody?.affectedByGravity = false
        pipeTop.physicsBody?.isDynamic = false
        pipeTop.physicsBody?.categoryBitMask = UInt32(pipCategoryBitMask)
        pipeTop.physicsBody?.collisionBitMask = UInt32((player?.categoryBitMask)!)
        //pipeTop.physicsBody?.contactTestBitMask = UInt32((player?.categoryBitMask)!)
        let action = SKAction.moveTo(x: -(pipeTop.size.width/2), duration: 4.0)
        let seqence = SKAction.sequence([action, SKAction.run {
            pipeTop.removeFromParent()
            }])
        pipeTop.run(SKAction.repeatForever(seqence))
        
        return pipeTop
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
         return CGFloat(Float.random(lower: Float(min), Float(max)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = pipeTimer else {
            pipeTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
                self.addPipe()
            })
            
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (timer) in
                self.scoreTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
                    self.score += 1
                    self.run(self.pipeSoundAction!)
                })
            })

            player?.physicsBody?.affectedByGravity = true
            return
        }
        player?.physicsBody?.velocity = CGVector(dx: (player?.physicsBody?.velocity.dx)!, dy: 400.0)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let _ = contact.bodyA.node else {
            return
        }
        
        if (contact.bodyA.node!.isKind(of: player!.classForCoder)) {
            pipeTimer?.invalidate()
            scoreTimer?.invalidate()
            self.run(punchSoundAction!) {
                let transition = SKTransition.doorsCloseHorizontal(withDuration: 0.4)
                let mainScene = StartGameScene(size: self.size)
                self.view?.presentScene(mainScene, transition: transition)
            }
        }
    
    }
    
}

public extension Float {
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

