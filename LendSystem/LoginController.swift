//
//  LoginController.swift
//  LendSystem
//
//  Created by John Nik on 4/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController, UITextFieldDelegate {
    
    var lendSystemController: LendSystemController?
    
    let containerView: UIView = {
        
        let view = UIView()
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
    
    let welcomeLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Welcom to Lend System!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.07)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let signinButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignin), for: .touchUpInside)
        return button
        
    }()
    
    func handleSignin() {
        
        activityIndicatorView.startAnimating()
        
        if !(checkInvalid()) {
            self.activityIndicatorView.stopAnimating()
            return
        }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not invalid")
            self.activityIndicatorView.stopAnimating()
            showAlertMessage(vc: self, titleStr: "Invalid Username or Password!", messageStr: "Write correct info")
            
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                self.activityIndicatorView.stopAnimating()
                showAlertMessage(vc: self, titleStr: "Invalid Username or Password!", messageStr: "Write correct info")
                return
            }
            
            self.lendSystemController?.setNavigationBar()
            self.activityIndicatorView.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            
        })

        
    }
    
    let signinWithFbButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign in with Facebook", for: .normal)
        button.backgroundColor = UIColor(r: 66, g: 133, b: 250)
        button.tintColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let signinWithGoogleButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign in with Google+", for: .normal)
        button.backgroundColor = UIColor(r: 255, g: 87, b: 34)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let signupContainerView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let signupLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Don't have an account?"
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.048)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let signupButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Sign up!", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.053)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goingSignupController), for: .touchUpInside)
        return button
        
    }()
    
    func goingSignupController() {
        
        let signupController = SignupController()
        navigationController?.pushViewController(signupController, animated: true)
        
    }
    
    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(containerView)
        view.addSubview(welcomeLabel)
        view.addSubview(signinButton)
//        view.addSubview(signinWithFbButton)
//        view.addSubview(signinWithGoogleButton)
        view.addSubview(signupContainerView)
        view.addSubview(activityIndicatorView)
        
        setupContainerView()
        setupOtherViews()
        setupButtons()
        setupSignupContainerView()
        setupActivityIndicaterView()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
        
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
        
        containerView.addSubview(emailTextField)
        containerView.addSubview(seperatorEmailView)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(seperaterPasswordView)
        
        emailTextField.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperatorEmailView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        seperatorEmailView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorEmailView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperatorEmailView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1 / 2).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        
        seperaterPasswordView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        seperaterPasswordView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperaterPasswordView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        seperaterPasswordView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
    }
    
    func setupOtherViews(){
    
        welcomeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        welcomeLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -DEVICE_WIDTH * 0.2).isActive = true
//        welcomeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        welcomeLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
    }

    
    func setupButtons() {
        
        signinButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        signinButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.08).isActive = true
        signinButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: DEVICE_WIDTH * 0.08).isActive = true
        
//        signinWithFbButton.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 50).isActive = true
//        signinWithFbButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        signinWithFbButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        signinWithFbButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        signinWithGoogleButton.topAnchor.constraint(equalTo: signinWithFbButton.bottomAnchor, constant: 20).isActive = true
//        signinWithGoogleButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        signinWithGoogleButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        signinWithGoogleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
    }
    
    func setupSignupContainerView() {
        
        signupContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        signupContainerView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.8).isActive = true
        signupContainerView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.08).isActive = true
        
        signupContainerView.addSubview(signupLabel)
        signupContainerView.addSubview(signupButton)
        
        signupButton.rightAnchor.constraint(equalTo: signupContainerView.rightAnchor).isActive = true
        signupButton.centerYAnchor.constraint(equalTo: signupContainerView.centerYAnchor).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2)
        signupButton.heightAnchor.constraint(equalTo: signupContainerView.heightAnchor).isActive = true
        
        signupLabel.centerYAnchor.constraint(equalTo: signupContainerView.centerYAnchor).isActive = true
        signupLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.58).isActive = true
        signupLabel.heightAnchor.constraint(equalTo: signupContainerView.heightAnchor).isActive = true
        signupLabel.leftAnchor.constraint(equalTo: signupContainerView.leftAnchor).isActive = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    func checkInvalid() -> Bool {
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

