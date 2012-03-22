//
//  RPNCalculatorBrain.m
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "RPNCalculatorBrain.h"

//========================= INTERFACE ========================= 
@interface RPNCalculatorBrain()

@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSDictionary *variables;
@property (nonatomic, strong) NSDictionary *operations;

@end

//========================= IMPLEMENTATION =========================
@implementation RPNCalculatorBrain
@synthesize programStack = _programStack;
@synthesize variables = _variables;
@synthesize operations = _operations;

- (NSDictionary *)operations
{        
    if ( _operations == nil )
    {
        _operations = [[NSDictionary init]alloc];
        NSMutableDictionary mutie = _operations.mutableCopy;
        
    }
    
    return _operations;
}


//-------------------------------------------------
- (NSMutableArray *)programStack {
    
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init ];
    }
    return _programStack;
}

//-------------------------------------------------
- (id)program {

    return [self.programStack copy];
}

//-------------------------------------------------
- (void)pushOperand:(double)operand {
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariableOperand:(NSString *)variable
{
    [self.programStack addObject:variable];
}

//-------------------------------------------------
- (double)popOperand {
    
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue];
}

//-------------------------------------------------
- (double)performOperation:(NSString *)operation {
    
    [self.programStack addObject:operation];
    return [RPNCalculatorBrain runProgram:self.program];
}

//-------------------------------------------------
+ (NSString *)descriptionOfProgram:(id)program {
    
    return @"Reverse Polish Notation Calculator";
}

//-------------------------------------------------
+ (double)popOperandOffStack:(NSMutableArray *)stack {
 
    double result = 0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        }
    }
    return result;
}

//-------------------------------------------------
+ (double)runProgram:(id)program {
    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

@end
