//
//  HistoryCell.swift
//  LendSystem
//
//  Created by John Nik on 20/04/2017.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    let timeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)
//        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = DEVICE_WIDTH * 0.003
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        return label
        
    }()
    
    let studentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = DEVICE_WIDTH * 0.003
        label.text = "Joana"
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        return label
    }()
    
    let actionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = DEVICE_WIDTH * 0.003
        label.text = "Borrowed"
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        return label
    }()
    
    let thingNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = DEVICE_WIDTH * 0.003
        label.text = "Football"
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(timeLabel)
        addSubview(studentNameLabel)
        addSubview(actionLabel)
        addSubview(thingNameLabel)
        
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        studentNameLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        studentNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        studentNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4).isActive = true
        studentNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        actionLabel.leftAnchor.constraint(equalTo: studentNameLabel.rightAnchor).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        actionLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4).isActive = true
        actionLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        thingNameLabel.leftAnchor.constraint(equalTo: actionLabel.rightAnchor).isActive = true
        thingNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        thingNameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 4).isActive = true
        thingNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}













