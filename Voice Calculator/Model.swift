//
//  Model.swift
//  Calculator
//
//  Created by Vikram Ezhil on 27/07/16.
//  Copyright © 2016 Code Dragon. All rights reserved.
//

import Foundation

extension Double
{
    var cleanValue: String
    {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct CalculatorFunction
{
    private let operatorSymbols: [String] = ["*", "/", "+", "-", "."]
    
    internal let product: String = "*";
    internal let division: String = "/";
    internal let percentage: String = "%";
    internal let sum: String = "+";
    internal let difference: String = "-";
    internal let decimal: String = ".";
    internal let delete: String = "del";
    internal let clear: String = "clr";
    
    private let percentageConstant: Double = 100.0;
    
    private var expression: String, result: String;
    
    private var clearResult: Bool;

    var expressionOp: String
        {
        get
        {
            return expression;
        }
        
        set
        {
            if let value = followArithmeticOpRules(expressionVal: expression, newExpressionVal: newValue, clearResultVal: clearResult)
            {
                if(clearResult)
                {
                    expression = value;
                }
                else
                {
                    expression += value;
                }
            }
            else if(newValue == clear)
            {
                expression.removeAll();
            }
            else if(newValue == delete)
            {
                expression.removeAtIndex(expression.endIndex.predecessor());
            }
            
            clearResultOp = expression.isEmpty || (expression.characters.count == 1 && expression.containsString("0"));
        }
    }
    
    var resultOp: String
        {
        get
        {
            return result;
        }
        
        set
        {
            result = newValue;
        }
    }
    
    var clearResultOp: Bool
        {
        get
        {
            return clearResult;
        }
        
        set
        {
            clearResult = newValue;
            
            if(clearResult)
            {
                expression = "0";
                result = "0";
            }
        }
    }
    
    /// CalculatorFunction struct Initializer
    ///
    /// :params: expression The default expression value in String format
    ///
    /// :params: result The default result value in String format
    ///
    /// :params: clearResult The default clear result value in Boolean format
    init(expressionVal expression: String, resultVal result: String, clearResultVal clearResult: Bool)
    {
        self.expression = expression;
        self.result = result;
        self.clearResult = clearResult;
    }
    
    /// Calculates the calculator result based on the result operation
    ///
    /// :params: expressionValue The expression value in String format
    ///
    /// :returns: The calculated result in String format
    func calculateResult(expressionVal expression: String) -> String
    {
        var modifiedExpressionVal: String = "", finalExpressionVal: String = "";
        
        var positionsToBeIngored: [Int] = [];
        
        var isTrailingANumber = false, isTrailingADecimal = false;
        
        // Checking if the last character is a symbol and if true saving the positions till there is no symbol trailing
        for (index, element) in expression.characters.enumerate().reverse()
        {
            if(operatorSymbols.contains(String(element)))
            {
                positionsToBeIngored += [index];
            }
            else
            {
                break;
            }
        }
        
        // Appending the updated expression values based on positions and converting int values into decimal values
        for(index, element) in expression.characters.enumerate()
        {
            if(!positionsToBeIngored.contains(index))
            {
                if(Int(String(element)) != nil)
                {
                    isTrailingANumber = true;
                    
                    modifiedExpressionVal += String(element);
                }
                else if(String(element) == decimal)
                {
                    isTrailingADecimal = true;
                    
                    modifiedExpressionVal += String(element);
                }
                else
                {
                    if(isTrailingANumber && !isTrailingADecimal)
                    {
                        modifiedExpressionVal += ".0\(String(element))";
                    }
                    else
                    {
                        modifiedExpressionVal += String(element);
                    }
                    
                    isTrailingANumber = false;
                    isTrailingADecimal = false;
                }
            }
        }
        
        // Adding a decimal value to the last number in the modified expression if applicable
        if(isTrailingANumber && !isTrailingADecimal)
        {
            modifiedExpressionVal += ".0";
        }
        
        // Checking if the modified expression value has percentage
        if(modifiedExpressionVal.containsString(percentage))
        {
            // Calculating the percentage directly before using the expression with NSExpression
            
            var strNumberSeriesLeading = "", strExistingValue = "", strModifiedValue = "";
            
            var percentageFound = false;
            
            for element in modifiedExpressionVal.characters
            {
                if(Int(String(element)) != nil || String(element) == decimal)
                {
                   strNumberSeriesLeading += String(element);
                }
                else if(String(element) == percentage)
                {
                    percentageFound = true;
                }
                else
                {
                    strNumberSeriesLeading.removeAll();
                }
                
                finalExpressionVal += String(element);
                
                if(percentageFound && !strNumberSeriesLeading.isEmpty)
                {
                    strExistingValue = "\(strNumberSeriesLeading)%";
                    
                    if let isANumber = Double(strNumberSeriesLeading)
                    {
                        // Converting the percentage value into a Double
                        strModifiedValue = String(isANumber/percentageConstant);
                        
                        // Replacing the percentage value with the converted Double value
                        finalExpressionVal = finalExpressionVal.stringByReplacingOccurrencesOfString(strExistingValue, withString: strModifiedValue)
                        
                        strNumberSeriesLeading = strModifiedValue;
                    }
                    
                    percentageFound = false;
                }
            }
        }
        else
        {
            finalExpressionVal = modifiedExpressionVal;
        }
        
        print("Original expression value = \(expression)");
        print("Modified expresssion value = \(modifiedExpressionVal)");
        print("Final expresssion value = \(finalExpressionVal)");
        
        if(finalExpressionVal.isEmpty)
        {
            return resultOp;
        }
        else
        {
            // Converting the expression into an NSExpression
            let nsExpressionVal = NSExpression(format: finalExpressionVal);
            
            print("NSExpression = \(nsExpressionVal)");
            
            // Calculate the result using NSExpression and returning it
            if let result = nsExpressionVal.expressionValueWithObject(nil, context: nil) as? Double
            {
                print("Calculated Value = \(result)");
                
                if(String(result).uppercaseString.containsString("E"))
                {
                    return String(result).uppercaseString;
                }
                else
                {
                    return result.cleanValue;
                }
            }
            else
            {
                return resultOp;
            }
        }
    }
    
    /// Replaces the default product "*" and division "/" signs with "x" && "÷"
    ///
    /// :paramas: expressionVal The expression value in String format
    ///
    /// :returns: The updated expression value with the signs changed
    func replaceProductAndDivisionSigns(expressionVal expression: String) -> String
    {
        return expression.stringByReplacingOccurrencesOfString("*", withString: "x").stringByReplacingOccurrencesOfString("/", withString: "÷")
    }
    
    /// Checks if the append to be expression will follow basic arithmetic rules
    ///
    /// This method follows the rules,
    ///
    /// 1. "x" - Should have a number leading & should have either "-" or a number trailing
    /// 2. "/" - Should have a number leading & should have either "-" or a number trailing
    /// 3. "%" - Should have a number leading
    /// 4. "+" - Should have a number leading & should have either "-" or a number trailing
    /// 5. "-" - Can have any one of "/" , "x", "+", "%" or a number as leading & should have a number trailing
    /// 6. "." - Should have a number as leading & should have a number trailing
    /// 7. "numbers" - If the leading value is a percentage, then the leading value should be changed to "*"
    ///
    /// :params: expressionVal The so far appended expression value in String format
    ///
    /// :params: newExpressionVal The new to be appended expression value in String format
    ///
    /// :params: clearResultVal The clear result value in Boolean format
    ///
    /// :returns: The appended expression optional value which follows the method rules in String? format
    func followArithmeticOpRules(expressionVal expression: String, newExpressionVal newExpression: String, clearResultVal clearResult: Bool) -> String?
    {
        switch(newExpression)
        {
            case product, division, sum:
            
                if(clearResult)
                {
                    // If clear result, returning nil
                    
                    return nil;
                }
                else if let leadingVal = expression.characters.last
                {
                    if(Int(String(leadingVal)) != nil)
                    {
                        // If the leading value is an int, then "division" or "product" or "sum" symbol can be added - returning it
                        
                        return newExpression;
                    }
                    else
                    {
                        if(String(leadingVal) == decimal)
                        {
                            // If the leading value is a decimal, appending leading "0" to "division" or "product" or "sum" symbol and returning it
                            
                            return "0\(newExpression)";
                        }
                        else if(String(leadingVal) == percentage)
                        {
                            return newExpression;
                        }
                        else
                        {
                            // For other scenarios returning nil
                            
                            return nil;
                        }
                    }
                }
                
                // If the expression is empty, then "division" or "product" or "sum" symbol cannot be added, returning nil
                
                return nil;
            
            case percentage:
            
                if(clearResult)
                {
                    // If clear result, returning nil
                    
                    return nil;
                }
                else if let leadingVal = expression.characters.last
                {
                    if(Int(String(leadingVal)) != nil || String(leadingVal) == percentage)
                    {
                        return percentage;
                    }
                    else
                    {
                        if(String(leadingVal) == decimal)
                        {
                            // If the leading value is a decimal, appending leading "0" to percentage and returning it
                            
                            return "0\(percentage)";
                        }
                        else
                        {
                            // For other scenarios returning nil
                            
                            return nil;
                        }
                    }
                }
                
                // If the expression is empty, then returning nil
                
                return nil;
            
            case difference:
                
                if let leadingVal = expression.characters.last
                {
                    if(Int(String(leadingVal)) != nil)
                    {
                        // If the leading value is an int, the "difference" symbol can be added - returning it
                        
                        return difference;
                    }
                    else
                    {
                        if(String(leadingVal) == difference)
                        {
                            // If the leading value already has a "difference symbol", then returning nil
                            
                            return nil;
                        }
                        else if(String(leadingVal) == decimal)
                        {
                            // If the leading value has a decimal then appending "0" to the "difference" symbol and then returning it
                            
                            return "0\(difference)";
                        }
                        else
                        {
                            // For other scenarios, returning the "difference" symbol
                            
                            return difference;
                        }
                    }
                }
                
                // If the expression is empty, then returning the "difference" symbol
                
                return difference;
            
            case decimal:
            
                if let leadingVal = expression.characters.last
                {
                    var decimalCount = 1;
                    for element in expression.characters
                    {
                        // Checking if a number series doesn't have the criteria of having more than one decimal
                        
                        if(String(element) == decimal)
                        {
                            decimalCount += 1;
                        }
                        else if(Int(String(element)) == nil)
                        {
                            // If the character is broken by a value other than "Int" resetting the count
                            
                            decimalCount = 1;
                        }
                    }
                    
                    if (decimalCount == 1)
                    {
                        if(Int(String(leadingVal)) != nil)
                        {
                            // If the leading value is an int, the "decimal" symbol can be added - returning it
                            
                            if(clearResult)
                            {
                                return "0\(decimal)";
                            }
                            else
                            {
                                return decimal;
                            }
                        }
                        else
                        {
                            if(String(leadingVal) == percentage)
                            {
                                // If the leading value is a percentage, appending "*0" to the "decimal" symbol and returning it
                                
                                return "*0\(decimal)";
                            }
                            else
                            {
                                // For other scenarios, appending "0" to the "decimal" symbol and returning it
                                
                                return "0\(decimal)";
                            }
                        }
                    }
                    else
                    {
                        // If a number series was requested to have more than 1 "decimal", rejecting it and returning nil
                        
                        return nil;
                    }
                }
                
                // If the expression is empty, then appending "0" to the "decimal" symbol and returning it
                
                return "0\(decimal)";
            
            default:
            
                // Applicable for numbers
                
                if(Int(newExpression) != nil)
                {
                    if let leadingVal = expression.characters.last
                    {
                        if(String(leadingVal) == percentage)
                        {
                            // If the leading value is a "percentage" appending "*" to the number and returning it
                            
                            return "*\(newExpression)";
                        }
                        else
                        {
                            return newExpression;
                        }
                    }
                    else
                    {
                        // For other scenarios, returning the number
                        
                        return newExpression;
                    }
                }

                return nil;
        }
    }
}