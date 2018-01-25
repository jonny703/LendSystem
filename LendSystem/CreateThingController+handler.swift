//
//  CreateThingController+handler.swift
//  LendSystem
//
//  Created by John Nik on 4/6/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

extension CreateThingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
    func handleNewCreateThing() {
        
        activityIndicatorView.startAnimating()
        
        if !(checkInvalid()) {
            activityIndicatorView.stopAnimating()
            return
        }
        
        guard let thingamountString = thingAmountTextField.text, let name = nameTextField.text else {
            print("Form is not invalid")
            activityIndicatorView.stopAnimating()
            return
        }
        
        let imageName = NSUUID().uuidString
        let thingamount: Int? = Int(thingamountString)
        let leftThingAmount = thingamount
        
        let storageRef = FIRStorage.storage().reference().child("thing_images").child("\(imageName)thingImage.jpeg")
        
        if let thingImage = self.thingImageView.image, let uploadData = UIImageJPEGRepresentation(thingImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    showAlertMessage(vc: self, titleStr: "Sorry Something Wrong!", messageStr: "Try again")
                    self.activityIndicatorView.stopAnimating()
                    return
                }
                if let thingImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = ["name": name, "thingamount": thingamount!, "leftThingAmount": leftThingAmount!, "thingImageUrl": thingImageUrl] as [String : AnyObject]
                    
                    self.registerUserIntoDatabaseWithUid(values: values as [String : AnyObject])
                    
                    
                }
                
                
                //                    print(metadata)
                
            })
            
        }
        
        
        
        
    }
    
    func checkInvalid() -> Bool {
        
        if (nameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Thing Name!", messageStr: "ex: Football")
            return false
        }
        if (thingAmountTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Thing Amount!", messageStr: "ex: 33")
            return false
        }
        return true
    }
    
    
    private func registerUserIntoDatabaseWithUid(values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(withPath: "things")
        let userReference = ref.childByAutoId()
        //        let values = ["name": name, "classnumber": classnumber]
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                showAlertMessage(vc: self, titleStr: "Sorry Something Wrong!", messageStr: "Try again")
                self.activityIndicatorView.stopAnimating()
                return
            }
            
            let lendingController = LendingController()
            lendingController.fetchThings()
            self.activityIndicatorView.stopAnimating()
            self.navigationController?.popViewController(animated: true)
        })
        
        
        
    }
    
    
    
    
    func handleSelectProfileImageView() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImmageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImmageFromPicker = editedImage
            
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImmageFromPicker = originalImage
            
        }
        
        if let selectedImage = selectedImmageFromPicker {
            
            thingImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
