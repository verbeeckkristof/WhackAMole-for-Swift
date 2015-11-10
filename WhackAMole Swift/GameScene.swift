//
//  GameScene.swift
//  WhackAMole Swift
//
//  Created by kristof verbeeck on 30/08/14.
//  Copyright (c) 2014 KCFoundation Dev - Kristof Verbeeck. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    var moles:NSMutableArray = []
    var moleTexture = "mole_1.png"
    let kMoleHoleOffset = 155.0
    var laughArray:NSMutableArray = []
    var hitArray:NSMutableArray = []
    var laughAnimation:SKAction!
    var hitAnimation:SKAction!
    var scoreLabel:SKLabelNode = SKLabelNode(fontNamed: "Chalkduster")
    var score:Int = 0
    var totalSpawns:Int = 0
    var gameOver:Bool = false
    var laughSound:SKAction!
    var hitSound:SKAction!
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        let Dirt:SKSpriteNode = SKSpriteNode(imageNamed: "Dirt")
        Dirt.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        Dirt.name = "Dirt"
        Dirt.xScale = 2.0
        Dirt.yScale = 2.0
        self.addChild(Dirt)
        
        let Lower:SKSpriteNode = SKSpriteNode(imageNamed: "GrassLow")
        Lower.anchorPoint = CGPointMake(0.5, 1.0);
        Lower.name = "Lower"
        Lower.zPosition = 999
        Lower.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        let Upper:SKSpriteNode = SKSpriteNode(imageNamed: "GrassHigh")
        Upper.anchorPoint = CGPointMake(0.5, 0.0);
        Upper.name = "Upper"
        Upper.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        self.addChild(Upper)
        
        let moleCenter:Float = 240.0
        
        let mole1:SKSpriteNode = SKSpriteNode(imageNamed: "Mole")
        mole1.anchorPoint = CGPointMake(0.8, 0.0)
        mole1.position = CGPointMake((CGRectGetMidX(self.frame) / 2), 130)
        mole1.name = "Mole"
        mole1.userData = NSMutableDictionary()
        self.addChild(mole1)
        moles.addObject(mole1)
        
        let mole2:SKSpriteNode = SKSpriteNode(imageNamed: "Mole")
        mole2.anchorPoint = CGPointMake(0.5, 0.0)
        mole2.position = CGPointMake((CGRectGetMidX(self.frame)), 130)
        mole2.name = "Mole"
        mole2.userData = NSMutableDictionary()
        self.addChild(mole2)
        moles.addObject(mole2)
        
        let mole3:SKSpriteNode = SKSpriteNode(imageNamed: "Mole")
        mole3.anchorPoint = CGPointMake(0.9, 0.0)
        mole3.position = CGPointMake((CGRectGetMaxX(self.frame)-(CGRectGetMidX(self.frame)/4)), 130)
        mole3.name = "Mole"
        mole3.userData = NSMutableDictionary()
        self.addChild(mole3)
        moles.addObject(mole3)
        
        self.addChild(Lower)
        for index in 1...3 {
            print("Laugh\(index)")
            laughArray.addObject(SKTexture(imageNamed: "Laugh\(index)"))
        }
        
        laughAnimation = SKAction.animateWithTextures(laughArray as [AnyObject] as! [SKTexture], timePerFrame: 0.2)
        
        for index in 1...4 {
            print("Hit\(index)")
            hitArray.addObject(SKTexture(imageNamed: "Hit\(index)"))
        }
        
        hitAnimation = SKAction.animateWithTextures(hitArray as [AnyObject] as! [SKTexture], timePerFrame: 0.2)
        
        scoreLabel.text = "Score : 0"
        scoreLabel.name = "scoreLabel"
        scoreLabel.fontSize = 60
        scoreLabel.zPosition = 999999
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + (scoreLabel.frame.height * 4))
        self.addChild(scoreLabel)
        
        laughSound = SKAction.playSoundFileNamed("laugh.caf", waitForCompletion: false)
        hitSound = SKAction.playSoundFileNamed("ow.caf", waitForCompletion: false)
        
        let musicURL = NSBundle.mainBundle().URLForResource("whack", withExtension: "caf")
        var error : NSError? = nil
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOfURL: musicURL!)
        } catch let error1 as NSError {
            error = error1
            //backgroundMusicPlayer = nil
        }
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.volume = 0.1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let node:SKNode = nodeAtPoint(location)
            if (node.name == "Mole") {
                let mole:SKSpriteNode = node as! SKSpriteNode
                print("MOLE")
//                if ((node.userData.objectForKey("tappable")?.boolValue) != nil) {
//                    return
//                }
                score += 10
                scoreLabel.text = "Score : \(score)"
                mole.userData?.setObject(0, forKey: "tappable")
                mole.removeAllActions()
                let easeMoveDown:SKAction = SKAction.moveToY(mole.position.y - mole.size.height, duration: 0.2)
                easeMoveDown.timingMode = SKActionTimingMode.EaseOut
                
                let sequence:SKAction = SKAction.sequence([hitSound, hitAnimation, easeMoveDown])
                mole.runAction(sequence)
            } else {
                return
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if gameOver == true {return}
        
        if totalSpawns >= 50 {
            let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.text = "Level Completed"
            gameOverLabel.name = "scoreLabel"
            gameOverLabel.fontSize = 70
            gameOverLabel.zPosition = 9999999
            gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            self.addChild(gameOverLabel)
        }
        
        for mole in moles {
            //println()
            if (arc4random() % 5 == 0) {
                //println(mole.position.y)
                if (mole.position.y == 130.0 as CGFloat) {
                    popMole(mole as! SKSpriteNode)
                }
            }
        }
    }
    
    func popMole(mole:SKSpriteNode) {
        if totalSpawns > 50 {return}
        totalSpawns++
        mole.texture = SKTexture(imageNamed: "Mole")
        
        let easeMoveUp:SKAction = SKAction.moveToY(mole.position.y + mole.size.height, duration: 0.2)
        easeMoveUp.timingMode = SKActionTimingMode.EaseOut
        let easeMoveDown:SKAction = SKAction.moveToY(mole.position.y, duration: 0.2)
        easeMoveDown.timingMode = SKActionTimingMode.EaseOut
        
        let setTappable:SKAction = SKAction.runBlock { () -> Void in
            mole.userData?.setObject(0, forKey: "tappable")
            return Void()
        }
        
        let unsetTappable:SKAction = SKAction.runBlock { () -> Void in
            mole.userData?.setObject(0, forKey: "tappable")
            return Void()
        }
        
        //var delay:SKAction = SKAction.waitForDuration(0.5)
        let sequence:SKAction = SKAction.sequence([easeMoveUp, setTappable, laughSound, laughAnimation, unsetTappable, easeMoveDown])
        mole.runAction(sequence)
    }
}
