//
//  SettingCell.swift
//  LendSystem
//
//  Created by John Nik on 4/19/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class SettingCell: BaseCell {
    
    override var isHighlighted: Bool {

        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            
//            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
        
    }
    
    var setting: Setting? {
        
        didSet {
            nameLabel.text = setting?.name
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)
            }
            
        }
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "History"
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.05)
        return label
    }()
    
    let iconImageView: UIImageView = {

        let imageView = UIImageView()
        imageView.image = UIImage(named: "historyIcon")
        imageView.contentMode = .scaleAspectFill
        return imageView

    }()

    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-19-[v0(32)]-19-[v1]|", views: iconImageView, nameLabel)
        
        
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:[v0(32)]", views: iconImageView)
        
        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        
//        self.backgroundColor = UIColor.blue
    }
    
}


















