//
//  CreateThingController.swift
//  LendSystem
//
//  Created by John Nik on 4/5/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class LendingController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    let CollectionViewCellA_Identifier = "Cell_A"
    let CollectionViewCellB_Identifier = "Cell_B"

    var student: Student?
    var things = [Thing]()
    var savedThings = [Thing]()
    var searchActive: Bool = false
    var sendSearchActive: Bool = false
    var lendingThings = [LendingThing]()
    
//    var studentName: String?
//    var studentImageUrl: String?
    
    let containerStudentView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let bottomLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let verticalLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    lazy var studentImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.imageWithString(name: "student_default_image.jpeg", radius: Student_Image_Radius / 2)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
        
    }()
    
    let studentNameLabel: UILabel = {
        
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.05)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var borrowedThingImageView: ThingCell = {
        
        let view = ThingCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let containerThingsView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let bottomLineTwo: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
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
    
    lazy var collectionViewB: UICollectionView = {
        var colView: UICollectionView!
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: DEVICE_WIDTH * 0.027, left: DEVICE_WIDTH * 0.003, bottom: DEVICE_WIDTH * 0.027, right: DEVICE_WIDTH * 0.003)
        layout.itemSize = CGSize(width: DEVICE_WIDTH * 0.21, height: DEVICE_WIDTH * 0.21)
        
        let frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH * 0.8, height: DEVICE_WIDTH * 0.93)
        colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.translatesAutoresizingMaskIntoConstraints = false
        
        colView.dataSource = self
        colView.delegate = self

        
        colView.dataSource = self
        colView.delegate = self
        return colView
    }()
    
    lazy var collectionViewA: UICollectionView = {
        var colView: UICollectionView!
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: DEVICE_WIDTH * 0.007, left: DEVICE_WIDTH * 0.003, bottom: DEVICE_WIDTH * 0.007, right: DEVICE_WIDTH * 0.003)
        layout.itemSize = CGSize(width: DEVICE_WIDTH * 0.22, height: DEVICE_WIDTH * 0.22)

        layout.scrollDirection = .horizontal
    
        
        let frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH * 0.53, height: DEVICE_WIDTH * 0.28)
        colView = UICollectionView(frame: frame, collectionViewLayout: layout)
//        colView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.showsHorizontalScrollIndicator = false
        colView.translatesAutoresizingMaskIntoConstraints = false
//        colView.alwaysBounceHorizontal = true
//        colView.alwaysBounceVertical = true
        colView.dataSource = self
        colView.delegate = self
        
        return colView
    }()
    
    let invalidCommandLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Invalid Amount!"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: DEVICE_WIDTH * 0.05)
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
        
        view.backgroundColor = UIColor.white
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleNewCreateThing))
        
        view.addSubview(containerStudentView)
        view.addSubview(containerThingsView)
        view.addSubview(collectionViewB)
        view.addSubview(activityIndicatorView)
//        view.addSubview(collectionViewA)
//        view.addSubview(borrowedThingImageView)
        
        
        collectionViewA.register(ThingCell.self, forCellWithReuseIdentifier: CollectionViewCellA_Identifier)
        
        collectionViewB.register(ThingCell.self, forCellWithReuseIdentifier: CollectionViewCellB_Identifier)
        
        setupContainerStudentView()
        setupContainerThingsView()
        setupfastSearchBar()
        setupCollectionViewB()
        setupActivityIndicaterView()
//        setupAddThingButton()
//        setupborrowedThingImageView()
        
        setupStudentProfile()
        fetchThings()
        fetchStudentlendingThings()
        
        let longPressGr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressGr.minimumPressDuration = 0.5
        longPressGr.delaysTouchesBegan = true
        longPressGr.delegate = self
        self.collectionViewB.addGestureRecognizer(longPressGr)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        fetchThings()
//        fetchStudentlendingThings()
        
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
        
        let position = gestureRecognizer.location(in: self.collectionViewB)
        let indexPath = self.collectionViewB.indexPathForItem(at: position)
        
        if let index = indexPath {
            //            var cell = self.collectionView.cellForItem(at: index) as! StudentCell
            
            let thing: Thing
            if(searchActive) {
                thing = self.savedThings[index.item]
                sendSearchActive = true
            } else {
                thing = self.things[index.item]
                sendSearchActive = false
            }
            
            print(index.item)
            print("success longPress")
            
            let alert = UIAlertController(title: "Edit Thing!", message: "Press Delete to remove Thing!", preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
                let nameTextField = alert.textFields![0]
                let thingName = nameTextField.text
                print(thingName!)
                
                let amountTextField = alert.textFields![1]
                let newthingAmountString = amountTextField.text
                
                let newthingAmount: Int? = Int(newthingAmountString!)
                
                
                if nameTextField.text == "" || amountTextField.text == "" {
                    self.showAlert(warnigString: "Fail to edit Thing! Write Info.")
                } else {
                    
                    guard let thingId = thing.thingId else {
                        return
                    }
                    
                    let ref = FIRDatabase.database().reference(withPath: "things")
                    let thingsRef = ref.child(thingId)
                    
                    thingsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            
                            let thing = Thing()
                            thing.setValuesForKeys(dictionary)
                            
                            let oldLeftAmount = Int(thing.leftThingAmount!)
                            let oldThingAmount = Int(thing.thingamount!)
                            let lendingAmount = oldThingAmount - oldLeftAmount
                            
                            if lendingAmount > newthingAmount! {
                                showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "LendingAmount is big than that amount")
                            } else {
                                
                                let newLeftAmount = newthingAmount! - lendingAmount
                                
                                let values = ["name": thingName!, "leftThingAmount": newLeftAmount, "thingamount": newthingAmount!] as [String : AnyObject]
                                
                                thingsRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                    
                                    if error != nil {
                                        print("Failed to delete Student:", error!)
                                        
                                        showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Fail to edit thing")
                                        return
                                    }
                                    
                                    let ref = FIRDatabase.database().reference().child("lendsystem")
                                    
                                    ref.queryOrdered(byChild: "thingId").observe(.childAdded, with: { (snapshot) in
                                        
                                        print(snapshot)
                                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                                            return
                                        }
                                        
                                        if let lendThingId = dictionary["thingId"] as? String {
                                            
                                            if thingId == lendThingId {
                                                
                                                ref.child(snapshot.key).updateChildValues(["thingName": thingName!], withCompletionBlock: { (error, ref) in
                                                    
                                                    if error != nil {
                                                        print("Failed to delete Student:", error!)
                                                        
                                                        showAlertMessage(vc: self, titleStr: "Something Wrong!", messageStr: "Fail to change thing name in history")
                                                        return
                                                    }
                                                    
                                                })
                                                
                                            }
                                            
                                        }
                                    }, withCancel: nil)

                                    
                                    if(self.sendSearchActive) {
                                        
                                        self.savedThings[index.item].name = thingName
                                        self.savedThings[index.item].leftThingAmount = newLeftAmount as NSNumber
                                        self.savedThings[index.item].thingamount = newthingAmount! as NSNumber
                                    } else {
                                        self.things[index.item].name = thingName
                                        self.things[index.item].leftThingAmount = newLeftAmount as NSNumber
                                        self.things[index.item].thingamount = newthingAmount! as NSNumber
                                    }
                                    
                                    var filteredThing = [LendingThing]()
                                    
                                    
                                    filteredThing = self.lendingThings.filter({ (array: LendingThing) -> Bool in
                                        return array.thingId == thingId })
                                        
                                        
                                        
                                        let thingInThings = filteredThing.first
                                        thingInThings?.setValue(thingName, forKey: "thingName")
                                        

                                    
                                    self.attemptReloadCollectionView()
                                    
                                })
                            }
                        }
                    }, withCancel: nil)
                }
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addTextField { (textField: UITextField) in
                
                textField.keyboardAppearance = .dark
                textField.keyboardType = .default
                textField.autocorrectionType = .default
                textField.text = thing.name
                textField.clearButtonMode = .whileEditing
                textField.textAlignment = .center
                
            }
            
            let deleteAction = UIAlertAction(title: "Delete!", style: .default, handler: { (action) in
                
                guard let thingId = thing.thingId else {
                    return
                }
                
                let ref = FIRDatabase.database().reference(withPath: "things")
                let thingsRef = ref.child(thingId)
                
                thingsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        let thing = Thing()
                        thing.setValuesForKeys(dictionary)
                        
                        let leftAmount = Int(thing.thingamount!)
                        let thingAmount = Int(thing.leftThingAmount!)
                        
                        if leftAmount != thingAmount {
                            showAlertMessage(vc: self, titleStr: "Fail to delete thing!", messageStr: "Lending Amount exist!")
                        } else {
                            FIRDatabase.database().reference().child("things").child(thingId).removeValue(completionBlock: { (error, ref) in
                                
                                if error != nil {
                                    print("Failed to delete Student:", error!)
                                    
                                    showAlertMessage(vc: self, titleStr: "Something Wrong", messageStr: "Try Again")
                                    return
                                }
                                
                                var filteredthing = [Thing]()
                                
                                if(self.sendSearchActive) {
                                    //                                    self.savedStudents.remove(at: index.item)
                                    filteredthing = self.savedThings.filter({ (array: Thing) -> Bool in
                                        return array.thingId == thingId
                                    })
                                    let thingInThings = filteredthing.first
                                    
                                    self.things.remove(at: thingInThings?.index as! Int)
                                    
                                    
                                } else {
                                    self.things.remove(at: index.item)
                                }
                                
                                
                                DispatchQueue.main.async {
                                    self.collectionViewB.reloadData()
                                }

                                
                            })
                        }
                    
                    }
                }, withCancel: nil)
            })
            
            alert.addTextField { (textField: UITextField) in
                
                textField.textAlignment = .center
                textField.keyboardAppearance = .dark
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .default
                let thingAmountStr = String(describing: thing.thingamount!)
                textField.text = thingAmountStr
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

    
    func fetchThings() {
        
        activityIndicatorView.startAnimating()
        
        self.things.removeAll()
        
        FIRDatabase.database().reference().child("things").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary  = snapshot.value as? [String: AnyObject] {
                
                print(dictionary)
                
                let thing = Thing()
                thing.thingId = snapshot.key
                thing.setValuesForKeys(dictionary)
                
//                let leftThingAmount = Int(thing.leftThingAmount!)
                
                self.things.append(thing)
                
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.collectionViewB.reloadData()
                }
                
            }
            
            
        }, withCancel: nil)
        
        print(things.count)
        
    }
    
    func fetchStudentlendingThings() {
        
        self.lendingThings.removeAll()
        
        guard let studentId = self.student?.studentId else {
            return
        }
        
        print(self.lendingThings.count)
        
        let studentLendRef = FIRDatabase.database().reference().child("student-lending").child(studentId)
        
        studentLendRef.observe(.childAdded, with: { (snapshot) in
            
//            print(snapshot)
            
            let lendsystemId = snapshot.key
            let lendsystemRef = FIRDatabase.database().reference().child("lendsystem").child(lendsystemId)
            lendsystemRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let studentLendingThingId = snapshot.key
                
                let thingId = dictionary["thingId"] as? String
                let lendingAmount = dictionary["lendingAmount"] as? NSNumber
                let thingRef = FIRDatabase.database().reference().child("things").child(thingId!)
                thingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print(snapshot)
                    
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                    
                    let thing = Thing()
                    thing.setValuesForKeys(dictionary)
                    let thingName = thing.name
                    let thingImageUrl = thing.thingImageUrl
                    let havingThing = LendingThing()
                    
                    havingThing.setValuesForKeys(["thingName": thingName!, "thingId": thingId!, "lendingAmount": lendingAmount!, "thingImageUrl": thingImageUrl!, "studentLendingThingId": studentLendingThingId])
                    
                    self.lendingThings.append(havingThing)
                    
                    DispatchQueue.main.async {
                        
                        self.collectionViewA.reloadData()
                        let indexpath = IndexPath(item: self.lendingThings.count - 1, section: 0)
                        self.collectionViewA.scrollToItem(at: indexpath, at: .right, animated: true)
                        
                    }

                    
                }, withCancel: nil)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        print(self.lendingThings.count)
        
    }


    func handleCancel() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleNewCreateThing() {
        
        let createThingController = CreateThingController()
        navigationController?.pushViewController(createThingController, animated: true)
        
        
        
    }
    
    func handleDoneLendingSystem() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func setupborrowedThingImageView() {
        
        borrowedThingImageView.centerYAnchor.constraint(equalTo: containerStudentView.centerYAnchor).isActive = true
        borrowedThingImageView.leftAnchor.constraint(equalTo: containerStudentView.rightAnchor, constant: 7).isActive = true
        borrowedThingImageView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2).isActive = true
        borrowedThingImageView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.2).isActive = true
        
        borrowedThingImageView.thingImageView.image = UIImage(named: "Sandhink.jpg")
        borrowedThingImageView.thingAllAmountLabel.text = "50"
        borrowedThingImageView.thingNameLabel.text = "Buket"
        
    }
    
    func setupStudentProfile() {
        
//        print(self.studentName!, self.studentImageUrl!)
        
        studentImageView.loadImageUsingCacheWithUrlString(urlString: self.student!.studentImageUrl!)
        studentNameLabel.text = self.student?.name!
        
    }
    
    
    func setupContainerStudentView() {
        
        containerStudentView.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.25).isActive = true
        containerStudentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        containerStudentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerStudentView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.25
            ).isActive = true
        
        
        containerStudentView.addSubview(bottomLine)
        containerStudentView.addSubview(verticalLine)
        containerStudentView.addSubview(studentImageView)
        containerStudentView.addSubview(studentNameLabel)
        
        
        bottomLine.bottomAnchor.constraint(equalTo: containerStudentView.bottomAnchor).isActive = true
        bottomLine.centerXAnchor.constraint(equalTo: containerStudentView.centerXAnchor).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: containerStudentView.widthAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        
        
        verticalLine.bottomAnchor.constraint(equalTo: containerStudentView.bottomAnchor).isActive = true
        verticalLine.rightAnchor.constraint(equalTo: containerStudentView.rightAnchor).isActive = true
        verticalLine.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        verticalLine.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        studentImageView.centerXAnchor.constraint(equalTo: containerStudentView.centerXAnchor).isActive = true
        studentImageView.topAnchor.constraint(equalTo: containerStudentView.topAnchor, constant: 8).isActive = true
        studentImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius).isActive = true
        studentImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius).isActive = true
        
        studentNameLabel.centerXAnchor.constraint(equalTo: containerStudentView.centerXAnchor).isActive = true
        studentNameLabel.bottomAnchor.constraint(equalTo: containerStudentView.bottomAnchor, constant: -3).isActive = true
        studentNameLabel.widthAnchor.constraint(equalTo: containerStudentView.widthAnchor).isActive = true
        
        
    }
    
    
    func setupContainerThingsView() {
        
        containerThingsView.centerYAnchor.constraint(equalTo: containerStudentView.centerYAnchor).isActive = true
        containerThingsView.heightAnchor.constraint(equalTo: containerStudentView.heightAnchor).isActive = true
        containerThingsView.leftAnchor.constraint(equalTo: containerStudentView.rightAnchor).isActive = true
        containerThingsView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        containerThingsView.addSubview(collectionViewA)
        
        collectionViewA.leftAnchor.constraint(equalTo: containerThingsView.leftAnchor).isActive = true
        collectionViewA.rightAnchor.constraint(equalTo: containerThingsView.rightAnchor).isActive = true
        collectionViewA.topAnchor.constraint(equalTo: containerThingsView.topAnchor).isActive = true
        collectionViewA.bottomAnchor.constraint(equalTo: containerThingsView.bottomAnchor).isActive = true
        
        containerThingsView.addSubview(bottomLineTwo)
        
        bottomLineTwo.widthAnchor.constraint(equalTo: containerThingsView.widthAnchor).isActive = true
        bottomLineTwo.centerXAnchor.constraint(equalTo: containerThingsView.centerXAnchor).isActive = true
        bottomLineTwo.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.003).isActive = true
        bottomLineTwo.bottomAnchor.constraint(equalTo: containerThingsView.bottomAnchor).isActive = true
        
        
        
    }
    
    func setupfastSearchBar() {
        
        view.addSubview(fastSearchBar)
        
        fastSearchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fastSearchBar.topAnchor.constraint(equalTo: containerThingsView.bottomAnchor, constant: DEVICE_WIDTH * 0.025).isActive = true
//        fastSearchBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        fastSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.053).isActive = true
        fastSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.053).isActive = true

        fastSearchBar.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.11).isActive = true
        
    }
    
    func setupCollectionViewB() {
        
        collectionViewB.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionViewB.topAnchor.constraint(equalTo: fastSearchBar.bottomAnchor, constant: 0).isActive = true
        collectionViewB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.026).isActive = true
        collectionViewB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.026).isActive = true
        collectionViewB.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionViewA {
            
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellA_Identifier, for: indexPath) as! ThingCell
            let thing = lendingThings[indexPath.item]
            
//            cellA.backgroundColor = UIColor.orange
            let lendingAmounInt = thing.lendingAmount
            cellA.thingNameLabel.text = thing.thingName
            cellA.thingAllAmountLabel.text = String(describing: lendingAmounInt!)
            
            cellA.thingAllAmountLabel.backgroundColor = UIColor(r: 240, g: 258, b: 78)
            
            if let thingImageUrl = thing.thingImageUrl {
                
                cellA.thingImageView.loadImageUsingCacheWithUrlString(urlString: thingImageUrl)
                
            }
            
            
            
            return cellA
            
        } else {
            
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellB_Identifier, for: indexPath) as! ThingCell
            let thing: Thing
            if(searchActive) {
//                print("showcollectionActive")
                thing = savedThings[indexPath.item]
            } else {
//                print("showcollectionInactive")
                thing = things[indexPath.item]
                thing.setValue(indexPath.item, forKey: "index")
            }
            let thingamounInt = thing.leftThingAmount
            
            cellB.thingNameLabel.text = thing.name
            cellB.thingAllAmountLabel.text = String(describing: thingamounInt!)
            
            if let thingImageUrl = thing.thingImageUrl {
                
                cellB.thingImageView.loadImageUsingCacheWithUrlString(urlString: thingImageUrl)
                
            }
            
            return cellB
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionViewA {
//            print("collectionA----", searchActive)
            
            let thing = lendingThings[indexPath.item]
            
            print(thing.studentLendingThingId!)
            
            let alert = UIAlertController(title: "Return?", message: thing.thingName, preferredStyle: .alert)
            
            let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
                
                guard let studentLendingThingId = thing.studentLendingThingId else {
                    return
                }
                
                let lendSystemRef = FIRDatabase.database().reference().child("lendsystem").child(studentLendingThingId)
                
                let totimestamp = NSDate().timeIntervalSince1970 as NSNumber
                
                lendSystemRef.updateChildValues(["returnstate": true, "totimestamp": totimestamp])
                
                if let studentId = self.student?.studentId {
                    
                    FIRDatabase.database().reference().child("student-lending").child(studentId).child(thing.studentLendingThingId!).removeValue(completionBlock: { (error, ref) in
                        if error != nil {
                            print("Failed to delete thing:", error!)
                            return
                        }
                    })
                }
                
                lendSystemRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                    
                    let thingId = dictionary["thingId"] as? String
                    let lendingAmount = dictionary["lendingAmount"] as? NSNumber
                    
                    let thingRef = FIRDatabase.database().reference().child("things").child(thingId!)
                    thingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            return
                        }
                        
                        let leftThingAmount = dictionary["leftThingAmount"] as? NSNumber
                        
                        let realLeftThingAmount: Int? = Int(leftThingAmount!) + Int(lendingAmount!)
                        
                        
                        thingRef.updateChildValues(["leftThingAmount": realLeftThingAmount!])
                        
                        
                        // filter nsarray
                        var filteredThing = [Thing]()
                        
                        if(self.searchActive) {
//                            print("reeturncollectionA----active")
                            filteredThing = self.savedThings.filter({ (array: Thing) -> Bool in
                                return array.thingId == thingId
                            })
                        } else {
//                            print("returncollectionA----inactive")
                            filteredThing = self.things.filter({ (array: Thing) -> Bool in
                                return array.thingId == thingId
                            })
                        }
                        
                        let thingInThings = filteredThing.first
                        thingInThings?.setValue(realLeftThingAmount! as NSNumber, forKey: "leftThingAmount")
                        
                        self.lendingThings.remove(at: indexPath.item)
                        
                        if self.lendingThings.count == 0 {
                            
                            if let studentId = self.student?.studentId {
                                
                                let studetsRef = FIRDatabase.database().reference().child("students").child(studentId)
                                studetsRef.updateChildValues(["returnstate": true])
                            }
                            
                            
                        }
                        
                        self.attemptReloadCollectionView()
                    }, withCancel: nil)
                    
                }, withCancel: nil)
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            
            alert.addAction(OkAction)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            print("collectionB----", searchActive)
            
            let thing: Thing
            if(searchActive) {
//                print("sendcollectionb----active")
                thing = savedThings[indexPath.item]
                sendSearchActive = true
            } else {
//                print("sendcollectionb----inactive")
                sendSearchActive = false
                thing = things[indexPath.item]
            }
            let fromtimestamp = NSDate().timeIntervalSince1970 as NSNumber
            let totimestamp = NSDate().timeIntervalSince1970 as NSNumber
            let returnstate = false
            let studentId = self.student?.studentId!
            
            let thingName = thing.name
            let studentName = self.student?.name
            
            
            let leftThingAmount: Int? = Int(thing.leftThingAmount!)
            
            if leftThingAmount == 0 {
                showAlertMessage(vc: self, titleStr: "Can't borrow!", messageStr: "No Left things ")
            } else {
                let alert = UIAlertController(title: "Write Thing Amount!", message: thing.name, preferredStyle: .alert)
                
                let OkAction = UIAlertAction(title: "Ok!", style: .default) { (action) in
                    let textField = alert.textFields![0]
                    textField.placeholder = "1"
                    
                    let lendingAmount = (textField.text?.isEmpty)! ? "1" : textField.text!
                    let lendingAmountInt: Int? = Int(lendingAmount)
                    
                    let leftThingAmount = Int(thing.leftThingAmount!) - lendingAmountInt!
                    
                    if leftThingAmount >= 0 {
                        
                        let ref = FIRDatabase.database().reference().child("lendsystem")
                        
                        let childRef = ref.childByAutoId()
                        
                        let values = ["studentId": studentId!, "thingId": thing.thingId!, "fromtimestamp": fromtimestamp, "totimestamp": totimestamp, "returnstate": returnstate, "lendingAmount": lendingAmountInt!, "thingName": thingName!, "studentName": studentName!] as [String : AnyObject]
                        
                        childRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                            
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            let studentLendRef = FIRDatabase.database().reference().child("student-lending").child(studentId!)
                            
                            let lendingId = childRef.key
                            studentLendRef.updateChildValues([lendingId: 1])
                            
                            let thingRef = FIRDatabase.database().reference().child("things").child(thing.thingId!)
                            
                            print(lendingAmountInt!)
                            print(thing.leftThingAmount!)
                            thingRef.updateChildValues(["leftThingAmount": leftThingAmount])
                            
                            if(self.sendSearchActive) {
                                
//                                print("updateNumbercollectionb----active")
                                self.savedThings[indexPath.item].leftThingAmount = leftThingAmount as NSNumber
                            } else {
//                                print("updatenumberecollectionb----inactive")
                                self.things[indexPath.item].leftThingAmount = leftThingAmount as NSNumber
                            }
                            
                            let studetsRef = FIRDatabase.database().reference().child("students").child(studentId!)
                            studetsRef.updateChildValues(["returnstate": false])
                            
                            self.attemptReloadCollectionView()
                        })
                        
                    } else {
                        self.showAlert(warnigString: "Invalid Amount!")
                    }
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                
                alert.addTextField { (textField: UITextField) in
                    
                    textField.keyboardAppearance = .dark
                    textField.keyboardType = .numberPad
                    textField.autocorrectionType = .default
                    textField.placeholder = "Type amount"
                    textField.clearButtonMode = .whileEditing
                    
                }
                
                alert.addAction(OkAction)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                

            }
            
        }
        
    }
    
    private func attemptReloadCollectionView() {
        
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.handleReloadCollectionView), userInfo: nil, repeats: false)
        
    }
    
    var timer: Timer?
    
    func handleReloadCollectionView() {
        DispatchQueue.main.async {
            print("reload table")
            self.collectionViewA.reloadData()
            self.collectionViewB.reloadData()
        }
        
    }
    
//    func showAlert() {
//        
//        view.addSubview(invalidCommandLabel)
//        
//        invalidCommandLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        invalidCommandLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        fadeViewInThenOut(view: invalidCommandLabel, delay: 3)
//        
//    }
    
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
    
    func compareLendStateWithDb(selectedThingId: String) {
        
        print(selectedThingId)
        let ref = FIRDatabase.database().reference().child("lendsystem")

        ref.queryOrdered(byChild: "thingId").observe(.childAdded, with: { (snapshot) in
            
            print(snapshot)
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
        
            if let thingId = dictionary["thingId"] as? String {
                
                if thingId == selectedThingId {
                    
                    if let studentId = dictionary["studentId"] as? String {
                        
                        if studentId == self.student?.studentId {
                            
                            showAlertMessage(vc: self, titleStr: "Can't borrow this", messageStr: "Already lended")
                            return
                            
                        }
                        
                    }
                }
                
            }
        }, withCancel: nil)
    
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.collectionViewA {
            
            return lendingThings.count
            
        } else {
            
            if(searchActive) {
//                print("active number---")
                return savedThings.count
            }
//            print("inactive number----")
            return things.count
            
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if collectionView == self.collectionViewA {
            
            return 1
            
        } else {
            
            return 1
            
        }
        
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
        print("didbegin---", searchActive)
        searchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("didend----", searchActive)
        searchActive = false
        

    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
        fastSearchBar.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        savedThings = self.things.filter { $0.name!.contains(searchText) }
        
        if(savedThings.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        print("searchresult---", searchActive)
        self.collectionViewB.reloadData()
        
    }

}



class ThingCell: UICollectionViewCell {
    
    let containerView: UIView = {
        
        let view = UIView()
//        view.backgroundColor = UIColor.orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let containerImageView: UIView = {
        
        let view = UIView()
        view.layer.cornerRadius = Student_Image_Radius * 0.95 / 2
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = DEVICE_WIDTH * 0.004
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let thingImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "thing_default_image.jpeg")
        imageView.layer.cornerRadius = Student_Image_Radius * 0.62 / 2
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    let thingNameLabel: UILabel = {
        
        let label = UILabel()
        //        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.033, weight: UIFontWeightMedium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let thingAllAmountLabel: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(r: 52, g: 168, b: 83)
        label.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.024, weight: UIFontWeightMedium)
        label.layer.cornerRadius = DEVICE_WIDTH * 0.025
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = DEVICE_WIDTH * 0.003
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setViews()
        
    }
    
    func setViews() {
        
        addSubview(containerView)
        containerView.addSubview(containerImageView)
        containerView.addSubview(thingImageView)
        containerView.addSubview(thingNameLabel)
        
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        containerImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        containerImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DEVICE_WIDTH * 0.021).isActive = true
        containerImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius * 0.95).isActive = true
        containerImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius * 0.95).isActive = true
        
        containerImageView.addSubview(thingImageView)
        
        thingImageView.centerXAnchor.constraint(equalTo: containerImageView.centerXAnchor).isActive = true
        thingImageView.centerYAnchor.constraint(equalTo: containerImageView.centerYAnchor).isActive = true
        thingImageView.widthAnchor.constraint(equalToConstant: Student_Image_Radius * 0.62).isActive = true
        thingImageView.heightAnchor.constraint(equalToConstant: Student_Image_Radius * 0.62).isActive = true
        
        thingNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        thingNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        thingNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        
        containerView.addSubview(thingAllAmountLabel)
        
        thingAllAmountLabel.bottomAnchor.constraint(equalTo: containerImageView.bottomAnchor, constant: -DEVICE_WIDTH * 0.018).isActive = true
        thingAllAmountLabel.rightAnchor.constraint(equalTo: containerImageView.rightAnchor, constant: DEVICE_WIDTH * 0.013).isActive = true
        thingAllAmountLabel.widthAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.05).isActive = true
        thingAllAmountLabel.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.05).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}












