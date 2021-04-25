//
//  NewsItemTableViewCell.swift
//  GeekMobile
//
//  Created by Egor on 25.03.2021.
//

import UIKit

class NewsItemTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var repostsButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
