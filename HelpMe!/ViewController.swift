//
//  ViewController.swift
//  HelpMe!
//
//  Created by Aidan on 6/19/19.
//  Copyright © 2019 Aidan Lilani. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

//let fileURL = Bundle.main.url(forResource: "TopSecret", withExtension: "url")
//
//let fileContent = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
//get folder working first then uncomment


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    struct EmergencyData {
        var country: String
        var url: String
        var isPolice: Bool
        var isFire: Bool
        var isAmbulance: Bool
        var isDispatch: Bool
    }
    
    struct EmergencyPhoneNumber {
        var countryName = ""
        var POliceNumber = ""
        var FIreNumber = ""
        var AMbulanceNumber = ""
        var DIspatchNumber: String = ""
    }
    
    var emergencyNumbers: [EmergencyPhoneNumber] = []
    
    
    @IBOutlet weak var callPoliceButton: UIButton!
    @IBOutlet weak var callFireButton: UIButton!
    @IBOutlet weak var callAmbulenceButton: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var emergencyPhonesArray = [EmergencyPhoneNumber]()
    var policeNumber = ""
    var fireNumber = ""
    var ambulanceNumber = ""
    var dispatchNumber: String = ""
    var countryCode = ""
    var emergencyArray: [EmergencyData] = []
    //    var emergencyNumberArray = [policeNumber, fireNumber, ambulanceNumber, dispatchNumber]
    var selectedCountry = ""
    
    private let dataSource = ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Barbuda", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Trty.", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Caicos Islands", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "French Southern Territories", "Futuna Islands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard", "Herzegovina", "Holy See", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran (Islamic Republic of)", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Jan Mayen Islands", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea", "Korea (Democratic)", "Kuwait", "Kyrgyzstan", "Lao", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya", "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "McDonald Islands", "Mexico", "Micronesia", "Miquelon", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "Netherlands Antilles", "Nevis", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Principe", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation", "Rwanda", "Saint Barthelemy", "Saint Helena", "Saint Kitts", "Saint Lucia", "Saint Martin (French part)", "Saint Pierre", "Saint Vincent", "Samoa", "San Marino", "Sao Tome", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia", "South Sandwich Islands", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "The Grenadines", "Timor-Leste", "Tobago", "Togo", "Tokelau", "Tonga", "Trinidad", "Tunisia", "Turkey", "Turkmenistan", "Turks Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "US Minor Outlying Islands", "Uzbekistan", "Vanuatu", "Vatican City State", "Venezuela", "Vietnam", "Virgin Islands (British)", "Virgin Islands (US)", "Wallis", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNumbers()
//        locationManager.requestAlwaysAuthorization()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.startMonitoringSignificantLocationChanges()
//        }
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        selectedCountry = dataSource[pickerView.selectedRow(inComponent: 0)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let currentLocation = locations.first else { return }
//        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
//            guard let currentLocPlacemark = placemarks?.first else { return }
//            print(currentLocPlacemark.country ?? "No country found")
//            print(currentLocPlacemark.isoCountryCode ?? "No country code found")
//            self.countryCode = currentLocPlacemark.isoCountryCode!
//        }
//    }
    
    func phone(phoneNum: String) {
        guard let number = URL(string: "tel:// + \(phoneNum)") else { return }
        UIApplication.shared.open(number)
    }
    
    
    
    func getNumbers() {
        
        
        if let path = Bundle.main.url(forResource: "data", withExtension: "txt") {
            // if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                
                let data = try Data(contentsOf: path)
                
                // let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = try JSON(data: data)
                
                
                let numberOfCountries = json["data"].count
                print("***** numberOfCountries = \(numberOfCountries)")
                for index in 0...numberOfCountries-1 {
                    var ambulanceNumber = ""
              
                    let country = json["data"][index]["Country"]["Name"].stringValue
                    
                    let ambulanceArray = json["data"][index]["Ambulance"]["All"]
                    if ambulanceArray.count > 0 {
                        ambulanceNumber = json["data"][index]["Ambulance"]["All"][0].stringValue
              
                    }
                    let policeArray = json["data"][index]["Police"]["All"]
                    if policeArray.count > 0 {
                        policeNumber = json["data"][index]["Police"]["All"][0].stringValue
             
                    }
                    
                    let fireArray = json["data"][index]["Fire"]["All"]
                    if fireArray.count > 0 {
                        fireNumber = json["data"][index]["Fire"]["All"][0].stringValue
                   
                    }
                    let dispatchArray = json["data"][index]["Dispatch"]["All"]
                    if dispatchArray.count > 0 {
                        dispatchNumber = json["data"][index]["Dispatch"]["All"][0].stringValue
                     
                    }
                    let emergencyNumber = EmergencyPhoneNumber(countryName: country, POliceNumber: policeNumber, FIreNumber: fireNumber, AMbulanceNumber: ambulanceNumber, DIspatchNumber: dispatchNumber)
                    emergencyNumbers.append(emergencyNumber)
                }
               
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
    
    
    
    @IBAction func callPolicePressed(_ sender: UIButton) {
        policeNumber = ""
//        for index in 0...numberOfComponents(in: pickerView) {
////            emergencyNumbers[selectedCountry].PO
//        }
        phone(phoneNum: policeNumber)
    }
    @IBAction func callFirePressed(_ sender: UIButton) {
        phone(phoneNum: fireNumber)
    }
    @IBAction func callAmbulancePressed(_ sender: UIButton) {
        phone(phoneNum: ambulanceNumber)
    }
    @IBAction func callDispatchPressed(_ sender: UIButton) {
        phone(phoneNum: dispatchNumber)
    }
    
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = dataSource[row]
        print("******" +  dataSource[row])
        countryLabel.text = selectedCountry
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }

    
}
