//
//  ViewController.swift
//  Calculator
//
//  Created by Doe on 1/30/18.
//  Copyright © 2018 Doe. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func clearAll(_ sender: UIButton) {
        brain = CalculatorBrain()
        userIsTyping = false
        calculatorDisplay.text = "All Cleared"
        historyOperations = ""
    }
    
    @IBAction func operation(_ sender: UIButton) {
        if userIsTyping{
            brain.setOperand(displayValue)
            historyOperations.append(String(displayValue))
            calculatorDisplay.text?.append((sender.titleLabel?.text)!)
            brain.performPendingBinaryOperation()
            userIsTyping = false
        }
        
        // perform the operation
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            historyOperations.append(mathematicalSymbol)
        }
        
        // update the display if I can
        if let result = brain.result {
            displayValue = result
            brain.setOperand(result)
            historyOperations.append(String(result))
            historyOperations.append("\n")
        }
    }
}

// MARK: - Removing zeros from the end of doubles
extension Double {
    var clean: String {
        return self .truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
