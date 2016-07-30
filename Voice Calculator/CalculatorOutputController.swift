//
//  CalculatorOutputController.swift
//  Calculator
//
//  Created by Vikram Ezhil on 27/07/16.
//  Copyright © 2016 Code Dragon. All rights reserved.
//

import UIKit

protocol OutputDataDelegate: class
{
    /// Sends out an update that output data is set
    func outputDataIsSet();
}

class CalculatorOutputController: UIViewController, DisplayDelegate
{
    weak var outputDataDelegate: OutputDataDelegate?
    
    @IBOutlet weak var calculatorResultOperation: UILabel!
    
    @IBOutlet weak var calculatorResult: UILabel!
    
    // Parent Controller Delegates
    
    func displayExpressionResult(resultExpressionToBeDisplayed result: String)
    {
        // Setting the expression result value in the display
        calculatorResultOperation.text = result;
    }
    
    func displayResult(resultToBeDisplayed result: String)
    {
        // Setting the calculated result value in the display
        calculatorResult.text = result;
        
        // Letting the parent class know that output data is set
        outputDataDelegate?.outputDataIsSet();
    }
}