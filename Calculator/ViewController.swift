//
//  ViewController.swift
//  Calculator
//
//  Created by Павло Тимощук on 11.02.2020.
//  Copyright © 2020 Павло Тимощук. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var numberButtonArr: [UIButton]!
//    var numberButtonArr: Array<UIButton> = []
    
    func buttonWasPressed() {
        print("You pressed the button")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for num in 0 ... 9 {
            
            var height = 60
            var width = 60
            var x = 0
            var y = 0
            
            if num < 1 { width = 145; y = 540; x = 30 }
            else if num < 4 { y = 455 }
            else if num < 7 { y = 370 }
            else { y = 285 }
            
            if num%3 == 1 { x = 30 }
            else if num%3 == 2 { x = 115 }
            else { if num != 0 { x = 200 } }
            
            
            let numberButton = UIButton()
            numberButton.frame = CGRect(x: x, y: y, width: width, height: height)
            numberButton.setTitle(String(num), for: .normal)
            numberButton.setTitleColor(.systemBlue, for: .normal)
            
            numberButton.backgroundColor = UIColor(rgb: 0x494C4D)
            numberButton.setBackgroundColor(UIColor(rgb: 0x656565), for: .highlighted)
            
            numberButton.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin]
            numberButton.translatesAutoresizingMaskIntoConstraints = true
            numberButton.tag = num
            
            numberButton.addTarget(self, action: #selector(numberInsert), for: .touchUpInside)
            

            numberButtonArr?.append(numberButton)
            self.view.addSubview(numberButton)
            
        }
        
    

    
    }
    
    @objc func numberInsert(sender: UIButton){
        print(sender.tag)
    }

}





//MARK: RGB to UIColor
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
