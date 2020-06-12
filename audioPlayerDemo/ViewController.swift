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
    var path = Bundle.main.path(forResource: "bach", ofType: "mp3")
    
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // add tap gesture to volume slider
        let volumeGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(sliderTapped))
        volumeSlider.addGestureRecognizer(volumeGestureRecognizer)
        
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
    
    @IBAction func volumeValueChanged(_ sender: UISlider) {
        player.volume = volumeSlider.value
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

    @IBAction func stopAudio(_ sender: UIBarButtonItem) {
        player.stop()
        timer.invalidate()
        player.currentTime = 0
        scrollBar.value = 0
        playBtn.image = UIImage(systemName: "play.fill")
        isPlaying = false
    }
    
    @objc func sliderTapped(_ gesture: UIGestureRecognizer){
        
           let s: UISlider? = (gesture.view as? UISlider)
           if (s?.isHighlighted)! {
               return
           }

           // tap on thumb, let slider deal with it
           let pt: CGPoint = gesture.location(in: s)
           let percentage = pt.x / (s?.bounds.size.width)!
           let delta = Float(percentage) * Float((s?.maximumValue)! - (s?.minimumValue)!)
           let value = (s?.minimumValue)! + delta
           s?.setValue(Float(value), animated: true)
            player.volume = s!.value

    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake{
            let audioArray = ["boing", "knife", "swish", "wwarble", "wah", "shoot", "hit", "explosion", "bach"]
            
            let randomNumber = Int.random(in: 0..<audioArray.count)
            path = Bundle.main.path(forResource: audioArray[randomNumber], ofType: "mp3")
              do{
               try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
                    scrollBar.maximumValue = Float(player.duration)
            }catch{
            print(error)
            }
        }
    }
    
}

