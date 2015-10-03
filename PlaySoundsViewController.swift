//
//  PlaySoundsViewController.swift
//  PressPlay
//
//  Created by Diego Martin on 9/28/15.
//  Copyright © 2015 Diego Martin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    
    var buttonValue: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePath)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func playSlowSound(sender: UIButton) {
        // play slow audio here
        
        buttonValue = 1
        
        playAudioWithVariableEffects()
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        // play sped-up audio here
        
        buttonValue = 2
        
        playAudioWithVariableEffects()
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        buttonValue = 3
        
        playAudioWithVariableEffects()
    }
    
    @IBAction func playVaderSound(sender: UIButton) {
        buttonValue = 4
        
        playAudioWithVariableEffects()
    }
    
    @IBAction func stopSound(sender: UIButton) {
        stopAndReset()
    }
    
    // MARK: Functions
    
    func playAudioWithVariableEffects(){
        stopAndReset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEffect = AVAudioUnitTimePitch()
        
        //logic that decides which effect to apply
        
        if(buttonValue == 1){
            changeEffect.rate = 0.5
        } else if(buttonValue == 2){
            changeEffect.rate = 2.0
        } else if(buttonValue == 3){
            changeEffect.pitch = 1000
        } else if(buttonValue == 4){
            changeEffect.pitch = -998
        }
        
        audioEngine.attachNode(changeEffect)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 25
        audioEngine.attachNode(reverbEffect)
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.wetDryMix = 10
        audioEngine.attachNode(echoEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: echoEffect, format: nil)
        audioEngine.connect(echoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    // Stops and resets player/engine
    
    func stopAndReset()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
