//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
// Mark and Todo are how to degine sections in swift and we can navigate to the different sections by clicking on the controller C symbol on the navigation bar at the top
//ChatViewController.swift>ChatViewController
import UIKit
import Firebase
import ChameleonFramework //colors
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
  
    
    //Chat view controller is the delegate of table view and it handles the data from table view
    // Declare instance variables here
    //array of message objects, desfined from class message in the model folder
    var messageArray : [Message] = [Message]()
   
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource for the table view here:
        //we can now control the table view and display messages
        // we can change the table view properties
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set yourself as the delegate of the text field here:
        //this is so that we can access the information inside message text field when we tap on the send button
        //set out self as the delegate so we can edit the methods comformed to the text field and change the height when we tap the textfield
        messageTextfield.delegate = self
        
        
        //TODO: Set the tapGesture here:
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped) )
       //selector is a different way of calling a method
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView() // run the function as soon as the view is loaded to size the height
        retrieveMessages()
        //getting rid off the lines that separate messages
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    //for veiwing table view changing the cell to a custom cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        //This is to print your own row cells in the view controller
        //look at class defined in the custom cell folder custummessagecell.swift for method definition
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!{
            //messages we sent setting colors
            
            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } else {
            //messages the other user sent setting their color
            cell.avatarImageView.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatGray()
        }
        //prints messgae in the chat list
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    //inheritence of tableview function as they have different inputs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of messages in the message array in table view when the view loads
        //as this is defined in viewdidload method
        return messageArray.count
    }
    // We do not require the optional section function for the chat app
    
    
    //TODO: Declare tableViewTapped here:
    @objc func tableViewTapped() {
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0;
        
    // Varying the height of the messages so depends on the amount of message typed, by default the height is 120.0, if the message requires a heigher size it will adjust.
    }
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    //to recongnise that it has been tapped
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded() //redraws layout if needed to include the keyboard to type the message
            //Trailing closure
        }
    }
    
    
  
  
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5){
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded() //redraws layout if needed to include the keyboard to type the message
            //Trailing closure
    }
    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    @IBAction func sendPressed(_ sender: Any) {
        messageTextfield.endEditing(true)
        //TODO: Send the message to Firebase and save it in our database
        //disabling the text field and send button whilst the message is being sent
        //so the message is not sent multiple times
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        //Creating firebase database to create child database
        let messagesDB = Database.database().reference().child("Messages")
        //creating dictionary of message storing user email, and messages created by user
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text! ]
        //childbyautoID creates a unique identifier for our messages to store the messages
        //Saves it in our message database messagesDB
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error,reference) in
            
            if error != nil {
                print(error!)
                
            }
            else {
                print ("message saved")
                self.messageTextfield.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextfield.text = ""
            }
        }
    }
        
    
        
        
    
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        // can also be used using closures without with:
        messageDB.observe( .childAdded, with: {
            (snapshot) in
            // setting snapshot value to known datatype as vaue can be of any datatype
            // setting as dictionary with string as its key and string as value
           let snapshotValue =  snapshot.value as! Dictionary< String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            let message = Message()
            message.messageBody = text
            message.sender = sender
            //adding message to data array
            self.messageArray.append(message)
            //configuring table view and reloading the data added
            self.configureTableView()
            self.messageTableView.reloadData()
        })
    }
    
//TODO: Log out the user and send them back to WelcomeViewController
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do{
            try Auth.auth().signOut() //sign out function is prone to error therefore we required do catch block
            
        }
        catch{
            print("error")
        }
        guard (navigationController?.popToRootViewController( animated: true)) != nil
            else {
                print("no view controllers")
                return
        }
    }

}
