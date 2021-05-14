//  CalculatorBrain.swift
//  Created by Doe on 2/2/18.
//  Copyright © 2018 Doe. All rights reserved.

import Foundation

struct CalculatorBrain {
	//    MARK:  - Properties
	private var accumulator : Double?
	
	var result: Double? {
		get {
			return accumulator
		}
	}
	
	private struct PendingBinaryOperation {
		let function: (Double, Double) -> Double
		let firstOperand: Double
		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	
	private var pendingBinaryOperation: PendingBinaryOperation?
	
	private enum Operation {
		case constant(Double)
		case unary((Double) -> Double)
		case binary((Double,Double) -> Double)
		case equals
	}
	
	private var operations: Dictionary<String,Operation> = [
		//        "π" : Operation.constant(Double.pi),
		//        "e" : Operation.constant(M_E),
		//        "cos" : Operation.unary(cos),
		//        "±" : Operation.unary({ -$0 }),
		"√" : .unary(sqrt),
		"×" : .binary({ $0 * $1 }),
		"÷" : .binary({ $0 / $1 }),
		"+" : .binary({ $0 + $1 }),
		"−" : .binary({ $0 - $1 }),
		"%" : .binary( { ($0 * $1) / 100 }),
		"=" : .equals
	]
	
	// MARK:  - Function
	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
				case .constant(let value):
					accumulator = value
				case .unary(let f):
					if accumulator != nil {
						accumulator = f(accumulator!)
					}
				case .binary(let f):
					if accumulator != nil {
						pendingBinaryOperation = PendingBinaryOperation(function: f, firstOperand: accumulator!)
						accumulator = nil
					}
				case .equals:
					performPendingBinaryOperation()
			}
		}
	}
	
	mutating func performPendingBinaryOperation() {
		if pendingBinaryOperation != nil && accumulator != nil {
			accumulator = pendingBinaryOperation!.perform(with: accumulator!)
			pendingBinaryOperation = nil
		}
	}
	
	mutating func setOperand(_ operand: Double) {
		accumulator = operand
	}
	
}
