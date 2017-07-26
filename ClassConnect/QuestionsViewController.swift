//
//  QuestionsViewController.swift
//  ClassConnect
//
//  Created by Nguyen Do on 6/6/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var questionTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
    var currentId = ""
    private var currentSize = 0
    
    private var isTeacher = false
    
    private let userDefaults = UserDefaults.standard
    
    // Firebase
    var ref: DatabaseReference = Database.database().reference()
    
    private var questions = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //questions = getData()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableViewCell
        
        cell.questionText.text = questions[indexPath.item]
        if cell.questionText.text?.range(of: "*/*/*" + currentId) != nil {
            let str = cell.questionText.text!
            
            cell.questionText.textColor = UIColor.red
            let index = str.index(str.startIndex, offsetBy: 11)
            cell.questionText.text = str.substring(from: index)
        } else {
            cell.questionText.textColor = UIColor.black
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 19.5
        return UITableViewAutomaticDimension
    }
    
    @IBAction func sendClickOnTextField(_ sender: Any) {
        send()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        send()
    }
    
    private func send() {
        
        if var localString = questionTextField.text {
            
            if checkValidity(check: localString) {
                
                while [Character](localString.characters)[0] == " " {
                    localString.remove(at: localString.startIndex)
                }
                
                if userDefaults.bool(forKey: "teacher") {
                    localString = "*/*/*" + currentId + localString
                }
                self.ref.child(currentId + "/" + String(currentSize)).setValue(localString)
                questionTextField.text = ""
                let lastIndex = IndexPath(row: self.currentSize - 1, section: 0)
                currentSize = currentSize + 1
                self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.top, animated: false)
            }
        }
        
    }
    
    
    private func getData() {
    
        
        _ = ref.child(currentId).observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as! NSArray
            let objCArray = NSMutableArray(array: value)
            let localStrings = objCArray as NSArray as! [String]
            
            self.currentSize = localStrings.count
            
            self.questions = localStrings
            self.tableView.reloadData()
            let lastIndex = IndexPath(row: self.currentSize - 1, section: 0)
            self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.top, animated: false)
        })
    
    }
    
    private func checkValidity(check: String) -> Bool {
        
        var flag = false
        
        let arrayChars = [Character](check.characters)
        for char in arrayChars {
            if char != " " {
                flag = true
            }
        }
        
        return flag
        
    }
    
    @IBAction func optionsButtonTapped(_ sender: UIBarButtonItem) {
        
        let message = "Room code: " + currentId
        let alertController = UIAlertController(title: "Options", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        let quitAction = UIAlertAction(title: "Exit Room", style: UIAlertActionStyle.destructive) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        let clearAction = UIAlertAction(title: "Reset Room", style: UIAlertActionStyle.destructive) { (UIAlertAction) in
            self.clearRoom()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (UIAlertAction) in
        }
        
        if userDefaults.bool(forKey: "teacher") {
            
            alertController.addAction(clearAction)
        }
        alertController.addAction(quitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    private func clearRoom() {
        let localSize = questions.count
        for i in 0 ... localSize - 3 {
            ref.child(currentId + "/" + String(localSize - i - 1)).removeValue()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        currentId = userDefaults.string(forKey: "id")!
        isTeacher = userDefaults.bool(forKey: "teacher")
        
        if isTeacher {
            self.title = "Your Room"
        } else {
            self.title = userDefaults.string(forKey: "name")! + "'s Room"
        }
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}
