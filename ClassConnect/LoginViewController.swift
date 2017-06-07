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
    private var smallId: String!
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        /*
        if let localId = idTextField.text {
            ref.child("allCodes").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! NSDictionary
                if let _ = value[localId] {
                    print(localId)
                    self.smallId = localId
                }
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
        }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            /*
            let preVc = segue.destination as! UINavigationController
            let vc = preVc.topViewController as! QuestionsViewController
            if let localId = smallId {
                UserDefaults.standard.setValue(localId, forKey: "idDefault")
            }
 */
            if let localId = idTextField.text {
                ref.child("allCodes").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    if let _ = value[localId] {
                        print(localId)
                        
                        UserDefaults.standard.set(localId, forKey: "idDefault")
                    }
                }, withCancel: { (error) in
                    print(error.localizedDescription)
                })
            }
        }
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
