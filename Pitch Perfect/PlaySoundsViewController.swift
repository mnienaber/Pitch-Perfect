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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func miscCommands(){
        pauseButton.hidden = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
    }
    
    func miscAudioPlayerCommands(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func miscPlayerNode(){
        miscAudioPlayerCommands()
        pauseButton.hidden = false
        playButton.hidden = true
    }
    
    func miscAudioPlay(speed: Float){
        miscCommands()
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    @IBAction func playSlow(sender: UIButton) {
        miscAudioPlay(0.5)
        print("audio is playing slowly")
    }
    
    @IBAction func playFast(sender: UIButton) {
        miscAudioPlay(2.0)
        print("audio is playing fast")
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(2000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-500)
    }
    
    
    func playAudioWithVariablePitch(pitch: Float){
        miscPlayerNode()
        
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
        playAudioWithReverb(70)
    }
    
    func playAudioWithReverb(mix: Float){
        miscPlayerNode()
        
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
    
    @IBAction func playAudio(sender: UIButton) {
        audioPlayer.play()
        playButton.hidden = true
        pauseButton.hidden = false
        print("replaying paused audio")
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        miscAudioPlayerCommands()
        playButton.hidden = true
        pauseButton.hidden = true
        print("stop all audio")
    }
    
    func audioPlayerDidFinishPlaying(audioPlayer: AVAudioPlayer, successfully flag: Bool){
        if(flag){
            playButton.hidden = true
            pauseButton.hidden = true
            miscAudioPlayerCommands()
            print("audio has finished playing")
        }
            
    }
}