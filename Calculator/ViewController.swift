//
//  ViewController.swift
//  Calculator
//
//  Created by Павло Тимощук on 11.02.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var numberButtonArr = [UIButton]()
    let insertResultTextField = UITextField()
    let pointButton = UIButton()
    let totalButton = UIButton()
    let plusButton = UIButton()
    let minusButton = UIButton()
    let multiplyButton = UIButton()
    let divideButton = UIButton()
    let myCalculator = UIButton()
    let signChangeButton = UIButton()
    let clearButton = UIButton()
    var plusButtonActive = false
    var minusButtonActive = false
    var multiplyButtonActive = false
    var divideButtonActive = false
    var a = Double()
    var b = Double()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    enum calcModes {
        case defaultMode
        case pyramidMode
        case coneMode
        case cylinderMode
    }
    var currentMode = calcModes.defaultMode
    let calcTypes = ["default","coneMode","cylinderMode","pyramidMode"]
    let imageView = UIImageView()
    let insertFirstValue = UITextField()
    let insertSecondValue = UITextField()
    let resultLabel = UILabel()
    let sideSurfaceArea = UILabel()
    let totalSurfaceArea = UILabel()
    let volumeFigure = UILabel()
    let flexible: UIView.AutoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
    
    //MARK: - Hiding keyboard by RETURN
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func creatingNumberButtons() {
        for num in 0 ... 9 {
            let height = 60
            var width = 60
            var x = 0
            var y = 0
            
            if num < 1          { width = 145; y = 585; x = 30 }
            else if num < 4     { y = 500 }
            else if num < 7     { y = 415 }
            else                { y = 330 }
            
            if num%3 == 1       { x = 30 }
            else if num%3 == 2  { x = 115 }
            else { if num != 0  { x = 200 } }
            
            let numberButton = UIButton()
            numberButton.frame = CGRect(x: x, y: y, width: width, height: height)
            numberButton.setTitle(String(num), for: .normal)
            numberButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
            numberButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
            numberButton.backgroundColor = UIColor(rgb: 0x494C4D)
            numberButton.setBackgroundColor(UIColor(rgb: 0x858585), for: .highlighted)
            numberButton.autoresizingMask = flexible
            numberButton.tag = num
            numberButton.addTarget(self, action: #selector(numberButtonPress), for: .touchUpInside)
            super.view.addSubview(numberButton)
        }
    }
    
    func creatingFunctionalButtons(currentFunctionalButton: UIButton, x: Int, y: Int, title: String, backgroundColor: Int, backgroundColorHighlighted: Int, action: Selector, tag: Int) {
        currentFunctionalButton.frame = CGRect(x: x, y: y, width: 60, height: 60)
        currentFunctionalButton.setTitle(String(title), for: .normal)
        currentFunctionalButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        currentFunctionalButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        currentFunctionalButton.backgroundColor = UIColor(rgb: backgroundColor)
        currentFunctionalButton.setBackgroundColor(UIColor(rgb: backgroundColorHighlighted), for: .highlighted)
        currentFunctionalButton.autoresizingMask = flexible
        currentFunctionalButton.addTarget(self, action: action, for: .touchUpInside)
        currentFunctionalButton.tag = tag
        super.view.addSubview(currentFunctionalButton)
    }
    
    //MARK: - Додавання текстового поля для звичайного калькулятора
    func insertResultTextFieldADD() {
        insertResultTextField.frame = CGRect(x: 30, y: self.view.frame.height/6, width: (17/18*self.view.frame.width)-60, height: self.view.frame.height/8)
        insertResultTextField.borderStyle = .none
        insertResultTextField.placeholder = "0"
        insertResultTextField.font = UIFont.systemFont(ofSize: self.view.frame.height/8, weight: .thin)
        insertResultTextField.textColor = .white
        insertResultTextField.textAlignment = .right
        insertResultTextField.autoresizingMask = flexible
        //MARK: - ADDING SWIPE RIGHT
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        super.view.addSubview(insertResultTextField)
        insertResultTextField.delegate = self
    }
    
    func addIndividualCalculatorItems(paramCalcItem: calcModes) {
        print("param", paramCalcItem, "selected")
        imageView.removeFromSuperview()
        let name: String
        switch paramCalcItem {
        case .coneMode:
            name = "cone"
            insertFirstValue.placeholder = "h"
            insertSecondValue.placeholder = "r"
        case .cylinderMode:
            name = "cylinder"
            insertFirstValue.placeholder = "h"
            insertSecondValue.placeholder = "r"
        case .pyramidMode:
            name = "pyramid"
            insertFirstValue.placeholder = "h"
            insertSecondValue.placeholder = "s"
        default:
            return
        }
        let image = UIImage(named: name)
        
        imageView.image = image!
        imageView.frame = CGRect(x: clearButton.frame.origin.x, y: 50, width: self.view.frame.size.width/5, height: self.view.frame.size.height/4)
        imageView.autoresizingMask = flexible
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        insertFirstValue.frame = CGRect(x: signChangeButton.frame.origin.x+20 , y: imageView.frame.origin.y+30, width: self.view.frame.width/4, height: self.view.frame.height/16)
        insertFirstValue.borderStyle = .line
        insertFirstValue.font = UIFont.systemFont(ofSize: self.view.frame.height/16, weight: .thin)
        insertFirstValue.textColor = .white
        insertFirstValue.textAlignment = .left
        insertFirstValue.autoresizingMask = flexible
        insertFirstValue.delegate = self
        self.view.addSubview(insertFirstValue)
        
        insertSecondValue.frame = CGRect(x: signChangeButton.frame.origin.x+20 , y: imageView.frame.origin.y+imageView.frame.size.height-30-self.view.frame.height/16, width: self.view.frame.width/4, height: self.view.frame.height/16)
        insertSecondValue.borderStyle = .line
        insertSecondValue.font = UIFont.systemFont(ofSize: self.view.frame.height/16, weight: .thin)
        insertSecondValue.textColor = .white
        insertSecondValue.textAlignment = .left
        insertSecondValue.autoresizingMask = flexible
        insertSecondValue.delegate = self
        self.view.addSubview(insertSecondValue)
    }
    
    func creatingFunctionalElements() {
        insertResultTextFieldADD() //MARK: -  Creating insertResultTextField
        creatingFunctionalButtons(currentFunctionalButton: pointButton, x: 200, y: 585, title: ".", backgroundColor: 0x494C4D, backgroundColorHighlighted: 0x858585, action: #selector(functionalButtonPress),tag: 0)
        creatingFunctionalButtons(currentFunctionalButton: totalButton, x: 285, y: 585, title: "=", backgroundColor: 0xFFA91E, backgroundColorHighlighted: 0xCA8516, action: #selector(functionalButtonPress),tag: 1)
        creatingFunctionalButtons(currentFunctionalButton: plusButton, x: 285, y: 500, title: "+", backgroundColor: 0xFFA91E, backgroundColorHighlighted: 0xCA8516, action: #selector(functionalButtonPress),tag: 2)
        creatingFunctionalButtons(currentFunctionalButton: minusButton, x: 285, y: 415, title: "-", backgroundColor: 0xFFA91E, backgroundColorHighlighted: 0xCA8516, action: #selector(functionalButtonPress),tag: 3)
        creatingFunctionalButtons(currentFunctionalButton: multiplyButton, x: 285, y: 330, title: "*", backgroundColor: 0xFFA91E, backgroundColorHighlighted: 0xCA8516, action: #selector(functionalButtonPress),tag: 4)
        creatingFunctionalButtons(currentFunctionalButton: divideButton, x: 285, y: 245, title: "/", backgroundColor: 0xFFA91E, backgroundColorHighlighted: 0xCA8516, action: #selector(functionalButtonPress),tag: 5)
        creatingFunctionalButtons(currentFunctionalButton: clearButton, x: 30, y: 245, title: "AC", backgroundColor: 0x494C4D, backgroundColorHighlighted: 0x858585, action: #selector(functionalButtonPress),tag: 6)
        creatingFunctionalButtons(currentFunctionalButton: signChangeButton, x: 115, y: 245, title: "+/-", backgroundColor: 0x494C4D, backgroundColorHighlighted: 0x858585, action: #selector(functionalButtonPress),tag: 7)
        creatingFunctionalButtons(currentFunctionalButton: myCalculator, x: 200, y: 245, title: "f(x)", backgroundColor: 0x494C4D, backgroundColorHighlighted: 0x858585, action: #selector(functionalButtonPress),tag: 8)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if currentMode == .defaultMode {
            if insertResultTextField.text!.count > 15 { //MARK: - Макс к-сть символів 15
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
                insertResultTextField.text! = insertResultTextField.text![0 ..< 15]
            }
            if !stringIsNumber(rawString: insertResultTextField.text!) //MARK: - Відхилити введення недопустимих символів
            {
                if insertResultTextField.text!.count == 1 {
                    insertResultTextField.text! = ""
                } else if insertResultTextField.text!.count > 1 {
                    insertResultTextField.text! = insertResultTextField.text![0 ..< insertResultTextField.text!.count-1]
                }
            }
        } else {
            if insertFirstValue.text!.count > 15 { //MARK: - Макс к-сть символів 15
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
                insertFirstValue.text! = insertFirstValue.text![0 ..< 15]
            }
            if !stringIsNumber(rawString: insertFirstValue.text!) //MARK: - Відхилити введення недопустимих символів
            {
                if insertFirstValue.text!.count == 1 {
                    insertFirstValue.text! = ""
                } else if insertFirstValue.text!.count > 1 {
                    insertFirstValue.text! = insertFirstValue.text![0 ..< insertFirstValue.text!.count-1]
                }
            }
            
            if insertSecondValue.text!.count > 15 { //MARK: - Макс к-сть символів 15
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
                insertSecondValue.text! = insertSecondValue.text![0 ..< 15]
            }
            if !stringIsNumber(rawString: insertSecondValue.text!) //MARK: - Відхилити введення недопустимих символів
            {
                if insertSecondValue.text!.count == 1 {
                    insertSecondValue.text! = ""
                } else if insertSecondValue.text!.count > 1 {
                    insertSecondValue.text! = insertSecondValue.text![0 ..< insertSecondValue.text!.count-1]
                }
            }
        }
    }
    
    //MARK: - Перевірка на валідність
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentMode == .defaultMode {
            if !stringIsNumber(rawString: insertResultTextField.text!) && insertResultTextField.text! != ""  {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        } else {
            if !stringIsNumber(rawString: insertFirstValue.text!) && !stringIsNumber(rawString: insertSecondValue.text!) &&  insertFirstValue.text! != "" && insertSecondValue.text! != "" { //MARK: - Перевірка на валідність
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        }
    }
    //MARK: - Swipe Right
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right && insertResultTextField.text!.count > 0 {
            print("Swipe Right")
            if let string = insertResultTextField.text
            {
                insertResultTextField.text! = string[0 ..< string.count-1]
            }
        }
    }
    
    //MARK: - ADD Functionality for number buttons
    @objc func numberButtonPress(sender: UIButton) {
        print(sender.tag, "numberButtonPress")
        if currentMode == .defaultMode {
            if insertResultTextField.text!.count < 15 { //MARK: - Макс к-сть символів 15
                if stringIsNumber(rawString: insertResultTextField.text! + String(sender.tag)) {
                    insertResultTextField.text! += String(sender.tag)
                }
            } else {
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
            }
        } else {
            if insertFirstValue.text!.count < 15 { //MARK: - Макс к-сть символів 15
                if stringIsNumber(rawString: insertFirstValue.text! + String(sender.tag)) {
                    insertFirstValue.text! += String(sender.tag)
                }
            } else {
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
            }
        }
    }
    
    //MARK: - Площа основи
    func baseAreaFigureCalc() -> Double {
        var baseAreaFigureValue = Double()
        if let heightFigure =  Double(insertFirstValue.text!), let anotherParamFigure = Double(insertSecondValue.text!) {
            switch currentMode {
                case .coneMode, .cylinderMode:
                    baseAreaFigureValue = pow(anotherParamFigure, 2.0)*Double.pi
                case .pyramidMode:
                    baseAreaFigureValue = (pow(anotherParamFigure, 2.0)-pow(heightFigure, 2.0))*2
                default:
                    break
            }
        }
        return baseAreaFigureValue
    }
    
    //MARK: - Площа бічн. поверхні
    func sideSurfaceAreaFigureCalc() -> Double {
        var sideSurfaceAreaFigureValue = Double()
        if let heightFigure = Double(insertFirstValue.text!), let anotherParamFigure =  Double(insertSecondValue.text!) {
                switch currentMode {
                case .coneMode:
                    sideSurfaceAreaFigureValue = anotherParamFigure*Double.pi*pow(pow(anotherParamFigure, 2)+pow(heightFigure, 2), 0.5)
                case .cylinderMode:
                    sideSurfaceAreaFigureValue = heightFigure*2*Double.pi*anotherParamFigure
                case .pyramidMode:
                    sideSurfaceAreaFigureValue = pow(pow(anotherParamFigure, 2.0)-pow(heightFigure, 2.0),0.5) * 4 * pow(pow(anotherParamFigure, 2.0)-pow(pow(anotherParamFigure, 2.0)-pow(heightFigure, 2.0),0.5)/2, 0.5)
                default:
                    break
                }
        }
        return sideSurfaceAreaFigureValue
    }
    
    //MARK: - Об'єм фігури
    func volumeFigureCalc() -> Double {
        var volumeFigureValue = Double()
        if let heightFigure = Double(insertFirstValue.text!), let _ = Double(insertSecondValue.text!) {
            switch currentMode {
            case .coneMode, .pyramidMode:
                volumeFigureValue = heightFigure*baseAreaFigureCalc()/3
            case .cylinderMode:
                volumeFigureValue = heightFigure*baseAreaFigureCalc()
            default:
                break
            }
        }
        return volumeFigureValue
    }
    
    func operationButtonAction(operationButton: Int) {
        if currentMode == .defaultMode
        {
            if stringIsNumber(rawString: insertResultTextField.text!) {
                a = Double(insertResultTextField.text!)!
                insertResultTextField.text! = ""
                switch operationButton {
                case 2:
                    plusButtonActive = true
                    print("plusButtonPress")
                case 3:
                    minusButtonActive = true
                    print("minusButtonPress")
                case 4:
                    multiplyButtonActive = true
                    print("multiplyButtonPress")
                case 5:
                    divideButtonActive = true
                    print("divideButtonPress")
                default:
                    return
                }
                
            } else {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        }
    }
    
    //MARK: - ADDING FUNCTIONALITY
    @objc func functionalButtonPress(sender: UIButton) {
        switch sender.tag {
        case 0:
            print("pointButtonPress")
            if insertResultTextField.text!.count < 15 { //MARK: - Макс к-сть символів 15
                if stringIsNumber(rawString: insertResultTextField.text! + ".")
                {
                    insertResultTextField.text! += "."
                }
            } else {
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
            }
        case 1:
            print("totalButtonPress")
            if currentMode == .defaultMode
            {
                var c: Double = 0.0
                if plusButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                    plusButtonActive = false
                    c = a + Double(insertResultTextField.text!)!
                    print("Result total:",insertResultTextField.text!)
                }
                if minusButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                    minusButtonActive = false
                    c = a - Double(insertResultTextField.text!)!
                    print("Result total:",insertResultTextField.text!)
                }
                if multiplyButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                    multiplyButtonActive = false
                    c = a * Double(insertResultTextField.text!)!
                    print("Result total:",insertResultTextField.text!)
                }
                if divideButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                    if Float(insertResultTextField.text!) != 0 {
                        divideButtonActive = false
                        c = a / Double(insertResultTextField.text!)!
                        print("Result total:",insertResultTextField.text!)
                    } else {
                        insertResultTextField.text! = "ERROR"
                        print("Result total:",insertResultTextField.text!,"Dividing by 0 is impossible")
                    }
                }
                insertResultTextField.addNumber(c)
            }
            else
            {
                let x = insertFirstValue.frame.origin.x + insertFirstValue.frame.size.width + 20
                let labelWidth = self.view.frame.width/3
                let labelHeight = self.view.frame.height/25
                
                resultLabel.frame = CGRect(x: x, y: 50, width: labelWidth, height: labelHeight)
                sideSurfaceArea.frame = CGRect(x: x, y: self.resultLabel.frame.origin.y+self.resultLabel.frame.size.height+20, width: labelWidth, height: labelHeight)
                totalSurfaceArea.frame = CGRect(x: x, y: self.sideSurfaceArea.frame.origin.y+self.sideSurfaceArea.frame.size.height+20, width: labelWidth, height: labelHeight)
                volumeFigure.frame = CGRect(x: x, y: self.totalSurfaceArea.frame.origin.y+self.totalSurfaceArea.frame.size.height+20, width: labelWidth, height: labelHeight)
                
                resultLabel.font = UIFont.systemFont(ofSize: self.view.frame.height/30, weight: .light)
                sideSurfaceArea.font = UIFont.systemFont(ofSize: self.view.frame.height/30, weight: .light)
                totalSurfaceArea.font = UIFont.systemFont(ofSize: self.view.frame.height/30, weight: .light)
                volumeFigure.font = UIFont.systemFont(ofSize: self.view.frame.height/30, weight: .light)
                
                resultLabel.textColor = .white
                sideSurfaceArea.textColor = .white
                totalSurfaceArea.textColor = .white
                volumeFigure.textColor = .white
                
                resultLabel.textAlignment = .center
                
                resultLabel.autoresizingMask = flexible
                sideSurfaceArea.autoresizingMask = flexible
                totalSurfaceArea.autoresizingMask = flexible
                volumeFigure.autoresizingMask = flexible
                
                self.view.addSubview(resultLabel)
                self.view.addSubview(sideSurfaceArea)
                self.view.addSubview(totalSurfaceArea)
                self.view.addSubview(volumeFigure)
                
                if let a = Double(insertFirstValue.text!), let b = Double(insertSecondValue.text!) {
                    if a > 0 && b > 0 {
                        if currentMode == .pyramidMode {
                            if a < b {
                                resultLabel.text = "Result:"
                                sideSurfaceArea.text = "S^side =" + String(sideSurfaceAreaFigureCalc())
                                totalSurfaceArea.text = "S^total =" + String((sideSurfaceAreaFigureCalc()+baseAreaFigureCalc())/8)
                                volumeFigure.text = "V = " + String(volumeFigureCalc())
                            } else {
                                sideSurfaceArea.removeFromSuperview()
                                totalSurfaceArea.removeFromSuperview()
                                volumeFigure.removeFromSuperview()
                                resultLabel.text = "ERROR"
                                alert(alertTitle: "This is not pyramid", alertMessage: "h must be less than s", alertActionTitle: "Retry")
                                
                            }
                        } else {
                            resultLabel.text = "Result:"
                            sideSurfaceArea.text = "S^side =" + String(sideSurfaceAreaFigureCalc())
                            if currentMode == .cylinderMode {
                                totalSurfaceArea.text = "S^total =" + String((sideSurfaceAreaFigureCalc()+2*baseAreaFigureCalc())/8)
                            } else {
                                totalSurfaceArea.text = "S^total =" + String((sideSurfaceAreaFigureCalc()+baseAreaFigureCalc())/8)
                            }
                            volumeFigure.text = "V = " + String(volumeFigureCalc())
                        }
                    } else {
                        sideSurfaceArea.removeFromSuperview()
                        totalSurfaceArea.removeFromSuperview()
                        volumeFigure.removeFromSuperview()
                        resultLabel.text = "ERROR"
                        alert(alertTitle: "This is not figure", alertMessage: "Params of figure must be positive", alertActionTitle: "Retry")
                    }
                } else {
                    sideSurfaceArea.removeFromSuperview()
                    totalSurfaceArea.removeFromSuperview()
                    volumeFigure.removeFromSuperview()
                    resultLabel.text = "ERROR"
                    alert(alertTitle: "This is not figure", alertMessage: "Params of figure must be positive", alertActionTitle: "Retry")
                }
                
            }
        case 2, 3, 4, 5:
            operationButtonAction(operationButton: sender.tag)
        case 6:
            print("clearButtonPress")
            if currentMode == .defaultMode {
                insertResultTextField.text! = ""
                plusButtonActive = false
                minusButtonActive = false
                multiplyButtonActive = false
                divideButtonActive = false
            }
        case 7:
            print("signChangeButtonPress")
            if insertResultTextField.text != nil  {
                let string = String(insertResultTextField.text!)
                if string[0] == "+" {
                    insertResultTextField.text! = string.replacingOccurrences(of: "+", with: "-")
                } else if string[0] == "-" {
                    insertResultTextField.text! = string.replacingOccurrences(of: "-", with: "+")
                } else {
                  insertResultTextField.text! = "-" + string
                }
            } else { insertResultTextField.text = "-" }
        case 8:
            print("myCalculatorButtonPress")
            picker = UIPickerView.init()
            picker.delegate = self as UIPickerViewDelegate
            picker.backgroundColor = UIColor.black
            picker.setValue(UIColor.white, forKey: "textColor")
            picker.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
            picker.contentMode = .center
            picker.frame = CGRect.init(x: 0, y: super.view.frame.size.height - 300, width: super.view.frame.size.width, height: 300)
            self.view.addSubview(picker)
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: super.view.frame.size.height - 350, width: super.view.frame.size.width, height: 50))
            toolBar.barStyle = .black
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        default:
            print("SOMETHING WENT WRONG !!!!!!!!!!")
        }
    }
    
    func removingLabels() {
        resultLabel.removeFromSuperview()
        sideSurfaceArea.removeFromSuperview()
        totalSurfaceArea.removeFromSuperview()
        volumeFigure.removeFromSuperview()
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        switch currentMode { //MARK: - Переключення режимів
        case .defaultMode:
            imageView.removeFromSuperview()
            insertFirstValue.removeFromSuperview()
            insertSecondValue.removeFromSuperview()
            removingLabels()
            insertResultTextFieldADD()
        case .coneMode,.cylinderMode,.pyramidMode:
            insertResultTextField.removeFromSuperview()
            addIndividualCalculatorItems(paramCalcItem: currentMode)
            removingLabels()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calcTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return calcTypes[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected", calcTypes[row], "calculator mode")
        switch row {
        case 0:
            currentMode = .defaultMode
        case 1:
            currentMode = .coneMode
        case 2:
            currentMode = .cylinderMode
        case 3:
            currentMode = .pyramidMode
        default:
            currentMode = .defaultMode
        }
    }
    
    // MARK: - is string number
    func stringIsNumber(rawString: String) -> Bool {
        var answer = true
        if let a = Double(rawString) { print("NUMBER:", a) }
            else {
                print("NOT A NUMBER:", rawString, "THERE IS THE BUG")
                answer = false
            }
        return answer
    }
    
    // MARK: - make ALERT
    func alert(alertTitle: String, alertMessage: String, alertActionTitle: String)
    {
        AudioServicesPlaySystemSound(SystemSoundID(4095))
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: alertActionTitle, style: .cancel) { (action) in }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
   
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.frame.size.height = 700
        self.view.frame.size.width = 400
        creatingNumberButtons()
        creatingFunctionalElements()
    }

}



//MARK: - RGB to UIColor
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
       )
   }
}

//MARK: - SET BGR color for State
extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
}

//MARK: - Make STRING as ARRAY
extension String {
    var length: Int { return count }
    subscript (i: Int) -> String { return self[i ..< i + 1] }
    func substring(fromIndex: Int) -> String { return self[min(fromIndex, length) ..< length] }
    func substring(toIndex: Int) -> String { return self[0 ..< max(0, toIndex)] }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

//MARK: - Converting numeric value
extension UITextField {
    func addNumber(_ number: Float) {
        self.text = number.truncatingRemainder(dividingBy: 1) > 1.0E-15 || number > Float(Int.max)  ?  String(number) : String(Int(number))
    }
    func addNumber(_ number: Double) {
        self.text = number.truncatingRemainder(dividingBy: 1) > 1.0E-15 || number > Double(Int.max)  ?  String(number) : String(Int(number))
    }
}
