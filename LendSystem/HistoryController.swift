//
//  HistoryController.swift
//  LendSystem
//
//  Created by John Nik on 20/04/2017.
//  Copyright © 2017 johnik703. All rights reserved.
//

import UIKit
import Firebase

class HistoryController: UITableViewController {
    
    let cellId = "cellId"
    
    var histories = [LendSystem]()

    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicatorView)
        setupActivityIndicaterView()

        navigationItem.title = "History"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        tableView.register(HistoryCell.self, forCellReuseIdentifier: cellId)
        fetchHistories()
        
    }
    
    func setupActivityIndicaterView() {
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchHistories() {
        activityIndicatorView.stopAnimating()
        histories.removeAll()
        FIRDatabase.database().reference().child("lendsystem").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let history = LendSystem()
                print(dictionary)
                history.id = snapshot.key
                history.setValuesForKeys(dictionary)
                
                
                self.histories.append(history)
                
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return DEVICE_WIDTH * 0.133
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DEVICE_WIDTH * 0.125
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: DEVICE_WIDTH * 0.133))
        view.backgroundColor = UIColor.lightGray
        
        let timeLabel = UILabel()
        timeLabel.text = "Time"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.layer.borderWidth = DEVICE_WIDTH * 0.003
        timeLabel.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        timeLabel.layer.borderColor = UIColor.black.cgColor
        timeLabel.textAlignment = .center
        
        let studentNameLabel = UILabel()
        studentNameLabel.translatesAutoresizingMaskIntoConstraints = false
        studentNameLabel.layer.borderWidth = DEVICE_WIDTH * 0.003
        studentNameLabel.text = "Name"
        studentNameLabel.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        studentNameLabel.layer.borderColor = UIColor.black.cgColor
        studentNameLabel.textAlignment = .center
        
        let actionLabel = UILabel()
        actionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionLabel.layer.borderWidth = DEVICE_WIDTH * 0.003
        actionLabel.text = "Action"
        actionLabel.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        actionLabel.layer.borderColor = UIColor.black.cgColor
        actionLabel.textAlignment = .center
        
        let thingNameLabel = UILabel()
        thingNameLabel.translatesAutoresizingMaskIntoConstraints = false
        thingNameLabel.layer.borderWidth = DEVICE_WIDTH * 0.003
        thingNameLabel.text = "Thing"
        thingNameLabel.font = UIFont.systemFont(ofSize: DEVICE_WIDTH * 0.04)
        thingNameLabel.layer.borderColor = UIColor.black.cgColor
        thingNameLabel.textAlignment = .center
        
        
        view.addSubview(timeLabel)
        view.addSubview(studentNameLabel)
        view.addSubview(actionLabel)
        view.addSubview(thingNameLabel)
        
        timeLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        studentNameLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor).isActive = true
        studentNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        studentNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4).isActive = true
        studentNameLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        actionLabel.leftAnchor.constraint(equalTo: studentNameLabel.rightAnchor).isActive = true
        actionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        actionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4).isActive = true
        actionLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        thingNameLabel.leftAnchor.constraint(equalTo: actionLabel.rightAnchor).isActive = true
        thingNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        thingNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 4).isActive = true
        thingNameLabel.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HistoryCell
        
        let history = histories[indexPath.row]
        
        
        
        cell.studentNameLabel.text = history.studentName
        cell.thingNameLabel.text = history.thingName

        if history.returnstate == 1 {
            cell.actionLabel.text = "Returned"
            cell.actionLabel.textColor = UIColor.blue
            
            if let seconds = history.totimestamp?.doubleValue {
                let fromtimestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM hh:mm:a"
                cell.timeLabel.text = dateFormatter.string(from: fromtimestampDate as Date)
                
            }
        } else {
            cell.actionLabel.text = "Borrowed"
            cell.actionLabel.textColor = UIColor.black
            
            if let seconds = history.fromtimestamp?.doubleValue {
                let fromtimestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM hh:mm:a"
                cell.timeLabel.text = dateFormatter.string(from: fromtimestampDate as Date)                
            }
        }
        return cell
    }
}
















