//
//  ListenHeaderCell.swift
//  Private Concert
//
//  Created by Spoorthy Vemula on 11/9/17.
//  Copyright © 2017 Spoorthy Vemula. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songTags: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
