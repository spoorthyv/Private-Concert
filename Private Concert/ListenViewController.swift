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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if (indexPath.row % 4 == 0) {
                cell?.playButton.setImage(UIImage(named: "Magenta Triangle"), for: .normal)
            } else if (indexPath.row % 3 == 0) {
                cell?.playButton.setImage(UIImage(named: "Blue Triangle"), for: .normal)
            } else if (indexPath.row % 2 == 0) {
                cell?.playButton.setImage(UIImage(named: "Green Triangle"), for: .normal)
            }
            return cell!
        }
    }


}

