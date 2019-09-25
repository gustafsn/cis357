//
//  ViewController.swift
//  UnitConverter
//
//  Created by user159631 on 9/24/19.
//  Copyright © 2019 user159631. All rights reserved.
//

import UIKit

//protocol SettingsViewControllerDelegate {
//    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit)
//    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit)
//}

class ViewController: UIViewController, UITextFieldDelegate, SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit) {
//        self.toUnits.text = toUnits
//        self.from
    }
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit) {
        <#code#>
    }
    
    

    @IBOutlet weak var toUnits: UILabel!
    @IBOutlet weak var fromUnits: UILabel!
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    
    var mode = CalculatorMode.Length
    var direction: String = ""
    var cancel = false
    
    @IBAction func modeButton(_ sender: Any) {
        self.dismissKeyboard()
        if mode == CalculatorMode.Length {
            mode = CalculatorMode.Volume
            fromUnits.text = "Liters"
            toUnits.text = "Gallons"
        }
        else {
            mode = CalculatorMode.Length
            fromUnits.text = "Yards"
            toUnits.text = "Meters"
        }
        self.fromField.text = ""
        self.toField.text = ""
        
    }
    @IBAction func clearButton(_ sender: Any) {
        self.toField.text = nil
        self.fromField.text = nil
        self.dismissKeyboard()
    }
    @IBAction func calcButton(_ sender: Any) {
        var fieldDecVal: Double
        if self.toField.text == "" && self.fromField.text == "" {
        }
        else if self.toField.text != ""{
            direction = "from"
            fieldDecVal = Double(self.toField.text!)!
            self.fromField.text = String(convert(fieldDecVal))
        }
        else if self.fromField.text != ""{
            direction = "to"
            fieldDecVal = Double(self.fromField.text!)!
            self.toField.text = String(convert(fieldDecVal))
        }
        self.dismissKeyboard()
    }
    
    func convert(_ fieldVal: Double) -> Double {
        if mode == CalculatorMode.Length {
            if direction == "from" {
                var lenKey = LengthConversionKey(toUnits: LengthUnit(rawValue: self.fromUnits.text!)!, fromUnits: LengthUnit(rawValue: self.toUnits.text!)!)
                return fieldVal * lengthConversionTable[lenKey]!
            }
            else if direction == "to" {
                var lenKey = LengthConversionKey(toUnits: LengthUnit(rawValue: self.toUnits.text!)!, fromUnits: LengthUnit(rawValue: self.fromUnits.text!)!)
                return fieldVal * lengthConversionTable[lenKey]!
            }
        }
        else if mode == CalculatorMode.Volume {
            if direction == "from" {
                var volKey = VolumeConversionKey(toUnits: VolumeUnit(rawValue: self.fromUnits.text!)!, fromUnits: VolumeUnit(rawValue: self.toUnits.text!)!)
                return fieldVal * volumeConversionTable[volKey]!
            }
            else if direction == "to" {
                var volKey = VolumeConversionKey(toUnits: VolumeUnit(rawValue: self.toUnits.text!)!, fromUnits: VolumeUnit(rawValue: self.fromUnits.text!)!)
                return fieldVal * volumeConversionTable[volKey]!
            }
        }
        return fieldVal
    }
  
    @IBAction func cancel(segue: UIStoryboardSegue) {
        cancel = true;
    }
    
    @IBAction func save(segue: UIStoryboardSegue) {
        cancel = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let detectFocus = UITapGestureRecognizer(target: self, action:
//            #selector(self.clearField(_:)))
//        self.fromField.addGestureRecognizer(detectFocus)
//        self.toField.addGestureRecognizer(detectFocus)
        
        
        
        let detectTouch = UITapGestureRecognizer(target: self, action:
            #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
        toField.delegate = self
        fromField.delegate = self
    }
    
    @objc func clearField(_ sender: UITapGestureRecognizer) {
        if fromField.isEditing{
            toField.text = nil
        }
        else {
            fromField.text = nil
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    
}

extension ViewController{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.fromField{
            self.toField.text = nil
        }
        else{
            self.fromField.text = nil
        }
    }
}

