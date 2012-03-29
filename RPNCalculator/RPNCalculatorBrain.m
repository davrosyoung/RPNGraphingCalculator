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

@end

//========================= IMPLEMENTATION =========================
@implementation RPNCalculatorBrain
@synthesize programStack = _programStack;

static NSSet *_singleOperandOperations = nil;
static NSSet *_doubleOperandOperations = nil;
static NSSet *_noOperandOperations = nil;
static NSSet *_allOperations = nil;
static NSArray *_operatorsInOrder = nil;

- (id)init
{
    return [super init];
}

+ (NSSet *)singleOperandOperations
{
    if ( _singleOperandOperations == nil )
    {
        _singleOperandOperations = [NSSet setWithObjects:@"sin", @"cos",@"sqrt",nil];
    }
    
    return _singleOperandOperations;
}

+ (NSSet *)doubleOperandOperations
{
    if ( _doubleOperandOperations == nil )
    {
        _doubleOperandOperations = [NSSet setWithObjects:@"+", @"-", @"/", @"*", nil];
    }
    
    return _doubleOperandOperations;
}
                                    
+ (NSSet *)noOperandOperations
{
    if ( _noOperandOperations == nil )
    {
        _noOperandOperations = [NSSet setWithObjects:@"pi", nil];
    }
                                    
    return _noOperandOperations;
}

+ (NSSet *)allOperations
{
    if ( _allOperations == nil )
    {
        _allOperations = [NSSet setWithSet:self.singleOperandOperations ];
        _allOperations = [_allOperations setByAddingObjectsFromSet:self.doubleOperandOperations];
        _allOperations = [_allOperations setByAddingObjectsFromSet:self.noOperandOperations];
    }
    
    return _allOperations;
}

+ (NSArray *)operatorsInOrder
{
    if ( _operatorsInOrder == nil )
    {
        _operatorsInOrder = [NSArray arrayWithObjects: @"sin", @"cos", @"sqrt", @"-", @"+", @"/", @"*", nil];
    }
    
    return _operatorsInOrder;
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
- (void)push:(id)operand
{    
    if ( [operand isKindOfClass:[NSNumber class]] )
    {
        NSLog( @"RPNCalculatorBrain::push(): Placing numeric value %lf onto stack", [(NSNumber *)operand doubleValue]);
        [self.programStack addObject:operand];
    } else if ( [operand isKindOfClass:[NSString class]] ) {
        NSString *text = (NSString *)operand;
        NSLog( @"RPNCalculatorBrain::push(): Attempting to place string \"%@\" onto stack", text );
        // check that the operand is not an existing operation!!
        if ( ! [ _allOperations containsObject:operand ] )
        {
            [self.programStack addObject:operand];
        } else {
            NSLog( @"RPNCalculatorBrain::adding operation \"%@\"", text );
            [self.programStack addObject:text];
        }
    }
    
    NSLog( @"RPNCalcultorBrain::pushOperand(): now stack is %@", self.programStack );
}

/*
- (double)performOperation:(NSString *)operation
{
    return [self performOperation:operation withVariableValues:nil];
}


- (double)performOperation:(NSString *)operation withVariableValues:(NSDictionary *)variableValues
{
    double result = 0.0;
    NSLog( @"RPNCalculatorBrain::performOperation(): invoked with operation=%@", operation );
    [self.programStack addObject:operation];
    NSLog( @"RPNCalculatorBrain::performOperation(): added operation onto programStack" );
    result = [RPNCalculatorBrain runProgram:self.program usingVariableValues:variableValues];
    return result;
}
*/

- (id)pop
{
    id result = nil;
    
    // only remove an object from the stack, if there actually is one...
    if ( ( result = [ self.programStack lastObject ] ) )
    {
        [self.programStack removeLastObject];
    }
    
    return result;
}

//-------------------------------------------------
+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *result = @"undefined";
    if ( [ program isKindOfClass:[NSArray class]] )
    {
        NSMutableArray *copy = [program mutableCopy];
        result = [ RPNCalculatorBrain describeOperandOffStack:copy parentPrecedence:-1];
    }
    
    return result;
}

+ (NSString *)describeOperandOffStack:(NSMutableArray *)stack parentPrecedence:(int)parentPrecedence
{
    NSString *result = nil;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // if the top of stack is a regular old number, then just retrieve it and we're finished...
    // ---------------------------------------------------------------------------------------
    if ( [topOfStack isKindOfClass:[NSNumber class]] )
    {
        NSNumber *number = (NSNumber *)topOfStack;
        result = [number stringValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        // is it a variable or an operation??
        // -----------------------------------
        if ( ! [ [RPNCalculatorBrain allOperations] containsObject:topOfStack ] )
        {
            // variable
            // -----------
            result = topOfStack;

        } else {
            // it's an operation....
            // ------------------------
            NSString *operation = topOfStack;
            
            int precedence = ( [[RPNCalculatorBrain operatorsInOrder]containsObject:operation]) ? [[RPNCalculatorBrain operatorsInOrder] indexOfObject:operation] : 0;
            
            if ( [ [RPNCalculatorBrain noOperandOperations] containsObject:operation ] ) result = operation;
            
            if ( [ [RPNCalculatorBrain singleOperandOperations] containsObject:operation ] )
            {
                result = [[operation stringByAppendingString:@"(" ] stringByAppendingString:[RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] ];
                result = [result stringByAppendingString:@")" ];
            }
            
            if ( [ [RPNCalculatorBrain doubleOperandOperations] containsObject:operation ] )
            {
                NSString *rightOperandText = ( [ stack count ] > 1 ) ? [RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] : nil;
                NSString *leftOperandText = ( [ stack count ] > 0 ) ? [RPNCalculatorBrain describeOperandOffStack:stack parentPrecedence:precedence] : nil;
                result = ( parentPrecedence > precedence ) ? @"(" : @"";
                result = [result stringByAppendingString:( leftOperandText ? leftOperandText : @"0" )];
                result = [result stringByAppendingString:operation];
                result = [result stringByAppendingString:( rightOperandText ? rightOperandText : @"0" ) ];
                if ( parentPrecedence > precedence ) result = [result stringByAppendingString:@")"];                
            }
        }
    }
    
    return result;
}



//-------------------------------------------------
+ (double)popOperandOffStack:(NSMutableArray *)stack
{
 
    return [RPNCalculatorBrain popOperandOffStack:stack usingVariableValues:nil];
}

+ (double)radians:(double)degrees
{
    double result = ( degrees / 180.0 ) * M_1_PI;
    return result;
}




+ (double)popOperandOffStack:(NSMutableArray *)stack usingVariableValues:(NSDictionary *)variableValues
{
    double result = 0.0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    // if the top of stack is a regular old number, then just retrieve it and we're finished...
    // ---------------------------------------------------------------------------------------
    if ( [topOfStack isKindOfClass:[NSNumber class]] )
    {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        
        NSLog( @"allOperations containsObject:%@=%@", topOfStack, [[RPNCalculatorBrain allOperations] containsObject:topOfStack]?@"YES":@"NO" );
        
        // is it a variable or an operation??
        // -----------------------------------
        if ( ! [ [RPNCalculatorBrain allOperations] containsObject:topOfStack ] )
        {
            NSString *variableName = topOfStack;
            id value = [variableValues objectForKey:variableName ];
            if ( value )
            {
                if ( [ value isKindOfClass:[NSNumber class]] )
                {
                    result = [(NSNumber *)value doubleValue];
                    NSLog( @"Resolved value of %lf for variable \"%@\"", result, variableName );
                }
            } else {
                // default value of an unresolved variable is zero.
                NSLog( @"Using ZERO as value for unresolved variable \"%@\"", variableName );
                result = 0.0;
            }
            
        } else {
            NSString *operation = topOfStack;
            
            if ( [ [RPNCalculatorBrain noOperandOperations] containsObject:operation ] )
            {
                if ( [ operation isEqualToString:@"pi" ] ) {
                    result = M_PI;
                }
                
                if ( [ operation isEqualToString:@"e" ] ) {
                    result = M_E;
                }
            }
            
            if ( [ [RPNCalculatorBrain singleOperandOperations] containsObject:operation ] )
            {
                double a = [ RPNCalculatorBrain popOperandOffStack:stack usingVariableValues:variableValues ];
                if ( [operation isEqualToString:@"sin" ] )
                {
                    result = sin( [RPNCalculatorBrain radians:a] );
                }
                
                if ( [operation isEqualToString:@"cos" ] )
                {
                    result = cos( [RPNCalculatorBrain radians:a] );
                }
                
                if ( [ operation isEqualToString:@"log" ] )
                {
                    result = log( a );
                }
                
                if ( [ operation isEqualToString:@"sqrt" ] )
                {
                    result = sqrt( a );
                }
            }
            
            if ( [ [RPNCalculatorBrain doubleOperandOperations] containsObject:operation ] )
            {
                double b = ([stack count] > 1) ? [RPNCalculatorBrain popOperandOffStack:stack usingVariableValues:variableValues ] : 0;
                double a = ([stack count] > 0 ) ? [RPNCalculatorBrain popOperandOffStack:stack usingVariableValues:variableValues ] : 0;
            
            
                if ([operation isEqualToString:@"+"]) {
                    result = a + b;
                } else if ([operation isEqualToString:@"*"]) {
                    result = a * b;
                } else if ([operation isEqualToString:@"/"]) {
                    if ( b ) result = a / b;
                } else if ([operation isEqualToString:@"-"]) {
                    result = a - b;
                }
            }
        }
    }
    
    return result;
}


//-------------------------------------------------
+ (double)runProgram:(id)program
{
    return [RPNCalculatorBrain runProgram:program usingVariableValues:nil];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    double result = 0.0;
    NSMutableArray *stack;
    if ( [program isKindOfClass:[NSArray class]] )
    {
        stack = [program mutableCopy];
    }
    NSLog( @"RPNCalculatorBrain invoked with stack=%@, variableMap=%@", stack, variableValues );
    result = [RPNCalculatorBrain popOperandOffStack:stack usingVariableValues:variableValues];
    return result;
}

@end
