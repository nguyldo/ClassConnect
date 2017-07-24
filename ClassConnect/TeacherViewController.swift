//
//  TeacherViewController.swift
//  ClassConnect
//
//  Created by Nguyen Do on 6/21/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class TeacherViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var continueButton: UIButton!
    
    private var isCreateClassroom = true
    private let lengthOfId = 6
    private let userDefaults = UserDefaults.standard
    
    var ref: FIRDatabaseReference!
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        isCreateClassroom = !isCreateClassroom
        
        if isCreateClassroom {
            nameLabel.isHidden = false
            nameTextField.isHidden = false
            continueButton.setTitle("Create Classroom", for: .normal)
        } else {
            nameLabel.isHidden = true
            nameTextField.isHidden = true
            continueButton.setTitle("Sign In", for: .normal)
        }
        
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        if isCreateClassroom {
            if let email = self.emailTextField.text,
                let password = self.passwordTextField.text,
                let name = self.nameTextField.text {
            
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    if let u = user {
                        var genId = self.createRandomId(length: self.lengthOfId)
                        while self.checkValidityGenId(code: genId) {
                            genId = self.createRandomId(length: self.lengthOfId)
                            print(genId)
                        }
                        
                        self.ref.child("allCodes/" + genId).setValue(name)
                        
                        self.userDefaults.set(true, forKey: "teacher")
                        self.userDefaults.set(genId, forKey: "id")
                        self.userDefaults.set(name, forKey: "name")
                        
                        self.ref.child(genId + "/0").setValue("Welcome to ClassConnect! The code for this room is: " + genId)
                        self.ref.child(genId + "/1").setValue("Ask your questions below. Any messages from the instructor will be highlighted in red.")
                        
                        self.ref.child("authCodes/" + u.uid).setValue(genId)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "navID")
                        self.present(controller, animated: true, completion: nil)
                        
                    } else {
                        
                    }
                })
                
            }
        } else {
            if let email = emailTextField.text,
                let password = passwordTextField.text {
                
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let u = user {
                        
                        self.setRoomId(uid: u.uid)
                        self.setName(code: self.userDefaults.string(forKey: "id")!)
                        self.userDefaults.set(true, forKey: "teacher")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "navID")
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                })
            }
        }
        
    }
    
    private func createRandomId(length: Int) -> String {
        let letters: NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var returnId = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            returnId += NSString(characters: &nextChar, length: 1) as String
        }
        
        return returnId

    }
    
    private func setName(code: String) {
        
        ref.child("allCodes").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let localName = value?[code] as? String {
                self.userDefaults.set(localName, forKey: "name")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    private func setRoomId(uid: String) {
        
        ref.child("authCodes").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let localCode = value?[uid] as? String {
                self.userDefaults.set(localCode, forKey: "id")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func checkValidityGenId(code: String) -> Bool {
    
        var flag = false
        
        ref.child("allCodes").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            if let _ = value?[code] as? String {
                flag = false
            } else {
                flag = true
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return flag
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
