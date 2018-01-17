//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase
import SVProgressHUD //allows user to keep up with the progress of the app
//with notifications
class LogInViewController: UIViewController {

    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   
    @IBAction func logInPressed(_ sender: AnyObject) {
        //Auth class is only available in IBAction
        SVProgressHUD.show() //shows the loading icon
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!){
            (user,error) in
            
            if error != nil{
            print(error!)
            SVProgressHUD.dismiss()
                // create the alert
                let alert = UIAlertController(title: "Password", message: "The password or username is incorrect", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else {
                SVProgressHUD.dismiss()//loading icon appears after the login button is clicked now its dismissed after successful login
                
                self.performSegue(withIdentifier: "goToChat", sender: self)
            }
        }
            
        }
        //TODO: Log in the user
        
    
    }
