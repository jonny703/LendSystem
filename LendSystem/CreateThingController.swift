//
//  CreateThingController.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit

class CreateThingController: UIViewController, UITextFieldDelegate {

    lazy var thingImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.imageWithString(name: "thing_default_image.jpeg", radius: Student_Image_Radius)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        tf.placeholder = "Thing Name"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)

        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.keyboardType = .default
        tf.delegate = self
        return tf
        
    }()
    
    let seperatorNameView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var thingAmountTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Thing Amount"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)

        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.delegate = self
        return tf
        
    }()
    
    let seperaterThingAmountView: UIView = {
        
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
        
        navigationItem.title = "Add Thing"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleNewCreateThing))
        
        view.addSubview(containerView)
        view.addSubview(thingImageView)
        view.addSubview(activityIndicatorView)
        
        setupContainerView()
        setupThingImageView()
        setupActivityIndicaterView()
        
        nameTextField.delegate = self
        thingAmountTextField.delegate = self
        
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
        containerView.addSubview(thingAmountTextField)
        containerView.addSubview(seperaterThingAmountView)
        
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorNameView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        seperatorNameView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorNameView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorNameView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        thingAmountTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        thingAmountTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        thingAmountTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        thingAmountTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterThingAmountView.topAnchor.constraint(equalTo: thingAmountTextField.bottomAnchor).isActive = true
        seperaterThingAmountView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterThingAmountView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterThingAmountView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupThingImageView() {
        
        thingImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        thingImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius * 2).isActive = true
        thingImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius * 2).isActive = true
        thingImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -DEVICE_WIDTH * 0.08).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}
