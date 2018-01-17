//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate //accessing the protocol of changecitydelegate
{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    //TODO: Declare instance variables here
   let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url : String, parameters: [String : String] ){
        //.get retrieves data from HTTP url and nothing else
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)
                //value of repsonse is an optional we can override it as we already checked
                //using the if statement to see if its successful
                self.updateWeatherData(json: weatherJSON)
                //using the in keyword we have to call the function by adding self. as to refer
                //to the class viewcontroller
            }
            else{
                
                self.cityLabel.text = "Connection Issue"
            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    //data in APIs are formated in JSON
    func updateWeatherData(json : JSON){
        //the temperature is located insode main and then in temp and setting it as a double this is inside API code in the website
        if let tempResult = json["main"]["temp"].double{
        //calls JSON data from variable json
        weatherDataModel.temperature = Int(tempResult - 273.15 )
        weatherDataModel.city = json["name"].stringValue
        //weather condition is in weather at the first position 0 then id this is inside the API code
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
    }
        else {
            cityLabel.text = "Weather unavailable"
        }
    }
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
          
            //creating dictionary
            // key made of string and values made of strings
          
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
      //gets weather data
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let destinationVC = segue.destination as! ChangeCityViewController
            // changing the destination property to the type changecityviewcontroller
            
            destinationVC.delegate = self // delegate of the changecityviewcontroller is now the weather view controller
            
        }
        
    }
    
    
    
    
}


