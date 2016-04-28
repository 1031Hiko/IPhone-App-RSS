//
//  ProfileTableViewCell.swift
//  RSS-READER
//
//  Created by Toshihiko Kubo on 2016/04/11.
//  Copyright © 2016年 Toshihiko Kubo. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setBackImageView()
        setIconImageView()
        setNameLabel()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackImageView(){
        backImageView.image = UIImage(named: "cover.png")
        backImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backImageView.clipsToBounds = true
    }
    
    func setIconImageView(){
        iconImageView.image = UIImage(named: "pug.png")
        iconImageView.contentMode = UIViewContentMode.ScaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.whiteColor().CGColor
        iconImageView.layer.cornerRadius = 5
    }
    
    func setNameLabel(){
        nameLabel.text = "Toshihiko Kubo"
        nameLabel.font = UIFont(name: "HiraKakuProN-W3", size: 35)
        nameLabel.textColor = UIColor.whiteColor()
    }
    
}
