//
//  ViewController.swift
//  playSound
//
//  Created by 田山　由理 on 2016/02/26.
//  Copyright © 2016年 Yuri Tayama. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.blackColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushedButton(sender: UIButton) {
        switch sender.tag {
        case 0:
            playSound()
        case 1:
            playLoop()
        case 2:
            playReverb()
        case 3:
            playDelay()
        case 4:
            playDistortion()
        case 5:
            playTimePitch()
        default:
            break
        }
    }

    //音楽ファイルを再生
    func playSound() {
 
        //音楽ファイルのパスを取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample1", ofType:"mp3" )!)
        //プレイヤーを生成
        audioPlayer = try! AVAudioPlayer(contentsOfURL: audioPath, fileTypeHint: nil)
        //再生する
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    //音楽をループ再生
    func playLoop() {

        //音楽ファイルのパスを取得
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample2", ofType:"mp3" )!)
        //プレイヤーを生成
        audioPlayer = try! AVAudioPlayer(contentsOfURL: audioPath, fileTypeHint: nil)
        //ループ回数を設定
        audioPlayer.numberOfLoops = 2
        //再生する
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    var audioPlayerNode: AVAudioPlayerNode!
    var audioEngine:  AVAudioEngine!
    
    //リバーブ再生
    func playReverb() {
        
        //準備(インスタンスの生成とパラメーター値設定）
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall2)
        reverbEffect.wetDryMix = 50
        
        //AVAudioEngineとAVAudioPlayerNodeを生成
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        //AudioFileを準備(読み書き用に編集できる音楽ファイル)
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample2", ofType:"mp3")!)
        let audioFile = try! AVAudioFile(forReading: audioPath)
        
        //Nodeをアタッチ(音楽の再生）
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(reverbEffect)
        
        //Nodeのアタッチ（音楽ファイルの経路　インプット→エッフェクト→アウトプット）
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: audioFile.processingFormat)
        audioEngine.connect(reverbEffect, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        audioPlayerNode.scheduleFile(audioFile, atTime:nil) { () -> Void in
            print("complete")
        }
        audioPlayerNode.play()
    }
    
    // ディレイをかけて再生する
    func playDelay() {
        
        // ディレイを準備する
        let delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 0.5
        delayEffect.feedback = 50
        delayEffect.wetDryMix = 50
        
        // AVAudioEngine と AVAudioPlayerNode を生成する
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        // AudioFile を準備する
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample1", ofType: "mp3")!)
        let audioFile = try! AVAudioFile(forReading: audioPath)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(delayEffect)
        
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: audioFile.processingFormat)
        audioEngine.connect(delayEffect, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) { () -> Void in
            print("complete")
        }
        audioPlayerNode.play()
    }
    
    // ディストーションをかけて再生する
    func playDistortion() {
        // ディストーションを準備する
        let distortionEffect = AVAudioUnitDistortion()
        distortionEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiBrokenSpeaker)
        distortionEffect.wetDryMix = 50
        
        // AVAudioEngine と AVAudioPlayerNode を生成する
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample2", ofType: "mp3")!)
        let audioFile = try! AVAudioFile(forReading: audioPath)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(distortionEffect)
        
        audioEngine.connect(audioPlayerNode, to: distortionEffect, format: audioFile.processingFormat)
        audioEngine.connect(distortionEffect, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) { () -> Void in
            print("complete")
        }
        audioPlayerNode.play()
    }
    
    // ピッチと再生時間を変えて再生する
    func playTimePitch() {
        
        // ピッチと再生時間を変更する
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = 1000
        timePitch.rate = 0.5
        
        // AVAudioEngine と AVAudioPlayerNode を生成する
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        
        // AudioFile を準備する
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample2", ofType: "mp3")!)
        let audioFile = try! AVAudioFile(forReading: audioPath)
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(audioPlayerNode, to: timePitch, format: audioFile.processingFormat)
        audioEngine.connect(timePitch, to: audioEngine.mainMixerNode, format: audioFile.processingFormat)
        
        audioEngine.prepare()
        try! audioEngine.start()
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) { () -> Void in
            print("complete")
        }
        audioPlayerNode.play()
    }
}

