//
//  CreateStudentController.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class CreateStudentController: UIViewController, UITextFieldDelegate {
    
    lazy var studentImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.imageWithString(name: "student_default_image.jpeg", radius: Student_Image_Radius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        imageView.isUserInteractionEnabled = true
        
        return imageView
        
    }()
    
    let containerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Full Name"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.delegate = self
        return tf
        
    }()
    
    let seperatorNameView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var classNumTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Class Number"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.keyboardType = .numberPad
//        tf.isSecureTextEntry = true
        return tf
        
    }()
    
    let seperaterClassNumView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Add Student"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleCreateStudent))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        view.addSubview(containerView)
        view.addSubview(studentImageView)
        view.addSubview(activityIndicatorView)
        
        setupContainerView()
        setupStudentImageView()
        setupActivityIndicaterView()
        
        nameTextField.delegate = self
        classNumTextField.delegate = self
        
    }
    
    func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupActivityIndicaterView() {
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func setupContainerView() {
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.5).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2).isActive = true
        
        containerView.addSubview(nameTextField)
        containerView.addSubview(seperatorNameView)
        containerView.addSubview(classNumTextField)
        containerView.addSubview(seperaterClassNumView)
        
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorNameView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        seperatorNameView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorNameView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorNameView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        classNumTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        classNumTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        classNumTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        classNumTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterClassNumView.topAnchor.constraint(equalTo: classNumTextField.bottomAnchor).isActive = true
        seperaterClassNumView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterClassNumView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterClassNumView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupStudentImageView() {
        
        studentImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        studentImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius * 2).isActive = true
        studentImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius * 2).isActive = true
        studentImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -DEVICE_WIDTH * 0.08).isActive = true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

















