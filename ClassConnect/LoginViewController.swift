//
//  LoginViewController.swift
//  ClassConnect
//
//  Created by Nguyen Do on 6/6/17.
//  Copyright © 2017 Nguyen Do. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func clickReturnOnTextField(_ sender: Any) {
        loadQuestions()
    }
    
    @IBAction func loginButton(_ sender: Any) {
        loadQuestions()
    }
    
    private func loadQuestions() {
        ref.child("allCodes").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if let localCode = value?[self.idTextField.text!] as? String {
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(self.idTextField.text!, forKey: "id")
                userDefaults.set(localCode, forKey: "name")
                userDefaults.set(false, forKey: "teacher")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "navID")
                self.present(controller, animated: true, completion: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
