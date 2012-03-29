//
//  CalculatorBrainTest.m
//  RPNCalculator
//
//  Created by David Young on 26/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "CalculatorBrainTest.h"
#import "RPNCalculatorBrain.h"

@implementation CalculatorBrainTest

NSDictionary *mockVariables;
RPNCalculatorBrain *brain;
NSArray *whyTimesTwo;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    
    NSArray *names = [[NSArray alloc]initWithObjects:@"x",@"y",@"alpha","@beta", nil];
    NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:23.0],[[NSNumber alloc]initWithDouble:42.0],[[NSNumber alloc]initWithDouble:-1.0],[[NSNumber alloc]initWithDouble:0.0],nil];
    mockVariables = [[NSDictionary alloc]initWithObjects:values forKeys:names];    
    
    brain = [[RPNCalculatorBrain alloc] init];
    
    whyTimesTwo = [[NSArray alloc]initWithObjects:@"y", @"y", "+" , nil ];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRunningProgramWithVariables
{
    STAssertTrue( [RPNCalculatorBrain runProgram:whyTimesTwo usingVariableValues:mockVariables] == 84.0, @"y,y,+ should equal 84!!" );
}

@end
