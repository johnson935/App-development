//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//
//to pass data back we have to use protocol sand delegates otherwise we are just creating new objects

import UIKit


//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
    //this function get the weather data for different cities
    // a protocol is like a contract and when calling the protocol we must have the functions/ methods that are specified in the protocol
}


class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    // property of delegate can be filled i.e by calling a viewcontroller as the delegate of the protocol or not filled as indicated by the optional
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!
    //text in box to change cities
    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
        //1 Get the city name the user entered in the text field
        let cityName = changeCityTextField.text!
        
        
        //2 If we have a delegate set, call the method userEnteredANewCityName
        delegate?.userEnteredANewCityName(city: cityName)
        // delegate? is another way of using optional binding so if there is a viewcontroller
        //which is a delegate for the cityname then the function gets called
        //3 dismiss the Change City View Controller to go back to the WeatherViewController
        self.dismiss(animated: true, completion: nil)
        // the dismiss property basically gose backwards
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
