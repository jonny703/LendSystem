//
//  SignupController.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController, UITextFieldDelegate {
    
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
    
    lazy var emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Email"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints =  false
        tf.delegate = self
        return tf
        
    }()
    
    let seperatorEmailView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var passwordTextField: UITextField = {
        
        let tf = UITextField()
        tf.textAlignment = .left
        tf.placeholder = "Password"
        tf.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
        
    }()
    
    let seperaterPasswordView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let signupButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goingBackSigninController), for: .touchUpInside)
        return button
        
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    func goingBackSigninController() {
        
        activityIndicatorView.startAnimating()
        
        if !(checkInvalid()) {
            self.activityIndicatorView.stopAnimating()
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            
            showAlertMessage(vc: self, titleStr: "Invalid Username or Password!", messageStr: "Write correct info")
            
            print("Form is not invalid")
            self.activityIndicatorView.stopAnimating()
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                
                showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Write Valid Info")
                
                print(error!)
                self.activityIndicatorView.stopAnimating()
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfluly authenticated user
            
            let ref = FIRDatabase.database().reference(withPath: "users")
            let userReference = ref.child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err!)
                    self.activityIndicatorView.stopAnimating()
                    showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Try again ")
                    return
                }
                self.activityIndicatorView.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            })
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor.white
        
        navigationController?.isNavigationBarHidden = false
        
        view.addSubview(containerView)
        view.addSubview(signupButton)
        view.addSubview(activityIndicatorView)
        
        setupContainerView()
        setupSignupButton()
        setupActivityIndicaterView()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        
    }
    
    func setupActivityIndicaterView() {
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    
    func setupContainerView() {
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.53).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.32).isActive = true
        
        containerView.addSubview(nameTextField)
        containerView.addSubview(seperatorNameView)
        containerView.addSubview(emailTextField)
        containerView.addSubview(seperatorEmailView)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(seperaterPasswordView)
        
        
        nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorNameView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        seperatorNameView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorNameView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorNameView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true

        
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorEmailView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seperatorEmailView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorEmailView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorEmailView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 3).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterPasswordView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        seperaterPasswordView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterPasswordView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterPasswordView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupSignupButton() {
        
        
        signupButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.21).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.08).isActive = true
        signupButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DEVICE_WIDTH * 0.08).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func checkInvalid() -> Bool {
        
        if (nameTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Your Name!", messageStr: "ex: Belle")
            return false
        }
        if (emailTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Your Email!", messageStr: "ex: Belle703@oulook.com")
            return false
        }
        if (passwordTextField.text?.isEmpty)! {
            showAlertMessage(vc: self, titleStr: "Write Your Password!", messageStr: "ex: Belle@703")
            return false
        }
        
        return true
    }
}
