//
//  ViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/7/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class ListenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let storage = Storage.storage().reference()
    let databaseRef = Firestore.firestore().collection("Users")
    var users: [DocumentSnapshot] = []
    var songs: [DocumentSnapshot] = []
    
    var myPlayer: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        databaseRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.users.append(document)
                    document.reference.collection("Songs").getDocuments() { (querySnapshot2, err2) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document2 in querySnapshot2!.documents {
                                self.songs.append(document2)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listenHeaderCell", for: indexPath)
            return cell
        } else {
            let songData = songs[indexPath.row-1].data()
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongCell
            let row = indexPath.row % 4
            if (row == 0) {
                cell?.playButton.setImage(UIImage(named: "Magenta Triangle"), for: .normal)
            } else if (row == 2) {
                cell?.playButton.setImage(UIImage(named: "Blue Triangle"), for: .normal)
            } else if (row == 3) {
                cell?.playButton.setImage(UIImage(named: "Green Triangle"), for: .normal)
            }
            
            cell?.playButton.tag = indexPath.row-1
            cell?.playButton.setImage(UIImage(named: "heart"), for: .focused)
            
            cell?.songTitle.text = songData["Title"] as? String
            var tagsString = ""
            for tag in (songData["Tags"] as? [String])! {
                tagsString = tagsString + tag + ". "
            }
            return cell!
        }
    }

    @IBAction func playButtonClicked(_ sender: UIButton) {
        sender.setImage(UIImage(named: "Green Pause"), for: .normal)
        let songDatabaseURL = songs[sender.tag].data()["URL"] as? String
        storage.child(songDatabaseURL!).downloadURL{ (url, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.myPlayer = AVPlayer(url: url!)
                NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.myPlayer?.currentItem)
                print(url!)
                self.myPlayer?.play()
            }
        }
    }
}

