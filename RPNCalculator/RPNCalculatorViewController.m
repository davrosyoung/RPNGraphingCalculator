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

//--------------------------------------------------
- (RPNCalculatorBrain *)brain {
    if (! _brain) _brain = [[RPNCalculatorBrain alloc] init];
    return _brain;
}

//--------------------------------------------------
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    //NSLog(@"digit pressed = %@", digit);
    
    if (self.userIsInTheMiddleOfEnteringANumber) {

        //check for a valid floating point number
        if ([digit isEqualToString:@"."]) {
            NSNumberFormatter *NF = [[NSNumberFormatter alloc] init];
            [NF setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *testNumber = [NF numberFromString:[self.display.text stringByAppendingString:digit]];
            
            if (![testNumber floatValue]) {
                digit = @"";
            }
        }

        self.display.text = [self.display.text stringByAppendingString:digit];

    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = TRUE;
    }
}

//--------------------------------------------------
- (IBAction)operationPressed:(UIButton *)sender {

    NSString *operationString = sender.currentTitle;
    BOOL skipPerformOperation = FALSE;
    

    if ([operationString isEqualToString:@"1/x"]) {
        NSLog(@"1/x pressed");
        if ([self.display.text doubleValue]) {
            NSLog(@"not zero");
            self.display.text = [NSString stringWithFormat:@"%g", (1 / [self.display.text doubleValue])];
            skipPerformOperation = TRUE;
        }
    } else if ([operationString isEqualToString:@"+/-"]) {
        NSLog(@"+/- pressed");
        if ([self.display.text doubleValue] > 0) {
            self.display.text = [NSString stringWithFormat:@"%g", (-1 * [self.display.text doubleValue])];
        } else {
            self.display.text = [NSString stringWithFormat:@"%g", (ABS([self.display.text doubleValue]))];
        }   
        skipPerformOperation = TRUE;
    } else   if ([operationString isEqualToString:@"sin"]) {
        NSLog(@"sin pressed");
        if ([self.display.text doubleValue]) {
            //NSLog(@"not zero");
            self.display.text = [NSString stringWithFormat:@"%g", (sin([self.display.text doubleValue]*M_PI/180))];
            skipPerformOperation = TRUE;
        }
    } else   if ([operationString isEqualToString:@"cos"]) {
        NSLog(@"sin pressed");
        if ([self.display.text doubleValue]) {
            //NSLog(@"not zero");
            self.display.text = [NSString stringWithFormat:@"%g", (cos([self.display.text doubleValue]*M_PI/180))];
            skipPerformOperation = TRUE;
        }
    } else if ( [operationString isEqualToString:@"√"] ) {
        NSLog( @"sqrt pressed");
    } 


    
    
    
    if (!skipPerformOperation) {
        if (self.userIsInTheMiddleOfEnteringANumber){
            NSLog(@"opertion pressed - entering number");
            [self enterPressed];
        }
        double result = [self.brain performOperation:operationString];
        NSString *resultString = [NSString stringWithFormat:@"%g", result];
        self.display.text = resultString;
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    NSLog( @"Variable button %@ pressed", sender.titleLabel.text );
}

//--------------------------------------------------
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = FALSE;
}


@end
