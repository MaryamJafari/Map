//
//  ViewController.swift
//  Map Kit
//
//  Created by Maryam Jafari on 9/18/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit


class  ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var fromCity: UITextField!
    @IBOutlet weak var fromStreetAdrees: UITextField!
    
    @IBOutlet weak var fromZip: UITextField!
    @IBOutlet weak var fromState: UITextField!
    
    @IBOutlet weak var toCity: UITextField!
    @IBOutlet weak var toStreetAdrees: UITextField!
    
    @IBOutlet weak var toZip: UITextField!
    @IBOutlet weak var toState: UITextField!
    var toStreetAddresstext: String!
    var toCitytext: String!
    var toStatetext: String!
    var toZiptext: String!
    var fromStreetAddresstext: String!
    var fromCitytext: String!
    var fromStatetext: String!
    var fromZiptext: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromStreetAdrees.delegate = self
        fromCity.delegate = self
        fromZip.delegate = self
        fromState.delegate = self
        toCity.delegate = self
        toStreetAdrees.delegate = self
        toZip.delegate = self
        toState.delegate = self
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool 
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func map(_ sender: Any) {
        if let address = fromStreetAdrees.text{
            fromStreetAddresstext = address
        }
        if let cityName = fromCity.text{
            fromCitytext = cityName
        }
        if let stateName = fromState.text{
            fromStatetext = stateName
        }
        if let zipcode = fromZip.text{
            fromZiptext = zipcode
        }
        
        let   completedFromAddress = "\(fromStreetAddresstext!) \(fromCitytext!) \(fromStatetext!) \(fromZiptext!)"
        
        if let address = toStreetAdrees.text{
            toStreetAddresstext = address
        }
        if let cityName = toCity.text{
            toCitytext = cityName
        }
        if let stateName = toState.text{
            toStatetext = stateName
        }
        if let zipcode = toZip.text{
            toZiptext = zipcode
        }
        let completedToAddress = "\(toStreetAddresstext!) \(toCitytext!) \(toStatetext!) \(toZiptext!)"
        performSegue(withIdentifier: "Map", sender: [completedFromAddress,completedToAddress])
        
    }
    
    @IBAction func route(_ sender: Any) {
        if let address = fromStreetAdrees.text{
            fromStreetAddresstext = address
        }
        if let cityName = fromCity.text{
            fromCitytext = cityName
        }
        if let stateName = fromState.text{
            fromStatetext = stateName
        }
        if let zipcode = fromZip.text{
            fromZiptext = zipcode
        }
        
        let   completedFromAddress = "\(fromStreetAddresstext!) \(fromCitytext!) \(fromStatetext!) \(fromZiptext!)"
        
        if let address = toStreetAdrees.text{
            toStreetAddresstext = address
        }
        if let cityName = toCity.text{
            toCitytext = cityName
        }
        if let stateName = toState.text{
            toStatetext = stateName
        }
        if let zipcode = toZip.text{
            toZiptext = zipcode
        }
        let completedToAddress = "\(toStreetAddresstext!) \(toCitytext!) \(toStatetext!) \(toZiptext!)"
        performSegue(withIdentifier: "Route", sender: [completedFromAddress,completedToAddress])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map"{
            if let destination = segue.destination as? Map{
                if let address = sender as? [String]{
                    destination.addresses = address
                }
            }
        }
        if segue.identifier == "Route"{
            if let destination = segue.destination as? Rout{
                if let address = sender as? [String]{
                    destination.addresses = address
                }
            }
        }
    }
    
}

