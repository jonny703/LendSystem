//
//  ClassButtons.swift
//  LendSystem
//
//  Created by John Nik on 4/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class ClassButtons: UIButton {
    
    

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        
    }
    
    override var isSelected: Bool {
        
        willSet {
            self.setTitleColor(UIColor.black, for: .normal)
        }
        didSet {
            self.setTitleColor(UIColor.blue, for: .selected)
        }
    }
    
    
    convenience init() {
        
        self.init(frame: CGRect.zero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


