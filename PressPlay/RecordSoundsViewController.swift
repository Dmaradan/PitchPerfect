//
//  RecordSoundsViewController.swift
//  PressPlay
//
//  Created by Diego Martin on 9/27/15.
//  Copyright © 2015 Diego Martin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide buttons
        recordLabel.text = "Tap to record"
        stopButtonDisplay.hidden = true
        
        // Re-enable record button
        recordButtonDisplay.enabled = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    // MARK: Objects
    
    
    @IBOutlet weak var recordLabel: UILabel!
    
    @IBOutlet weak var stopButtonDisplay: UIButton!
    
    @IBOutlet weak var recordButtonDisplay: UIButton!
    
    // MARK: Actions
    
    @IBAction func recordButton(sender: UIButton) {
        //show text "recording in progress"
        recordLabel.text = "Recording in progress"
        stopButtonDisplay.hidden = false
        recordButtonDisplay.enabled = false
        
        //record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopButton(sender: UIButton) {
        stopButtonDisplay.hidden = true
        
        //stop recording process
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //save the recorded audio
        if(flag){
            recordedAudio = RecordedAudio(url: recorder.url, name: recorder.url.lastPathComponent!)
            
            //perform a seque to the next scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButtonDisplay.hidden = false
            stopButtonDisplay.hidden = true
        }
    }
}

