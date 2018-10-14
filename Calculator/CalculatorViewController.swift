//
//  ViewController.swift
//  Calculator
//
//  Created by Doe on 1/30/18.
//  Copyright © 2018 Doe. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet var keypad: [CustomKeypadButton]!
    //    MARK:  - Properties
    var userIsTyping = false
    
    @IBOutlet weak var calculatorDisplay: UILabel!
    
    private var brain = CalculatorBrain()
    
    var historyOperations : String = ""
    
    var displayValue: Double {
        get {
            return Double(calculatorDisplay.text!)!
        }
        set {
            calculatorDisplay.text = String(newValue.clean)
        }
    }
    
    // MARK:  - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistory" , segue.destination is HistoryViewController {
            let vc = segue.destination as? HistoryViewController
            vc?.passedHistory = historyOperations
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for key in keypad {
            key.corner = 30
        }
    }
    
    @IBAction func unwindBackToFirstVC(unwindSegue : UIStoryboardSegue) {    }
    
    @IBAction func digit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            let textCurrentlyInDisplay = calculatorDisplay.text!
            calculatorDisplay.text = textCurrentlyInDisplay + digit
        }  else  {
            calculatorDisplay.text = digit
            userIsTyping = true
        }
    }
    
    @IBAction func customPressAnimation(_ sender: CustomKeypadButton) {
        let bg = sender.backgroundColor
        CustomKeypadButton.animate(withDuration: 0.1, animations: {
            sender.layer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 1, alpha: 0)
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (_) in
            CustomKeypadButton.animate(withDuration: 0.05, animations: {
                sender.transform = CGAffineTransform.identity
                sender.backgroundColor = bg
            })
        }
        
        
    }
    @IBAction func clearAll(_ sender: UIButton) {
        brain = CalculatorBrain()
        userIsTyping = false
        calculatorDisplay.text = "All Cleared"
        historyOperations = ""
    }
    
    @IBAction func operation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            historyOperations.append(displayValue.clean)
            calculatorDisplay.text?.append((sender.titleLabel?.text)!)
            brain.performPendingBinaryOperation()
            userIsTyping = false
            historyOperations.append(sender.currentTitle!)
        }
        
        // perform the operation
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        // update the display if I can
        if let result = brain.result {
            displayValue = Double(result.clean)!
            brain.setOperand(result)
            historyOperations.append(String(result.clean))
            historyOperations.append("\n")
        }
    }
}

class CustomKeypadButton : UIButton {
  var corner : CGFloat = 0 {        didSet {            self.layer.cornerRadius = self.frame.width / 4      }    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: - Removing zeros from the end of doubles
extension Double {
    var clean: String {
        return self .truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
