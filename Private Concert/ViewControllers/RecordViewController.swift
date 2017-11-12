//
//  RecordViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/10/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 2,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    var audioPlayer: AVAudioPlayer!
    
    let storage = Storage.storage()
    let databaseUserRef = Firestore.firestore().collection("Users").document(Global.userEmail)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isEnabled = false
        uploadButton.isEnabled = false
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow")
                    } else {
                        print("Dont Allow")
                        let image = UIImage(named: "RecordPermissionError")
                        let imageView = UIImageView(image: image!)
                        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        imageView.contentMode = .center
                        self.view.addSubview(imageView)
                    }
                }
            }
        } catch {
            print("failed to record!")
        }
    }

    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        print(soundURL!)
        return soundURL as NSURL?
    }
    
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        }
        catch {}
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        }
        catch {}
    }
    
    @IBAction func click_AudioRecord(_ sender: AnyObject) {
        if audioRecorder == nil {
            self.startRecording()
            playButton.isEnabled = false
            uploadButton.isEnabled = false
            self.recordButton.setTitle("Stop", for: UIControlState.normal)
        } else {
            audioRecorder.stop()
            self.recordButton.setTitle("Record", for: UIControlState.normal)
            playButton.isEnabled = true
            uploadButton.isEnabled = true
        }
    }
    
    @IBAction func doPlay(_ sender: AnyObject) {
        if !audioRecorder.isRecording {
            self.audioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        } 
    }

    @IBAction func uploadSong(_ sender: Any) {
        recordButton.isEnabled = false
        playButton.isEnabled = false
        uploadButton.isEnabled = false

        let storageURL = Global.userEmail + "/audio1.m4a"
        let storageRef = Storage.storage().reference(withPath: storageURL)
        let databaseSongRef = databaseUserRef.collection("Songs").document("song1")
        
        let uploadTask = storageRef.putFile(from: audioRecorder.url)

        uploadTask.observe(.progress) { snapshot in
            let prog = Int(100 * snapshot.progress!.fractionCompleted)
            self.uploadButton.titleLabel?.text = String(prog) + "%"
        }
        uploadTask.observe(.success) { snapshot in
            let data: [String: Any] = ["URL": storageURL, "Tags": ["Tag 1", "Tag 2"], "Title": "Example Title"]
            databaseSongRef.setData(data)
            self.recordButton.isEnabled = true
        }
    }
}
