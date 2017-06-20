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
    
    // Firebase
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    private var questions = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //questions = getData()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionTableViewCell
        cell.questionText.text = questions[indexPath.item]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 19.5
        return UITableViewAutomaticDimension
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if let localString = questionTextField.text {
            self.ref.child(currentId + "/" + String(currentSize)).setValue(localString)
            questionTextField.text = ""
            let lastIndex = IndexPath(row: self.currentSize - 1, section: 0)
            currentSize = currentSize + 1
            self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.top, animated: false)
        }
    }
    
    private func getData() {
    
        
        var refHandle = ref.child(currentId).observe(FIRDataEventType.value, with: { (snapshot) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        
        let userDefaults = UserDefaults.standard
        currentId = userDefaults.string(forKey: "id")!
        
        
        //print(UserDefaults.standard.value(forKey: "idDefault") as! String)
        //currentId = UserDefaults.standard.value(forKey: "idDefault") as! String
        getData()
        //ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

}
