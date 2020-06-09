//
//  ViewController.swift
//  audioPlayerDemo
//
//  Created by Anmol singh on 2020-06-08.
//  Copyright © 2020 Swift Project. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var scrollBar: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playBtn: UIBarButtonItem!
    
    
    var isPlaying = false
    
    //we need instance of AVAudio Player
    var player = AVAudioPlayer()
    
    // we need to acess the audio file path
    let path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do{
       try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            scrollBar.maximumValue = Float(player.duration)
    }catch{
    print(error)
    }
    }

    @IBAction func playAudio(_ sender: UIBarButtonItem) {
        if isPlaying{
            playBtn.image = UIImage(systemName: "play.fill")
            player.pause()
            isPlaying = false
            timer.invalidate()
        }else {
            playBtn.image = UIImage(systemName: "pause.fill")
            player.play()
            isPlaying = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateScrubber(){
        scrollBar.value = Float(player.currentTime)
        if scrollBar.value == scrollBar.minimumValue{
            isPlaying = false
            playBtn.image = UIImage(systemName: "play.fill")
        }
    }
    
    
    @IBAction func valueChanged(_ sender: UISlider) {
        player.currentTime = TimeInterval(scrollBar.value)
        if isPlaying{
            player.play()
        }
    }
}

