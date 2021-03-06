//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Atwood Wang on 15/6/16.
//  Copyright (c) 2015年 Atwood Wang. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String,Double ->Double)
        case BinaryOperation(String,(Double,Double) ->Double)
        case Constant(String,Double)
        
        var description:String {
            get{
                switch  self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                }
            }
            
        }
    }
    
    func cleanall (){
        opStack.removeAll()
    }
    

    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    func pushOperand(operand:Double) ->Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    init(){                                                                     
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["÷"] = Op.BinaryOperation("×", {$1/$0})
        knownOps["+"] = Op.BinaryOperation("×", +)
        knownOps["−"] = Op.BinaryOperation("×", {$1-$0})
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        knownOps["sin"] = Op.UnaryOperation("sin", {sin(M_PI/180*$0)})
        knownOps["cos"] = Op.UnaryOperation("cos", {cos(M_PI/180*$0)})
        knownOps["π"]=Op.Constant("π",M_PI)
        knownOps["+/-"]=Op.UnaryOperation("+/-", -)
        knownOps["%"]=Op.UnaryOperation("%", {$0/100})
    }
    
    private func evaluate(ops:[Op]) ->(result: Double?,remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps=ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                 return(operand,remainingOps)
                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand),operandEvaluation.remainingOps)
                }
                
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1=op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return (operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_,let operand):
                return (operand,remainingOps)
            }
        }
        return (nil,ops)
    }
    
    func evaluate() ->Double? {
        let (result,remainder)=evaluate(opStack)
        println("\(opStack)=\(result) with \(remainder) left over")
        return result
    }
    
    
    func performOperation(symbol:String) ->Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}

