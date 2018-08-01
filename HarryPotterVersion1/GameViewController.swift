//
//  GameViewController.swift
//  HarryPotterVersion1
//
//  Created by rdadmin on 8/22/17.
//  Copyright © 2017 Jennifer Roscoe. All rights reserved.
//https://www.raywenderlich.com/145318/spritekit-swift-3-tutorial-beginners
//and based on ninja roscoe from summit an wade demo
/*
 remember inorder to use speech you have to open source code for info.plist and add
 <key>NSMicrophoneUsageDescription</key>  <string>Your microphone will be used to record your speech when you press the "Start Recording" button.</string>
 <key>NSSpeechRecognitionUsageDescription</key>  <string>Speech recognition will be used to determine which words you speak into this device&apos;s microphone.</string>
 
 above the tag </dict>
 */
import UIKit
import SpriteKit
import GameplayKit
import Speech//

class GameViewController: UIViewController , SFSpeechRecognizerDelegate {
    /*for page curl*/
      var tempUIView: UIView = UIView ()
    @IBOutlet var animatedUIView: UIView!
    /*end declarationfor page curl*/
    
    
    @IBOutlet weak var textView: UITextView!//
    @IBOutlet weak var myMircophoneButton: UIButton!//
     private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))//required for permission to use speech on users phone//
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?//
    private var recognitionTask: SFSpeechRecognitionTask?//
    private let audioEngine = AVAudioEngine()//

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       myMircophoneButton.isEnabled = false//
        speechRecognizer?.delegate = self//
 //below is part of speech too
        SFSpeechRecognizer.requestAuthorization{ (authStatus) in
            var isButtonEnabled =  false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("user denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("speech recognition is restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("speech recognition not yet authorized")
                
            }
            
            OperationQueue.main.addOperation(){
                self.myMircophoneButton.isEnabled = isButtonEnabled
            }
        } //

        
        
        
        
        
        
        
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true//frames per second
        skView.showsNodeCount = true //each ninja is node, each throwing star is a node
        skView.ignoresSiblingOrder = true //order does not matter for node
        
        scene.scaleMode = .resizeFill //scales to phone size
        
        skView.presentScene(scene)// connects scence, which is our view, to our skView
        
        
    }
    
    //function belongs to speech recognition
    func startRecording()
    {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
            
        }
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audio properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        recognitionRequest?.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, resultHandler: { (result, error) in
            
            var isFinal = false
            let hello = "hello"
            let Hello = "Hello"
            
            if result != nil {
                if result?.bestTranscription.formattedString == hello || result?.bestTranscription.formattedString == Hello{
                    self.textView.text="harry potter"
                    
                    UIView.animate(withDuration: 1.0, animations: {
                        let animation = CATransition()
                        animation.duration = 1.2
                        animation.startProgress = 0.0
                        animation.endProgress = 0.6
                        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                        animation.type = "pageCurl"
                        animation.subtype = "fromTop"
                        animation.isRemovedOnCompletion = false
                        animation.fillMode = "extended"
                        self.animatedUIView.layer.add(animation, forKey: "pageFlipAnimation")
                        self.animatedUIView.addSubview(self.tempUIView)
                    })
                   
                }
                else{
                    self.textView.text = result?.bestTranscription.formattedString//sets textview with string
                    isFinal = (result?.isFinal)!
                }
            }
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.myMircophoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            myMircophoneButton.isEnabled = true
        } else {
            myMircophoneButton.isEnabled = false
        }
    }
    
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            myMircophoneButton.isEnabled = false
            myMircophoneButton.setTitle("Start Recording", for: .normal)
        } else {
            startRecording()
           myMircophoneButton.setTitle("Stop Recording", for: .normal)
        }
        
        
        
        
        
    }
    override var prefersStatusBarHidden: Bool
    {
        return true //remove status bar
    }
    
    
    
    
    
}//end app
