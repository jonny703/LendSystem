//
//  BorrowedStudentsController.swift
//  LendSystem
//
//  Created by John Nik on 21/04/2017.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class BorrowedStudentsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UISearchBarDelegate {
    
    let CollectionViewCell_Borrowed_Identifier = "CellOther"
    
    var students = [Student]()
    var savedStudents = [Student]()
    var searchActive: Bool = false
    
    
    lazy var fastSearchView: UISearchBar = {
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
        layout.itemSize = CGSize(width: DEVICE_WIDTH * 0.24, height: DEVICE_WIDTH * 0.24)
        
        let frame = CGRect(x: 0, y: 0, width: DEVICE_WIDTH * 0.8, height: DEVICE_WIDTH * 0.93)
        colView = UICollectionView(frame: frame, collectionViewLayout: layout)
        colView.backgroundColor = UIColor.white
        colView.showsVerticalScrollIndicator = false
        colView.translatesAutoresizingMaskIntoConstraints = false
        return colView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Active Students"
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        view.addSubview(fastSearchView)
        view.addSubview(collectionView)
        
        setupFastSearchView()
        setupCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(StudentCell.self, forCellWithReuseIdentifier: CollectionViewCell_Borrowed_Identifier)
        
        fetchStudents()
    }

    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchStudents() {
        
        self.students.removeAll()
        
        FIRDatabase.database().reference().child("student-lending").observe(.childAdded, with: { (snapshot) in
            
            let borrowedStudentId = snapshot.key
            
            FIRDatabase.database().reference().child("students").child(borrowedStudentId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let student = Student()
                    student.studentId = borrowedStudentId
                    student.setValuesForKeys(dictionary)
                    self.students.append(student)
                    
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
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
    
    
    
    func setupFastSearchView() {
        
        fastSearchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        fastSearchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        //        fastSearchBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        fastSearchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.054).isActive = true
        fastSearchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.054).isActive = true
        fastSearchView.heightAnchor.constraint(equalToConstant: DEVICE_WIDTH * 0.13).isActive = true
        
    }
    
    func setupCollectionView() {
        
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: fastSearchView.bottomAnchor, constant: DEVICE_WIDTH * 0.026).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: DEVICE_WIDTH * 0.026).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -DEVICE_WIDTH * 0.026).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -DEVICE_WIDTH * 0.026).isActive = true
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell_Borrowed_Identifier, for: indexPath) as! StudentCell
        
        let student: Student
        if(searchActive) {
            student = savedStudents[indexPath.item]
        } else {
            student = students[indexPath.item]
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
        
        fastSearchView.resignFirstResponder()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        fastSearchView.endEditing(true)
        
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
        fastSearchView.endEditing(true)

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
