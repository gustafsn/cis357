//
//  ViewController.swift
//  UnitConverter
//
//  Created by Quinn Meagher.
//  Copyright © 2019 Quinn Meagher. All rights reserved.
//

import UIKit
									
class ViewController: UIViewController, SettingsViewControllerDelegate {
    

    @IBOutlet weak var toUnits: DecimalMinusTextField!
    @IBOutlet weak var fromUnits: DecimalMinusTextField!
    
    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    
    var mode = CalculatorMode.Length
    var direction: String = ""
    var cancel = false
    
    var fromLen = LengthUnit.Yards
    var toLen = LengthUnit.Meters
    
    var fromVol = VolumeUnit.Liters
    var toVol = VolumeUnit.Gallons
    
    @IBAction func modeButton(_ sender: Any) {
        self.dismissKeyboard()
        if mode == CalculatorMode.Length {
            self.fromUnits.text! = "\(self.fromVol)"
            self.toUnits.text! = "\(self.toVol)"
            fromField.placeholder = "Enter a Volume in \(self.fromVol)"
            fromField.placeholder = "Enter a Volume in \(self.toVol)"
            mode = CalculatorMode.Volume
        }
        else {
            self.fromUnits.text! = "\(self.fromLen)"
            self.toUnits.text! = "\(self.toLen)"
            fromField.placeholder = "Enter a Volume in \(self.fromLen)"
            fromField.placeholder = "Enter a Volume in \(self.toLen)"
            mode = CalculatorMode.Length
        }
        
    }
    @IBAction func clearButton(_ sender: Any) {
        self.toField.text = nil
        self.fromField.text = nil
        self.dismissKeyboard()
    }
    @IBAction func calcButton(_ sender: Any) {
        if(self.mode == .Length){
            if (self.fromField.text != ""){
                let fromVal = Double(self.fromField.text!)
                let convKey = LengthConversionKey(toUnits: toLen, fromUnits: fromLen)
                let toVal = fromVal! * lengthConversionTable[convKey]!
                self.toField.text = String(toVal)
            } else if(self.toField.text != ""){
                let toVal = Double(self.toField.text!)
                let convKey = LengthConversionKey(toUnits: fromLen, fromUnits: toLen)
                let fromVal = toVal! * lengthConversionTable[convKey]!
                self.fromField.text = String(fromVal)
            } else {
                self.fromField.text = String(0)
                self.toField.text = String(0)
            }
        } else {
            if (self.fromField.text != ""){
                let fromVal = Double(self.fromField.text!)
                let convKey = VolumeConversionKey(toUnits: toVol, fromUnits: fromVol)
                let toVal = fromVal! *
                    volumeConversionTable[convKey]!
                self.toField.text = String(toVal)
            } else if(self.toField.text != "") {
                let toVal = Double(self.toField.text!)
                let convKey = VolumeConversionKey(toUnits: fromVol, fromUnits: toVol)
                let fromVal = toVal! * volumeConversionTable[convKey]!
                self.fromField.text = String(fromVal)
            } else {
                self.fromField.text = String(0)
                self.toField.text = String(0)
            }
        }  
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let settings = segue.destination.children[0] as? SettingsViewController{
            settings.delegate = self
            settings.mode = self.mode
            settings.fromLen = self.fromLen
            settings.toLen = self.toLen
            settings.fromVol = self.fromVol
            settings.toVol = self.toVol
        }
    }
    
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit) {
        if(cancel == false){
                self.toLen = toUnits
                self.fromLen = fromUnits
                fromField.placeholder = "Enter a length in \(self.fromLen)"
                toField.placeholder = "Enter a length in \(self.toLen)"
                self.fromUnits.text = "\(self.fromLen)"
                self.toUnits.text = "\(self.toLen)"
            }
    }
    
    
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit) {
        if(cancel == false){
            self.toVol = toUnits
            self.fromVol = fromUnits
            fromField.placeholder = "Enter a Volume in \(self.fromVol)"
            toField.placeholder = "Enter a Volume in \(self.toVol)"
            self.fromUnits.text = "\(self.fromVol)"
            self.toUnits.text = "\(self.toVol)"
        }
    }
    @IBAction func cancel(segue: UIStoryboardSegue) {
        cancel = true;
    }
    
    @IBAction func save(segue: UIStoryboardSegue) {
        cancel = false;
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromField.clearsOnBeginEditing = true
        self.toField.clearsOnBeginEditing = true
    
        let detectTouch: UIGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(detectTouch)
    }
    
    @objc func clearField(_ sender: UITapGestureRecognizer) {
        if fromField.isEditing{
            toField.text = nil
        }
        else {
            fromField.text = nil
        }
    }
    
    @IBAction func fromBeganEditing(_ sender: Any) {
        self.toUnits.text = ""
    }
    
    @IBAction func tobeganEditing(_ sender: Any) {
        self.fromUnits.text = ""
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

