//
//  GameScene.swift
//  HarryPotterVersion1
//
//  Created by rdadmin on 8/22/17.
//  Copyright © 2017 Jennifer Roscoe. All rights reserved.
//

import SpriteKit
import GameplayKit
struct PhysicsCategory {
    static let None : UInt32 = 0
    static let All : UInt32 = UInt32.max
    static let Monster : UInt32 = 0b1 //smallest number
    static let Projectile : UInt32 = 0b10//second smallest number, this would beet monster bc larger
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
     let backgroundImage = SKSpriteNode(imageNamed: "hpquidbackground")
    
    let player = SKSpriteNode(imageNamed: "goldensnitch")
  
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        player.size = CGSize(width: 144, height: 68)
        
        player.position = CGPoint(x: frame.midX + (frame.midX/2), y: frame.midY + (frame.midY/1.70))
       // player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)//place ninja character at location
        
        
        backgroundImage.size = CGSize(width: 627, height: 500)
       backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)//place ninja character at location
        
        player.zPosition = 2//player is above background
        addChild(backgroundImage)
        addChild(player)//add ninja to scene
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        
        
        /*  let backgroundMusic = SKAudioNode(fileNamed: "gameMusic.mp3")
         backgroundMusic.autoplayLooped = true
         addChild(backgroundMusic)*/
    }
    
    //projectile functons
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)//throwing star
    {
        //run(SKAction.playSoundFileNamed("pew.caf", waitForCompletion: false))
        
        
        
        guard let touch = touches.first else{ return }
        let touchLocation = touch.location(in: self)
        let projectile = SKSpriteNode(imageNamed: "goldensnitch")
        
        
        
        projectile.size = CGSize(width: 144, height: 68)
        projectile.position = CGPoint(x: frame.midX + (frame.midX/2), y: frame.midY + (frame.midY/1.70))
//place ninja character at location
        
         projectile.zPosition = 2
        addChild(projectile)
        player.removeFromParent()
        
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/1)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        //projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        
        
        if (offset.x < 0)//won't throw behind ninja
        {
            return
        }
        
        //addChild(projectile)
        
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        let actionMove =  SKAction.move(to: realDest, duration: 2.0)//create movement of star
        
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    
}
