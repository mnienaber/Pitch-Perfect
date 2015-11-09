//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Nienaber on 27/10/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        pauseButton.hidden = true
        playButton.hidden = true
    }        // Do any additional setup after loading the view

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        //play audio slow
        pauseButton.hidden = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        print("audio is playing slowly")

    }
    
    @IBAction func playFast(sender: UIButton) {
        //play audio fast
        pauseButton.hidden = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 2.0
        audioPlayer.play()
        print("audio is playing fast")
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        pauseButton.hidden = false
        playButton.hidden = true
        playAudioWithVariablePitch(2000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        pauseButton.hidden = false
        playButton.hidden = true
        playAudioWithVariablePitch(-500)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        print("changing the pitch")
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        pauseButton.hidden = false
        playButton.hidden = true
        playAudioWithReverb(70)
    }
    
    func playAudioWithReverb(mix: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = mix
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        print("adding some 'verb")
    }


    @IBAction func pauseAudio(sender: UIButton) {
        audioPlayer.pause()
        pauseButton.hidden = true
        playButton.hidden = false
        print("audio paused")
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        audioPlayer.play()
        playButton.hidden = true
        pauseButton.hidden = false
        print("replaying paused audio")
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        //stop all audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        playButton.hidden = true
        pauseButton.hidden = true
        print("stop all audio")
    }
    func audioPlayerDidFinishPlaying(audioPlayer: AVAudioPlayer, successfully flag: Bool){
        if(flag){
            playButton.hidden = true
            pauseButton.hidden = true
            audioPlayer.stop()
            audioEngine.stop()
            audioEngine.reset()
            print("audio has finished playing")
        }
            
    }
    

}