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

class ViewController: UIViewController, UITextFieldDelegate {
    
    var numberButtonArr: [UIButton]!
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
    var a = Float()
    var b = Float()
    
//    @IBOutlet var numberButtonArr: [UIButton]!
//    var numberButtonArr: Array<UIButton> = []
    
    //MARK: - Hiding keyboard by RETURN
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func creatingNumberButtons() {
        for num in 0 ... 9 {
            var height = 60
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
            numberButton.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
            numberButton.translatesAutoresizingMaskIntoConstraints = true
            numberButton.tag = num
            numberButton.addTarget(self, action: #selector(numberButtonPress), for: .touchUpInside)
            
            numberButtonArr?.append(numberButton)
            self.view.addSubview(numberButton)
        }
    }
    
    fileprivate func creatingFunctionalButtons(currentFunctionalButton: UIButton, x: Int, y: Int, title: String, backgroundColor: Int, backgroundColorHighlighted: Int, action: Selector, tag: Int) {
        currentFunctionalButton.frame = CGRect(x: x, y: y, width: 60, height: 60)
        currentFunctionalButton.setTitle(String(title), for: .normal)
        currentFunctionalButton.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        currentFunctionalButton.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        currentFunctionalButton.backgroundColor = UIColor(rgb: backgroundColor)
        currentFunctionalButton.setBackgroundColor(UIColor(rgb: backgroundColorHighlighted), for: .highlighted)
        currentFunctionalButton.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        currentFunctionalButton.translatesAutoresizingMaskIntoConstraints = true
        currentFunctionalButton.addTarget(self, action: action, for: .touchUpInside)
        currentFunctionalButton.tag = tag
        self.view.addSubview(currentFunctionalButton)
    }
    
    fileprivate func creatingFunctionalElements() {
        insertResultTextField.frame = CGRect(x: 30, y: 135, width: 315, height: 70)
        insertResultTextField.borderStyle = .none
        insertResultTextField.placeholder = "0"
        insertResultTextField.font = UIFont.systemFont(ofSize: 70, weight: .thin)
        insertResultTextField.textColor = .white
        insertResultTextField.textAlignment = .right
        insertResultTextField.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
        //MARK: - ADDING SWIPE RIGHT
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        self.view.addSubview(insertResultTextField)
        insertResultTextField.delegate = self // MARK: - 🤔 put in viewDidLoad()???
            
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
        if insertResultTextField.text!.count > 15 { // Макс к-сть символів 7
            alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
            insertResultTextField.text! = insertResultTextField.text![0 ..< 15]
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !stringIsNumber(rawString: insertResultTextField.text!) { //Перевірка на валідність
            alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.right && insertResultTextField.text!.count > 0 {
            print("Swipe Right")
            if let string = insertResultTextField.text
            {
                insertResultTextField.text! = string[0 ..< string.count-1]
            }
        }
    }
    
    @objc func numberButtonPress(sender: UIButton) { // ADD Functionality for number buttons
        print(sender.tag, "numberButtonPress")
        if insertResultTextField.text!.count < 15 { // Макс к-сть символів 7
            insertResultTextField.text! += String(sender.tag)
        } else {
            alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
        }
    }
    
    @objc func functionalButtonPress(sender: UIButton) {
        switch sender.tag { //MARK: - ADD FUNCTIONALITY
        case 0:
            print("pointButtonPress")
            if insertResultTextField.text!.count < 15 { // Макс к-сть символів 7
                insertResultTextField.text! += "."
            } else {
                alert(alertTitle: "Unable to enter", alertMessage: "Max characters reached", alertActionTitle: "Retry")
            }
        case 1:
            print("totalButtonPress")
            if plusButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                plusButtonActive = false
                insertResultTextField.text! = String(a + Float(insertResultTextField.text!)!)
                print("Result total:",insertResultTextField.text!)
            }
            if minusButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                minusButtonActive = false
                insertResultTextField.text! = String(a - Float(insertResultTextField.text!)!)
                print("Result total:",insertResultTextField.text!)
            }
            if multiplyButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                multiplyButtonActive = false
                insertResultTextField.text! = String(a * Float(insertResultTextField.text!)!)
                print("Result total:",insertResultTextField.text!)
            }
            if divideButtonActive && stringIsNumber(rawString: insertResultTextField.text!) {
                if Float(insertResultTextField.text!) != 0 {
                    divideButtonActive = false
                    insertResultTextField.text! = String(a / Float(insertResultTextField.text!)!)
                    print("Result total:",insertResultTextField.text!)
                } else {
                    insertResultTextField.text! = "ERROR"
                    print("Result total:",insertResultTextField.text!,"Dividing by 0 is impossible")
                }
            }
        case 2:
            print("plusButtonPress") //MARK: - TO DO
            if stringIsNumber(rawString: insertResultTextField.text!) {
                a = Float(insertResultTextField.text!)!
                insertResultTextField.text! = ""
                plusButtonActive = true
            } else {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        case 3:
            print("minusButtonPress")
            if stringIsNumber(rawString: insertResultTextField.text!) {
                a = Float(insertResultTextField.text!)!
                insertResultTextField.text! = ""
                minusButtonActive = true
            } else {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        case 4:
            print("multiplyButtonPress")
            if stringIsNumber(rawString: insertResultTextField.text!) {
                a = Float(insertResultTextField.text!)!
                insertResultTextField.text! = ""
                multiplyButtonActive = true
            } else {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        case 5:
            print("divideButtonPress")
            if stringIsNumber(rawString: insertResultTextField.text!) {
                a = Float(insertResultTextField.text!)!
                insertResultTextField.text! = ""
                divideButtonActive = true
            } else {
                alert(alertTitle: "Invalid format", alertMessage: "The data you entered is NOT a number", alertActionTitle: "Retry")
            }
        case 6:
            print("clearButtonPress")
            insertResultTextField.text! = ""
            plusButtonActive = false
            minusButtonActive = false
            multiplyButtonActive = false
            divideButtonActive = false
        case 7:
            print("signChangeButtonPress")
            if insertResultTextField.text != nil {
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
            
        default:
            print("SOMETHING WENT WRONG !!!!!!!!!!")
        }
    }
    
    // MARK: - is string number?
    func stringIsNumber(rawString: String) -> Bool {
        let string = rawString.replacingOccurrences(of: ",", with: ".")
        var answer = true // MARK: - 🤔 remove???
        if string.count == 0 || string[0] == "." { answer = false }
        else {
            var validCharactersCount = 0
            var signCount = 0
            var pointCount = 0
            for currentChar in string {
                if currentChar >= "\u{0030}" && currentChar <= "\u{0039}" || currentChar ==  "." /*|| currentChar == ","*/ || currentChar == "-" || currentChar == "+" || currentChar == " " {
                    validCharactersCount+=1
                    if currentChar == "." /*|| currentChar == ","*/ { pointCount += 1 }
                    if currentChar == "-" || currentChar == "+" { signCount += 1 }
                    if pointCount > 1 || signCount > 1 { answer = false; break }
                }
            }
            if validCharactersCount != string.count { answer = false }
            if signCount == 1 && string[0] != "+" && signCount == 1 && string[0] != "-" { answer = false }
            if signCount == 1 && pointCount == 1 && string[1] == "." /*|| signCount == 1 && pointCount == 1 && string[1] == ","*/ { answer = false }
        }
        if answer {
            if let a = Float(string) { print("NUMBER:", a) }
            else {
                alert(alertTitle: "BUG", alertMessage: "THERE IS THE BUG IN MY CODE", alertActionTitle: "FIX")
                print("NOT A NUMBER:", string, "THERE IS THE BUG")
                answer = false
            }
        } else { print("NOT A NUMBER:", string, "Without Float(string)") }
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
