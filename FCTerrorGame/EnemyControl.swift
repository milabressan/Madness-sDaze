//
//  EnemyControl.swift
//  MadnessDaze
//
//  Created by Rafael on 20/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import SpriteKit
class EnemyControl{
    var manager = GameManager.sharedInstance
    var enemies = [EnemyBot]()
    var enemiesJson: JSON!
    var enemiesPosition = [Int]()
    init(){
        if(manager.enemiesCreated == false){
            self.createEnemies()
            manager.enemiesCreated = true
        }
    }
    
    func createEnemies(){
        if let filePath = NSBundle.mainBundle().pathForResource("Enemy", ofType: "json") {
            enemiesJson =  JSON(data: NSData(contentsOfFile: filePath)!)
            manager.enemies = [EnemyBot]();
            for(var i = 0; i < enemiesJson.count; i++){
                let id = enemiesJson[i]["id"].stringValue
                let startRoom = enemiesJson[i]["startRoomPosition"].intValue
                let map = enemiesJson[i]["map"].arrayObject
                //println("\(map)")

                let enemy = EnemyBot(botId: id, startRoom: startRoom, map: map as! [Int] )

                manager.enemies.append(enemy)
                manager.enemiesPosition.append(enemy.actualRoom())
            }
        } else {
            enemiesJson = JSON.nullJSON
        }
    }
    
    func updateEnemiesPosition(){
        for(var i = 0; i < manager.enemies.count; i++){
           manager.enemiesPosition[i] = manager.enemies[i].moveToAdjacentRoom()
           //manager.updateEnemiesListenerPosition()
        }
    }
    
    func stopEnemiesPosition(){
        for(var i = 0; i < manager.enemies.count; i++){
            manager.enemies[i].stopFootsteps()
            manager.enemies[i].stopBreath()
        }
    }
    func playEnemiesPosition(){
        for(var i = 0; i < manager.enemies.count; i++){
            manager.enemies[i].playFootsteps()
        }
    }
    
    func returnEnemiesPosition()->[Int]{
        return manager.enemiesPosition
    }
    
    func gameOver(){
        self.stopEnemiesPosition()
        self.manager.enemiesCreated = false
        self.enemies.removeAll()
    }
  
    
}
