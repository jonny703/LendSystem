//
//  Constants.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import Foundation
import UIKit


let Student_Image_Radius: CGFloat = DEVICE_WIDTH * 0.16

let DEVICE_WIDTH = UIScreen.main.bounds.size.width
let DEVICE_HEIGHT = UIScreen.main.bounds.size.height



let TextField_Width: CGFloat = 200

func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
    
    
    let TitleString = NSAttributedString(string: titleStr, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)])
    let MessageString = NSAttributedString(string: messageStr, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)])
    
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert);
    
//    let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: DEVICE_WIDTH * 0.03)
//    let width:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: DEVICE_WIDTH * 0.04)
    
//    alert.view.addConstraint(height);
//    alert.view.addConstraint(width);
    
    let action = UIAlertAction(title: "Ok!", style: .default, handler: nil);
    alert.addAction(action)
    
    alert.setValue(TitleString, forKey: "attributedTitle")
    alert.setValue(MessageString, forKey: "attributedMessage")
    vc.present(alert, animated: true, completion: nil)
}

typealias OkHandler = (_ thingAmount: String) -> Void

func showAlertMessageWhenLending(vc: UIViewController, titleStr: String, messageStr: String) -> Void {
    
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
    
    let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
        let textField = alert.textFields![0]
        print(textField.text!)

    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addTextField { (textField: UITextField) in
        
        textField.keyboardAppearance = .dark
        textField.keyboardType = .default
        textField.autocorrectionType = .default
        textField.placeholder = "Type amount"
        textField.clearButtonMode = .whileEditing
        
    }
    
    alert.addAction(OkAction)
    alert.addAction(cancel)
    
    vc.present(alert, animated: true, completion: nil)
    
}
