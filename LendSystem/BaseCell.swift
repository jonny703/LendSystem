//
//  BaseCell.swift
//  LendSystem
//
//  Created by John Nik on 4/19/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews() {
        
    }
    
    
}
