//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase //Database access
import SVProgressHUD //updates user with progress of app
class RegisterViewController: UIViewController {

    
    //Pre-linked IBOutlets

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

  
    @IBAction func registerPressed(_ sender: AnyObject) {
        
        SVProgressHUD.show()
        
        //TODO: Set up a new user on our Firbase database
        //creating user in the background
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) {
            (user,error) in
           //completion handler, then callback and closure gets executed.
            if error != nil {
                print(error!)
            } else {
                SVProgressHUD.dismiss()
                //success
                print("registration successful")
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
        

        
        
    } 
    
    
}
