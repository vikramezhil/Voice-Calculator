//
//  ViewController.swift
//  Calculator
//
//  Created by Vikram Ezhil on 25/07/16.
//  Copyright © 2016 Code Dragon. All rights reserved.
//

import UIKit

protocol DisplayDelegate: class
{
    /// Sends out an update with the result operation
    ///
    /// :params: resultExpressionToBeDisplayed The expression result to be displayed in String format
    func displayExpressionResult(resultExpressionToBeDisplayed result: String);
    
    /// Sends out an update with the result
    ///
    /// :params: resultToBeDisplayed The calculated result to be displayed in String format
    func displayResult(resultToBeDisplayed result: String);
}

protocol OperationDelegate: class
{
    /// Sends out an update that result is displayed
    func resultIsDisplayed();
}

class ViewController: UIViewController, InputDataDelegate, OutputDataDelegate
{
    private var calculatorOutputController: CalculatorOutputController!;
    private var calculatorInputController: CalculatorInputController!;
    
    weak var displayDelegate = DisplayDelegate?()
    weak var operationDelegate = OperationDelegate?()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "calculatorOutput"
        {
            if let vc = segue.destinationViewController as? CalculatorOutputController
            {
                // print("Inside segue - output controller");
                
                // Initializing the output controller class
                self.calculatorOutputController = vc;
                
                // Assinging the output controller delegate to the parent
                self.calculatorOutputController.outputDataDelegate = self;
                
                // Assigning the parent delegate to the output controller
                self.displayDelegate = self.calculatorOutputController;
            }
        }
    
        if segue.identifier == "calculatorInput"
        {
            if let vc = segue.destinationViewController as? CalculatorInputController
            {
                // print("Inside segue - input controller");
                
                // Initializing the input controller class
                self.calculatorInputController = vc;
                
                // Assigning the input controller delegate to the parent
                self.calculatorInputController.inputDelegate = self;
                
                // Assinging the parent delegate to the input controller
                self.operationDelegate = self.calculatorInputController;
            }
        }
    }
    
    // Output Controller Delegates
    
    func outputDataIsSet()
    {
        // Sending an update to the input controller that result is displayed
        operationDelegate?.resultIsDisplayed();
    }
    
    // Input Controller Delegates
    
    func inputExpressionResult(inputExpressionResult result: String)
    {
        // Sending the expression result to the output controller
        displayDelegate?.displayExpressionResult(resultExpressionToBeDisplayed: result);
    }
    
    func inputResult(inputResult result: String)
    {
        // Sending the calculated result to the output controller
        displayDelegate?.displayResult(resultToBeDisplayed: result);
    }
}


