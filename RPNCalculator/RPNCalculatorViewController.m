//
//  RPNCalculatorViewController.m
//  RPNCalculator
//
//  Created by David Thornton on 27/02/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorBrain.h"

@interface RPNCalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) RPNCalculatorBrain *brain;
@end



@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTHeMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (RPNCalculatorBrain *)brain {
    if (! _brain) _brain = [[RPNCalculatorBrain alloc] init];
    return _brain;
}
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    //NSLog(@"digit pressed = %@", digit);

    if (self.userIsInTheMiddleOfEnteringANumber) {

        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = TRUE;
    }
}
- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = FALSE;
}


@end
