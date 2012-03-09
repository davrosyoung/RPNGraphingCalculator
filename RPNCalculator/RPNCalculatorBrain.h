//
//  RPNCalculatorBrain.h
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPNCalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
