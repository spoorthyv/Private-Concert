//
//  ViewController.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/7/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit

class ListenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listenHeaderCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as? SongCell
            let row = indexPath.row % 4
            if (row == 0) {
                cell?.playButton.setImage(UIImage(named: "Magenta Triangle"), for: .normal)
            } else if (row == 2) {
                cell?.playButton.setImage(UIImage(named: "Blue Triangle"), for: .normal)
            } else if (row == 3) {
                cell?.playButton.setImage(UIImage(named: "Green Triangle"), for: .normal)
            }
            return cell!
        }
    }

}

