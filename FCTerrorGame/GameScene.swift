//
//  GameScene.swift
//  FCTeste
//
//  Created by Adriano Soares on 04/08/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, UIGestureRecognizerDelegate, UIAlternateTapGestureRecognizerDelegate {
    var gameState = GameState.sharedInstance;
    var level: JSON!
    var background: SKSpriteNode?
   
    
    override func didMoveToView(view: SKView) {
        if let filePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "json") {
            level =  JSON(data: NSData(contentsOfFile: filePath)!)
        } else {
            level = JSON.nullJSON
        }
        
        var swipeLeft    = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        var swipeUp      = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        var swipeRight   = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        var swipeDown    = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        var alternateTap = UIAlternateTapGestureRecognizer(target: self, action: Selector("alternateTapping:"));
        
        
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        alternateTap.numberOfTapsRequired = 5;
        alternateTap.delegate = self
        
        view.addGestureRecognizer(alternateTap)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
        loadRoom()
        Singleton.playBGSound("asylum", frmt: "mp3")
    }

    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Level Functions
    
    func loadRoom () {
        background = SKSpriteNode(imageNamed: level[gameState.room]["background"].stringValue)
        background?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        if let bg = background {
            addChild(bg)
        }
        gameState.saveState()
        

    }

    // MARK: Controls

    
    func swipeLeft(gesture: UISwipeGestureRecognizer) {
        doAction("swipeLeft")
    }
    
    func swipeUp(gesture: UISwipeGestureRecognizer) {
        doAction("swipeUp")
    }
    func swipeRight(gesture: UISwipeGestureRecognizer) {
        doAction("swipeRight")
       
    }
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        doAction("swipeDown")
    }
    
    func didTap(gesture: UIAlternateTapGestureRecognizer) {
        doAction("tap")
    }
    
    func alternateTapping(gesture: UITapGestureRecognizer) {
        doAction("alternateTap");
    
    }
    
    func doAction(name: String) {
        let event = level[gameState.room]["events"][name]
        if (event.description != "null") {
            switch event["action"].stringValue {
            case "pickItem":
                pickItem(event)
                break;
            case "gotoRoom":
                goToRoom(event)
                break;
                
            default:
                break;
                
            }
            
        }
    }
    
    func checkPrerequisite (action: JSON) -> Bool {
        if let prerequisite = action["prerequisite"].string {
            var items = gameState.items.filter( {$0 == prerequisite } )
            if (items.count > 0) {
                return true;
            } else {
                if let failPrerequisite = action["failPrerequisite"].array {
                    println("locked")
                    playSoundArray(failPrerequisite)
                }
                
                
                return false;
            }
        } else {
            return true;
        }
    }
    
    func checkItem (action: JSON) -> Bool {
        if let item = action["item"].string {
            var items = gameState.items.filter( {$0 == item } )
            if (items.count > 0) {
                if let hasItem = action["hasItem"].array {
                    println("hasItem")
                    playSoundArray(hasItem)
                }
                return false;
            }
        }
        
        return true;
    }

    
    // MARK: Actions

    func goToRoom (action :JSON) {
        if (checkPrerequisite(action)) {
            gameState.room = action["room"].intValue
            gameState.updateState()
            var transition = SKTransition.fadeWithDuration(1)
            var scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        
    }
    
    func pickItem (action :JSON) {
        if (checkPrerequisite(action) && checkItem(action)) {
            gameState.items.append(action["item"].stringValue)
            gameState.updateState()
            
        }
    
    }
    
    func playSoundArray (action : [JSON]) {
        for sound: JSON in action {
            playSound(sound.dictionaryValue)
        }
    }
    
    func playSound (action: [String: JSON]) {
        if let soundName = action["sound"]?.string {
            if let format = action["format"]?.string{
                var x = action["x"]?.float
                var y = action["y"]?.float
                var offset = action["offset"]?.float
                runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(NSTimeInterval(offset!)),
                        SKAction.runBlock({ Singleton.addSoundArray(soundName, frmt: format, x: x!, y: y!) })
                        ])
                    )
            }
        }

    }
}