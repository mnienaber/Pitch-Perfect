//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Nienaber on 21/10/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//

import UIKit
import AVFoundation



class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var showStopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var showRecText: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        showStopButton.hidden = true
        showRecText.hidden = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        showStopButton.hidden = false
        recordButton.enabled = false
        showRecText.hidden = true
        //TODO: Record the users voice
        print("in recordAudio")
        //Inside func recordAudio(sender: UIButton)
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
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //recordedAudio.filePathUrl = recorder.url
            //recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            showStopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        recordButton.enabled = true
        print("in stopRecording")
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

