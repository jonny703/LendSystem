//
//  StudentCell.swift
//  LendSystem
//
//  Created by John Nik on 21/04/2017.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class StudentCell: UICollectionViewCell {
 
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let studentImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.imageWithString(name: "student_default_image.jpeg", radius: Student_Image_Radius / 2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let studentNameLabel: UILabel = {
        
        let label = UILabel()
        //        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setViews()
        
    }
    
    func setViews() {
        
        addSubview(containerView)
        containerView.addSubview(studentImageView)
        containerView.addSubview(studentNameLabel)
        
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        studentImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        studentImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5).isActive = true
        studentImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius).isActive = true
        studentImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius).isActive = true
        
        studentNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        studentNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1).isActive = true
        studentNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
