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
@property (nonatomic, readonly, strong) NSDictionary *presetA;
@property (nonatomic, readonly, strong) NSDictionary *presetB;
@property (nonatomic, readonly, strong) NSDictionary *presetC;
@property (nonatomic, strong) NSDictionary *variableMap;
@end



@implementation RPNCalculatorViewController

@synthesize display = _display;
@synthesize variableDisplay = _variableDisplay;
@synthesize programDisplay = _programDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTHeMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize presetA = _presetA;
@synthesize presetB = _presetB;
@synthesize presetC = _presetC;
@synthesize variableMap = _variableMap;



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
 
- (NSDictionary *)presetA
{
    if ( _presetA == nil )
    {
        NSArray *names = [[NSArray alloc]initWithObjects:@"a", @"b", @"x", @"y", nil];
        NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:-1.0 ], [[NSNumber alloc]initWithDouble:0.0], [[NSNumber alloc]initWithDouble:M_PI], [[NSNumber alloc]initWithDouble:M_PI_4], nil];
        _presetA = [[NSDictionary alloc]initWithObjects:values forKeys:names];
    }
    
    return _presetA;
}


- (NSDictionary *)presetB
{
    if ( _presetB == nil )
    {
        NSArray *names = [[NSArray alloc]initWithObjects:@"alpha", @"beta", @"x", @"y", nil];
        NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:0.000001 ], [[NSNumber alloc]initWithDouble:0.001], [[NSNumber alloc]initWithDouble:5.42], [[NSNumber alloc]initWithDouble:428243983.6335], nil];
        _presetB = [[NSDictionary alloc]initWithObjects:values forKeys:names];
    }
    
    return _presetB;
}


- (NSDictionary *)presetC
{
    if ( _presetC == nil )
    {
        NSArray *names = [[NSArray alloc]initWithObjects: @"theta", @"x", @"y", nil];
        NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:M_PI_2], [[NSNumber alloc]initWithDouble:4.0], [[NSNumber alloc]initWithDouble:6.0], nil];
        _presetC = [[NSDictionary alloc]initWithObjects:values forKeys:names];
    }
    
    return _presetC;
}



//--------------------------------------------------
- (RPNCalculatorBrain *)brain {
    if (! _brain) _brain = [[RPNCalculatorBrain alloc] init];
    return _brain;
}

//--------------------------------------------------
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    NSLog(@"digit pressed = %@", digit);
    
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

- (IBAction)reverseSign:(UIButton *)sender
{
    NSString *text = self.display.text;
    
    NSLog( @"reverseSign(): invoked, display.text=\"%@\", length=%d", text, text.length );
    
    if ( text.length > 0 )
    {
        char firstKhar = [ text characterAtIndex:0 ];
        if ( firstKhar == '-' )
        {
            self.display.text = [text substringFromIndex:1];
        } else {
            self.display.text = [@"-" stringByAppendingString:text];
        }
        
    } else {
        NSLog( @"reverseSign(): About to add minus sign to empty display" );
        self.display.text = @"-";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

//--------------------------------------------------
- (IBAction)operationPressed:(UIButton *)sender {

    NSString *operationString = sender.currentTitle;
    BOOL skipPerformOperation = FALSE;
    
    NSLog( @"operationPressed() invoked, operationString=\"%@\", userIsInTheMiddleOfEnteringANumber=%s", operationString, ( self.userIsInTheMiddleOfEnteringANumber ? "YES" : "NO" ) );
          
    
    if (!skipPerformOperation)
    {
        if ( self.userIsInTheMiddleOfEnteringANumber ){
            NSLog(@"operation pressed - entering number");
            [self enterPressed];
        }
        [self.brain push:operationString];
        [self updateProgramDisplay];
        [self updateDisplay];
    }
}

- (IBAction)variablePressed:(UIButton *)sender
{
    NSString *variableName = sender.titleLabel.text;
    NSLog( @"Variable button %@ pressed", variableName );
    [self.brain push:variableName];
    self.programDisplay.text = [RPNCalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (IBAction)presetPressed:(UIButton *)sender
{
    NSString *presetName = sender.titleLabel.text;
    
    NSLog( @"presetPressed ... presetName='%@'", presetName );
    
    if ( [ presetName isEqualToString:@"void" ] )
    {
        self.variableMap = nil;
    }
    
    if ( [ presetName isEqualToString:@"preset a" ] )
    {
        self.variableMap = self.presetA;
    }
    
    if ( [ presetName isEqualToString:@"preset b" ] )
    {
        self.variableMap = self.presetB;
    }
    
    if ( [ presetName isEqualToString:@"preset c" ] )
    {
        self.variableMap = self.presetC;
    }
    
    NSString *variableText = @"";
    NSEnumerator *variableNames = [self.variableMap keyEnumerator];
    NSString *variableName;
    BOOL firstVariable = YES;
    while( variableName = [variableNames nextObject] )
    {
        if ( ! firstVariable )
        {
            variableText = [variableText stringByAppendingString:@", " ];
        }
        variableText = [variableText stringByAppendingString:variableName];
        variableText = [variableText stringByAppendingString:@"="];
        NSNumber *value = [self.variableMap objectForKey:variableName];
        variableText = [variableText stringByAppendingString:[value stringValue]];                        
        firstVariable = NO;
    }

    self.variableDisplay.text = variableText;
    
    [self updateDisplay];
}

//--------------------------------------------------
- (IBAction)enterPressed
{
    NSLog( @"enterPressed(): invoked with userIsInTheMiddleOfEnteringANumber=%s", ( self.userIsInTheMiddleOfEnteringANumber ? "YES" : "NO" ) );
    if (self.userIsInTheMiddleOfEnteringANumber )
    {
        NSNumber *value = [ [NSNumber alloc]initWithDouble:[self.display.text doubleValue ] ];
        [self.brain push:value];
    }
    self.userIsInTheMiddleOfEnteringANumber = FALSE;
    [self updateProgramDisplay];
}

- (IBAction)undoPressed:(UIButton *)sender
{
    BOOL runProgram = NO;
    
    if ( self.userIsInTheMiddleOfEnteringANumber )
    {
        // do we still have digits to remove??
        // ------------------------------------
        if ( self.display.text.length > 0 )
        {
            NSString *currentText = self.display.text;
            int length = currentText.length;
            NSLog( @"currentText.length=%d",length );
            self.display.text = [currentText substringToIndex:length - 1];
            if ( self.display.text.length == 0 )
            {
                runProgram = YES;
                self.userIsInTheMiddleOfEnteringANumber = NO;
            }
        } else {
            // no?? then we are no longer in the middle of entering a number!!
            NSLog( @"undoPressed(): not too sure what to do now!!" );
            runProgram = ( [self.brain pop] != nil );
        }
    } else {
        runProgram = YES;
        // remove item from the program stack...
        NSLog( @"undoPressed(): and how about now!?!?" );
        runProgram = ( [self.brain pop] != nil );
    }
    
    NSLog( @"undoPressed(): runProgram=%s", runProgram ? "YES" : "NO" );
    
    if ( runProgram )
    {
        // run the program!!
        self.programDisplay.text = [RPNCalculatorBrain descriptionOfProgram:[self.brain program]];

        [self updateDisplay];
    }
    
    NSLog( @"undoPressed(): now stack=%@", self.brain.program );
}

- (void)updateDisplay
{
    double result = [RPNCalculatorBrain runProgram:[self.brain program] usingVariableValues:self.variableMap];
    NSLog( @"updateDisplay(): about to update display with result=%g, variableMap=%@", result, self.variableMap );
    self.display.text = [NSString stringWithFormat:@"%g",result ];    
}

- (void)updateProgramDisplay
{
    NSLog( @"updateProgramDisplay(): method invoked." );
    self.programDisplay.text = [RPNCalculatorBrain descriptionOfProgram:[self.brain program]];    
}


@end
