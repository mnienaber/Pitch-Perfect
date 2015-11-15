//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Michael Nienaber on 27/10/2015.
//  Copyright © 2015 Michael Nienaber. All rights reserved.
//  1,2,3rd time's a charm.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate{
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    var effectAudio:
    
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
        audioPlayer.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func zeroCurrentTime(){
        pauseButton.hidden = false
        stopResetPlayer()
        audioPlayer.currentTime = 0.0
    }
    
    func stopResetPlayer(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playerNode(){
        stopResetPlayer()
        pauseButton.hidden = false
        playButton.hidden = true
    }
    
    func miscAudioPlay(speed: Float){
        playerNode()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    func pausePlayHidden(){
        playButton.hidden = true
        pauseButton.hidden = true
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
        playAudioThruEffect(2000, decider: 1)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioThruEffect(-500, decider: 1)
    }
    
    @IBAction func reverbAudio(sender: UIButton) {
        playAudioThruEffect(70, decider: 2)
    }
    
    func playAudioThruEffect(mixValue: Float, decider: Int)
        playerNode()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        if decider == 1{
            let effectAudio: AVAudioUnitEffect!
            effectAudio.pitch = mixValue
            audioEngine.attachNode(effectAudio)
            audioEngine.connect(audioPlayerNode, to: effectAudio, format: nil)
            audioEngine.connect(effectAudio, to: audioEngine.outputNode, format: nil)
        }else{
            let effectAudio: AVAudioUnitEffect
            effectAudio.wetDryMix = mixValue
            audioEngine.attachNode(effectAudio)
            audioEngine.connect(audioPlayerNode, to: effectAudio, format: nil)
            audioEngine.connect(effectAudio, to: audioEngine.outputNode, format: nil)
        }
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        print("applying an effect")
    }

    @IBAction func pauseAudio(sender: UIButton) {
        audioEngine.pause()
        audioPlayer.pause()
        playButton.hidden = false
        pauseButton.hidden = true
        print("audio paused")
    }
    
    @IBAction func playAudio(sender: UIButton) {
        audioPlayer.play()
        pauseButton.hidden = false
        playButton.hidden = true
        print("replaying paused audio")
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        stopResetPlayer()
        pausePlayHidden()
        print("stop all audio")
    }
    
    func audioPlayerDidFinishPlaying(audioPlayer: AVAudioPlayer, successfully flag: Bool){
        if(flag){
            pausePlayHidden()
            stopResetPlayer()
            print("audio has finished playing")
        }
            
    }
}