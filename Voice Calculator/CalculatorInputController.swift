//
//  CalculatorInputController.swift
//  Calculator
//
//  Created by Vikram Ezhil on 27/07/16.
//  Copyright © 2016 Code Dragon. All rights reserved.
//

import UIKit
import AudioToolbox

protocol InputDataDelegate: class
{
    /// Sends out an update with the expression result which needs be displayed
    ///
    /// :params: inputExpressionResult The expression result in String format
    func inputExpressionResult(inputExpressionResult result: String);
    
    /// Sends out an update with the result which needs to be displayed
    ///
    /// :params: inputResult The result in String format
    func inputResult(inputResult result: String);
}

class CalculatorInputController: UIViewController, OperationDelegate
{
    weak var inputDelegate: InputDataDelegate?
    
    // Initializing the calculater function struct model
    var calculatorFunction: CalculatorFunction = CalculatorFunction(expressionVal: "0", resultVal: "0", clearResultVal: true)
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var percentageButton: UIButton!
    @IBOutlet weak var productButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var sumButton: UIButton!
    @IBOutlet weak var differenceButton: UIButton!
    
    @IBOutlet weak var number0Button: UIButton!
    @IBOutlet weak var number1Button: UIButton!
    @IBOutlet weak var number2Button: UIButton!
    @IBOutlet weak var number3Button: UIButton!
    @IBOutlet weak var number4Button: UIButton!
    @IBOutlet weak var number5Button: UIButton!
    @IBOutlet weak var number6Button: UIButton!
    @IBOutlet weak var number7Button: UIButton!
    @IBOutlet weak var number8Button: UIButton!
    @IBOutlet weak var number9Button: UIButton!
    
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBAction func onButtonClick(sender: UIButton)
    {
        // Playing a the system sound when a button is tapped
        AudioServicesPlaySystemSound(1104);
        
        switch(sender)
        {
            case clearButton:
                
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.clear;
            
                break;
            
            case micButton:
            
            
                return;
            
            case deleteButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.delete;
            
                break;
            
            case percentageButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.percentage;
            
                break;
            
            case productButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.product;
                
                break;
            
            case divideButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.division;
            
                break;
        
            case sumButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.sum;
                
                break;
            
            case differenceButton:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = calculatorFunction.difference;
                
                break;
            
            case decimalButton:
            
               // Adding the action to the expression operation
               calculatorFunction.expressionOp = calculatorFunction.decimal;
               
               break;
        
            case number0Button, number1Button, number2Button, number3Button, number4Button, number5Button, number6Button, number7Button, number8Button, number9Button:
            
                // Adding the action to the expression operation
                calculatorFunction.expressionOp = String(sender.tag);
            
                break;
        
            default:
            
                print("Clicked NA");
                
                return;
        }
        
        // Sending an update with the expression result
        inputDelegate?.inputExpressionResult(inputExpressionResult: calculatorFunction.replaceProductAndDivisionSigns(expressionVal: calculatorFunction.expressionOp));
        
        // Calculating the result
        calculatorFunction.resultOp = calculatorFunction.calculateResult(expressionVal: calculatorFunction.expressionOp);
    
        // Sending an update with the result
        inputDelegate?.inputResult(inputResult: calculatorFunction.resultOp);
    }
    
    // Parent Controller Delegates
    
    func resultIsDisplayed()
    {
        print("Result displayed on Screen");
    }
}
