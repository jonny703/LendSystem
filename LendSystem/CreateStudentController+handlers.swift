//
//  CreateStudentController+handlers.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

extension CreateStudentController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleCreateStudent() {
        activityIndicatorView.startAnimating()
        if !(checkInvalid()) {
            activityIndicatorView.stopAnimating()
            return
        }
        
        guard let classnumber = classNumTextField.text, let name = nameTextField.text else {
            print("Form is not invalid")
            activityIndicatorView.stopAnimating()
            return
        }
        
        let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("student_images").child("\(imageName)studentImage.jpeg")
        
        if let studentImage = self.studentImageView.image, let uploadData = UIImageJPEGRepresentation(studentImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    showAlertMessage(vc: self, titleStr: "Sorry Something Wrong!", messageStr: "Try again")
                    self.activityIndicatorView.stopAnimating()
                    return
                }
                if let studentImageUrl = metadata?.downloadURL()?.absoluteString {
                    let returnstate = true
                    let values = ["name": name, "classnumber": classnumber, "studentImageUrl": studentImageUrl, "returnstate": returnstate] as [String: AnyObject]
                    
                    self.registerUserIntoDatabaseWithUid(values: values as [String : AnyObject])
                    
                    
                }
            })
            
        }
    }
    

    private func registerUserIntoDatabaseWithUid(values: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference(withPath: "students")
        let userReference = ref.childByAutoId()
//        let values = ["name": name, "classnumber": classnumber]
        userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                self.activityIndicatorView.stopAnimating()
                showAlertMessage(vc: self, titleStr: "Sorry Something Wrong!", messageStr: "Try again")
                return
            }
            self.activityIndicatorView.stopAnimating()
            self.navigationController?.popViewController(animated: true)
            
        })
    }

    
    func checkInvalid() -> Bool {
        
        if (nameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Student Name!", messageStr: "ex: Jane")
            return false
        }
        if (classNumTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Class Number!", messageStr: "ex: 3")
            return false
        }
        return true
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
            
            studentImageView.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }

    
}
