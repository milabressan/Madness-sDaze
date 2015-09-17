//
//  StorySoundNode.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 8/31/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import AVFoundation

class StorySoundNode {
    
    var storyPlayer = AVAudioPlayer()
    var played = false
    
    init(soundName:String,format:String) {
        
        let bgMusicURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: format)
        storyPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL!)
        storyPlayer.numberOfLoops = 0
        storyPlayer.prepareToPlay()
        storyPlayer.volume = 1
    }
    
    func play(){
        storyPlayer.play()
    }
    
}