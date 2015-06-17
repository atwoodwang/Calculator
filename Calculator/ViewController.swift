//
//  ViewController.swift
//  Calculator
//
//  Created by Atwood Wang on 15/6/15.
//  Copyright (c) 2015年 Atwood Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    var isDotTyped=false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        println("digit=\(digit)")
    }
    
    
    @IBAction func appendDot(sender: UIButton) {
        if !isDotTyped {
            if userIsInTheMiddleOfTypingANumber{
                display.text=display.text!+"."
            }else {
                display.text="0."
                userIsInTheMiddleOfTypingANumber=true
            }
            isDotTyped=true
        }
    }
    
    @IBAction func cleanall() {
        brain.cleanall()
        userIsInTheMiddleOfTypingANumber=false
        isDotTyped=false
        display.text="0"
    }
    
    @IBAction func clean() {
        userIsInTheMiddleOfTypingANumber=false
        isDotTyped=false
        display.text="0"
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation=sender.currentTitle {
            if let result=brain.performOperation(operation){
                displayValue=result
            }else{
                displayValue=0
            }
        }
        
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        isDotTyped=false
        
        if let result=brain.pushOperand(displayValue) {
            displayValue=result
        }else{
            displayValue=0
        }
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text="\(newValue)"
            userIsInTheMiddleOfTypingANumber=false
        }
    }
}

