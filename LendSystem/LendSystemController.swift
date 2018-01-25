//
//  LendSystemController.swift
//  LendSystem
//
//  Created by John Nik on 4/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class LendSystemController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    let CollectionViewCell_Identifier = "Cell"
    
    var students = [Student]()
    var savedStudents = [Student]()
    var searchActive: Bool = false
    var sendSearchActive: Bool = false
    

    lazy var fastSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Fast Search"
        search.translatesAutoresizingMaskIntoConstraints = false
        search.delegate = self
        
        //SearchBar Text
        let textFieldInsideUISearchBar = search.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.black
        textFieldInsideUISearchBar?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        
        //SearchBar Placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.textColor = UIColor.darkGray
        textFieldInsideUISearchBarLabel?.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.045)
        
        return search
    }()
    
    var collectionView: UICollectionView = {
        var colView: UICollectionView!
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: DEVICE_WIDTH * 0.054, left: DEVICE_WIDTH * 0.027, bottom: DEVICE_WIDTH * 0.027, right: DEVICE_WIDTH * 0.027)
        layout.itemSize = CGSize(width: DEVICE_WIDTH * 0.23, height: DEVICE_WIDTH * 0.23)
        
        let frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH * 0.8, height: DEVICE_WIDTH * 0.93)
        colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.translatesAutoresizingMaskIntoConstraints = false
        return colView
    }()
    
    let invalidCommandLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Invalid Amount!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.048)
        label.backgroundColor = UIColor(r: 134, g: 251, b: 236, a: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
        
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(DEVICE_WIDTH)
        print(DEVICE_HEIGHT)

        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Other", style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleNewCreateStudent))
        
        checkIfUserIsLoggedIn()
        
        view.addSubview(fastSearchBar)
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
        
        setupfastSearchBar()
        setupCollectionView()
        setupActivityIndicaterView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StudentCell.self, forCellWithReuseIdentifier: CollectionViewCell_Identifier)
        
        //Lognpressgesture implement
        let longPressGr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressGr.minimumPressDuration = 0.5
        longPressGr.delaysTouchesBegan = true
        longPressGr.delegate = self
        self.collectionView.addGestureRecognizer(longPressGr)
        
    }
    
    func setupActivityIndicaterView() {
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            return
        }
        
        let position = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: position)
        
        if let index = indexPath {
//            var cell = self.collectionView.cellForItem(at: index) as! StudentCell
            
            let student: Student
            if(searchActive) {
                student = self.savedStudents[index.item]
                sendSearchActive = true
            } else {
                student = self.students[index.item]
                sendSearchActive = false
            }
            
            print(index.item)
            print("success longPress")
            
            let alert = UIAlertController(title: "Edit Student Profile!", message: "Press Delete to remove Student!", preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
                let nameTextField = alert.textFields![0]
                let studentName = nameTextField.text
                print(studentName!)
                
                let classTextField = alert.textFields![1]
                let studentClassNum = classTextField.text
                print(studentClassNum!)
                
                if nameTextField.text == "" || classTextField.text == "" {
                    self.showAlert(warnigString: "Fail to edit student! Write Info.")
                } else {
                    
                    guard let studentId = student.studentId else {
                        return
                    }
                    
                    let ref = FIRDatabase.database().reference(withPath: "students")
                    let studentsRef = ref.child(studentId)
                    let values = ["name": studentName, "classnumber": studentClassNum] as [String: AnyObject]
                    studentsRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if err != nil {
                            print(err!)
                            
                            showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Try again ")
                            return
                        }
                        
                        FIRDatabase.database().reference().child("student-lending").child(studentId).observe(.childAdded, with: { (snapshot) in
                            
                            let lendsytemId = snapshot.key
                            
                            let lendsystemRef = FIRDatabase.database().reference().child("lendsystem").child(lendsytemId)
                            lendsystemRef.updateChildValues(["studentName": studentName!], withCompletionBlock: { (error, lendsystemRef) in
                                
                                if err != nil {
                                    print(err!)
                                    
                                    showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Try again ")
                                    return
                                }
                                
                            })
                            
                        }, withCancel: nil)
                        
                    })
                    
                    if(self.sendSearchActive) {
                        
                        self.savedStudents[index.item].name = studentName
                        self.savedStudents[index.item].classnumber = studentClassNum
                    } else {
                        self.students[index.item].name = studentName
                        self.students[index.item].classnumber = studentClassNum
                    }
                    
                    self.attemptReloadCollectionView()
                }
                
                
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addTextField { (textField: UITextField) in
                
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.autocorrectionType = .default
                textField.text = student.name
                textField.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)
                textField.clearButtonMode = .whileEditing
                textField.textAlignment = .center
                
            }
            
            let deleteAction = UIAlertAction(title: "Delete!", style: .default, handler: { (action) in
                
                guard let studentId = student.studentId else {
                    return
                }
                
                FIRDatabase.database().reference().child("students").child(studentId).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let student = Student()
                        student.setValuesForKeys(dictionary)
                        if student.returnstate == 0 {
                            showAlertMessage(vc: self, titleStr: "Can't Delete!", messageStr: "He is active")
                        } else {
                            print("succeed to delet students")
                            
                            FIRDatabase.database().reference().child("students").child(studentId).removeValue(completionBlock: { (error, ref) in
                                if error != nil {
                                    print("Failed to delete Student:", error!)
                                    return
                                }
                                
                                var filteredStudent = [Student]()
                                
                                if(self.sendSearchActive) {
//                                    self.savedStudents.remove(at: index.item)
                                    filteredStudent = self.savedStudents.filter({ (array: Student) -> Bool in
                                        return array.studentId == studentId
                                    })
                                    let studentInStudents = filteredStudent.first
                                    
                                    self.students.remove(at: studentInStudents?.index as! Int)

                                    
                                } else {
                                    self.students.remove(at: index.item)
                                }
                                
                                DispatchQueue.main.async {
                                    self.collectionView.reloadData()
                                }
                            })
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                    
                }, withCancel: nil)
            })
            
            alert.addTextField { (textField: UITextField) in
                
                textField.textAlignment = .center
                textField.keyboardAppearance = .dark
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .default
                textField.text = student.classnumber
                textField.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.03)
                textField.clearButtonMode = .whileEditing
                
            }
            
            alert.addAction(OkAction)
            alert.addAction(deleteAction)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Couldn't find index path")
        }
        
        
    }
    
    func showAlert(warnigString: String) {
        
        view.addSubview(invalidCommandLabel)
        
        invalidCommandLabel.text = warnigString
        
        invalidCommandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        invalidCommandLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        fadeViewInThenOut(view: invalidCommandLabel, delay: 3)
        
    }
    
    func fadeViewInThenOut(view : UIView, delay: TimeInterval) {
        
        let animationDuration = 0.25
        
        // Fade in the view
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            view.alpha = 1
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: animationDuration, delay: delay, options: .curveEaseInOut, animations: { () -> Void in
                view.alpha = 0
            },
                           completion: nil)
        }
    }
    
    lazy var settingLauncher: SettingsLauncher = {
        
        let laucher = SettingsLauncher()
        laucher.lendSystemController = self
        return laucher
        
    }()
    
    func handleMore() {
        
        // show menu

        settingLauncher.showSettings()
        
    }
    
    func showHistoryControllerForSettings(setting: Setting) {

        let historyController = HistoryController()
        navigationController?.pushViewController(historyController, animated: true)
    }
    
    func showBorrowedStudentsControllerForSetting(setting: Setting) {
        
        let borrowedStudentsController = BorrowedStudentsController()
        navigationController?.pushViewController(borrowedStudentsController, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func handleNewCreateStudent() {
        
        let createStudentController = CreateStudentController()
        navigationController?.pushViewController(createStudentController, animated: true)
        
        
        
    }
    
    func fetchStudents() {
        
        activityIndicatorView.startAnimating()
        self.students.removeAll()
        
        FIRDatabase.database().reference().child("students").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary  = snapshot.value as? [String: AnyObject] {
                
                let student = Student()
                student.studentId = snapshot.key
                
                student.setValuesForKeys(dictionary)
                
                self.students.append(student)
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.collectionView.reloadData()
                    
                }
                
            }
            
            
        }, withCancel: nil)
        
        print(students.count)
        
    }
    
    private func attemptReloadCollectionView() {
        
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleReloadCollectionView), userInfo: nil, repeats: false)
        
    }
    
    var timer: Timer?
    
    func handleReloadCollectionView() {
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
            
        }
        
    }

    
    func checkIfUserIsLoggedIn() {
        
        // user is not logged in
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        } else {
            
            setNavigationBar()
        }
        
    }
    
    func setNavigationBar() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavigationBarWithUserName(user: user)
            }
        }, withCancel: nil)

    }
    
    func setupNavigationBarWithUserName(user: User) {
        
        students.removeAll()
        self.fetchStudents()
        
        self.navigationItem.title = "Welcome " + user.name!
    }

    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.lendSystemController = self
        let naviController = UINavigationController(rootViewController: loginController)
        present(naviController, animated: true, completion: nil)
        
    }
   
    func setupfastSearchBar() {
        
        fastSearchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fastSearchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
//        fastSearchBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        fastSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.054).isActive = true
        fastSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.054).isActive = true
        fastSearchBar.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.13).isActive = true
        
    }
    
    func setupCollectionView() {
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: fastSearchBar.bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.027).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.027).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -DEVICE_WIDTH * 0.027).isActive = true

        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell_Identifier, for: indexPath) as! StudentCell
        let student: Student
        if(searchActive) {
            student = savedStudents[indexPath.item]
        } else {
            student = students[indexPath.item]
            student.setValue(indexPath.item, forKey: "index")
        }
        
        
        
        cell.studentNameLabel.text = student.name
        
        if let studentImageUrl = student.studentImageUrl {
            
            cell.studentImageView.loadImageUsingCacheWithUrlString(urlString: studentImageUrl)
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let student: Student
        if(searchActive) {
            student = savedStudents[indexPath.item]
        } else {
            student = students[indexPath.item]
        }
        
        
        let lendingController = LendingController()
        
        lendingController.student = student
        
        let naviController = UINavigationController(rootViewController: lendingController)
        present(naviController, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(searchActive) {
            return savedStudents.count
        }
        
        return students.count
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        fastSearchBar.resignFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        fastSearchBar.endEditing(true)
        
    }

    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        
        searchActive = false
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        

    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        fastSearchBar.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        savedStudents = self.students.filter { $0.name!.contains(searchText) }
        
        if(savedStudents.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.collectionView.reloadData()
        
    }
    
}



























