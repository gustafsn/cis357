//
//  SettingsViewController.swift
//  UnitConverter
//
//  Created by Xcode User on 9/25/19.
//  Copyright © 2019 user159631. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit)
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit)
}


class SettingsViewController: UIViewController{
    
    @IBOutlet weak var fromUnitsSelected: UILabel!
    @IBOutlet weak var toUnitsSelected: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    
    var mode: CalculatorMode?
    var delegate : SettingsViewControllerDelegate?
    var pickerData : [String] = [String]()
    var direction: String = ""
    var selection: String = ""
    var toLen: LengthUnit?
    var fromLen: LengthUnit?
    var toVol: LengthUnit?
    var fromVol: LengthUnit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.isHidden = true
        // Do any additional setup after loading the view.
        
        if mode == .Length {
            LengthUnit.allCases.forEach{
                pickerData.append($0.rawValue)
            }
                self.fromUnitsSelected.text? = self.fromLen!.rawValue
                self.toUnitsSelected.text? = self.toLen!.rawValue
        }
        else {
            VolumeUnit.allCases.forEach{
                pickerData.append($0.rawValue)
            }
            self.fromUnitsSelected.text? = self.fromVol!.rawValue
            self.toUnitsSelected.text? = self.toVol!.rawValue
        }
    
        self.picker.dataSource = self
        self.fromUnitsSelected.isUserInteractionEnabled = true
        self.toUnitsSelected.isUserInteractionEnabled = true
        var fromClickGesture = UITapGestureRecognizer(target: self, action: #selector(fromPicker))
        var toClickGesture = UITapGestureRecognizer(target: self, action: #selector(toPicker))
        var dismissAfterTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector(dismissPicker))
    
        self.view.addGestureRecognizer(dismissAfterTap)
        self.fromUnitsSelected.addGestureRecognizer(fromClickGesture)
        self.toUnitsSelected.addGestureRecognizer(toClickGesture)
}
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        self.picker.isHidden = true
        
        if let data = self.delegate{
            if mode == .Length{
                data.settingsChanged(fromUnits: LengthUnit(rawValue: fromUnitsSelected.text!)!, toUnits: LengthUnit(rawValue: toUnitsSelected.text!)!)
            }
            else{
                data.settingsChanged(fromUnits: VolumeUnit(rawValue: fromUnitsSelected.text!)!, toUnits: VolumeUnit(rawValue: toUnitsSelected.text!)!)
            }
        }
    }
    
    @objc private func fromPicker(){
        self.picker.isHidden = false
        self.becomeFirstResponder()
        self.direction = "from"
    }
    
    @objc private func toPicker(){
        self.picker.isHidden = false
        self.becomeFirstResponder()
        self.direction = "to"
    }
    
    @objc func dismissPicker() {
        self.picker.isHidden = true
        if (self.direction == "to"){
        self.toUnitsSelected.text = self.selection
        } else {
            self.fromUnitsSelected.text = self.selection
        }
        self.direction = ""
    }
    
   

}
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selection = self.pickerData[row]
    }
}
