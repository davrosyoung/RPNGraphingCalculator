//
//  RPNCalculatorTests.m
//  RPNCalculatorTests
//
//  Created by David Young on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RPNCalculatorTests.h"
#import "RPNCalculatorBrain.h"

@implementation RPNCalculatorTests

NSDictionary *mockVariables;
RPNCalculatorBrain *brain;
NSArray *whyTimesTwo;
NSArray *exPlusWhy;
NSArray *cosineOfZeroTimesPi;
NSArray *bakeMeSomePi;
NSArray *justEx;
NSArray *exampleA;
NSArray *exampleB;
NSArray *exampleC;
NSArray *exampleD;
NSArray *exampleE;
NSArray *exampleF;
NSArray *fivePlusNothing;
NSArray *fiveTimesNothing;
NSArray *fiveDividedByNothing;
NSArray *fiveDividedByZero;

- (void)setUp
{
    [super setUp];
    
    NSLog( @"%@ setup", self.name );
    
    // Set-up code here.
    // Set-up code here.
    
    
    NSArray *values = [[NSArray alloc]initWithObjects:[[NSNumber alloc]initWithDouble:23.0],[[NSNumber alloc]initWithDouble:42.0],[[NSNumber alloc]initWithDouble:-1.0],[[NSNumber alloc]initWithDouble:0.0],nil];
    NSNumber *zero = [[NSNumber alloc]initWithInt:0];
    NSNumber *five = [[NSNumber alloc]initWithInt:5];
    NSNumber *three = [[NSNumber alloc]initWithInt:3];
    NSNumber *six = [[NSNumber alloc]initWithInt:6];
    NSNumber *seven = [[NSNumber alloc]initWithInt:7];
    
        
    NSArray *names = [[NSArray alloc]initWithObjects:@"x",@"y",@"alpha",@"beta", nil];
    
    mockVariables = [[NSDictionary alloc]initWithObjects:values forKeys:names];    
    
    brain = [[RPNCalculatorBrain alloc] init];
    
    whyTimesTwo = [[NSArray alloc]initWithObjects:@"y", @"y", @"+" , nil ];
    cosineOfZeroTimesPi = [[NSArray alloc]initWithObjects:@"beta", @"cos", @"pi", @"*", nil ];
    bakeMeSomePi = [[NSArray alloc]initWithObjects:@"pi", nil ];
    justEx = [[NSArray alloc]initWithObjects:@"x", nil ];
    exPlusWhy = [[NSArray alloc]initWithObjects:@"x", @"y", @"+", nil ];

    exampleA = [[NSArray alloc]initWithObjects:three, five, six, seven, @"+", @"*", @"-" , nil ];
    exampleB = [[NSArray alloc]initWithObjects:three, five, @"+", @"sqrt", nil ];
    exampleC = [[NSArray alloc]initWithObjects:three, @"sqrt", @"sqrt", nil ];
    exampleD = [[NSArray alloc]initWithObjects:three, five, @"sqrt", @"+", nil ];
    exampleE = [[NSArray alloc]initWithObjects:@"pi", @"r", @"r", @"*", @"*", nil ];
    exampleF = [[NSArray alloc]initWithObjects:@"a", @"a", @"*", @"b", @"b", @"*", @"+", @"sqrt" , nil ];
    
    fivePlusNothing = [[NSArray alloc]initWithObjects:five, @"+", nil ];
    fiveTimesNothing = [[NSArray alloc]initWithObjects:five, @"*", nil ];
    fiveDividedByNothing = [[NSArray alloc]initWithObjects:five, @"/", nil ];
    fiveDividedByZero = [[NSArray alloc]initWithObjects:five, zero, @"/", nil ];

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAnotherExample
{

    NSInteger myInt = 42;
    STAssertEquals( 42, myInt, @"yay!! It works" );
   
}


- (void)testRunningProgramWithoutVariables
{
    [brain pushOperand:[[NSNumber alloc]initWithDouble:5.0]];
    [brain pushOperand:[[NSNumber alloc]initWithDouble:3.0]];
    [brain performOperation:@"+"];   
    double result = [RPNCalculatorBrain runProgram:brain.program];

    STAssertEquals( 8.0, result, @"bad result 5,3,+ should equal 8. got %lf!!", result );
}

- (void)testRunningProgramWithVariables
{
    double result = [RPNCalculatorBrain runProgram:whyTimesTwo usingVariableValues:mockVariables];
    NSLog( @"obtained result=%lf", result );
    STAssertEquals( 84.0, result, @"y,y,+ should equal 84!!" );
}


- (void)testRunningAnotherProgramWithVariables
{
    double result = [RPNCalculatorBrain runProgram:cosineOfZeroTimesPi usingVariableValues:mockVariables];
    NSLog( @"obtained result=%lf", result );
    STAssertEquals( M_PI, result, @"beta,cos,pi,* should equal PI!!" );
}


- (void)testDescriptionOfBakeMeSomePi
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:bakeMeSomePi];
    STAssertEqualObjects( @"pi", description, @"Should equal pi, but equals %@", description );
}

- (void)testRunningBakeMeSomePi
{
    double expected = M_PI;
    double result = [RPNCalculatorBrain runProgram:bakeMeSomePi usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( result, expected, 0.00001, @"Expected result to be PI" );
}



- (void)testDescriptionOfJustEx
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:justEx];
    STAssertEqualObjects( @"x", description, @"Should equal x, but equals %@", description );
}

- (void)testRunningJustEx
{
    double expected = 23;
    double result = [RPNCalculatorBrain runProgram:justEx usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( result, expected, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}


- (void)testDescriptionOfExPlusWhy
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exPlusWhy];
    NSString *expected = @"x+y";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningExPlusWhy
{
    double expected = 65;
    double result = [RPNCalculatorBrain runProgram:exPlusWhy usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( result, expected, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}


- (void)testDescriptionOfWhyPlusWhy
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:whyTimesTwo];
    NSString *expected = @"y+y";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningWhyPlusWhy
{
    double expected = 84;
    double result = [RPNCalculatorBrain runProgram:whyTimesTwo usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( result, expected, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}


- (void)testDescriptionOfCosineOfBetaTimesPi
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:cosineOfZeroTimesPi];
    NSString *expected = @"cos(beta)*pi";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningCosineOfBetaTimesPi
{
    double expected = M_PI;
    double result = [RPNCalculatorBrain runProgram:cosineOfZeroTimesPi usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}



- (void)testDescriptionOfExampleA
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleA];
    NSString *expected = @"3-5*(6+7)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}

- (void)testRunningExampleA
{
    double expected = -62.0;
    double result = [RPNCalculatorBrain runProgram:exampleA usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}


- (void)testDescriptionOfExampleB
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleB];
    NSString *expected = @"sqrt(3+5)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningExampleB
{
    double expected = 2.82842712474;
    double result = [RPNCalculatorBrain runProgram:exampleB usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}



- (void)testDescriptionOfExampleC
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleC];
    NSString *expected = @"sqrt(sqrt(3))";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );

}

- (void)testRunningExampleC
{
    double expected = 1.316074;
    double result = [RPNCalculatorBrain runProgram:exampleC usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}

- (void)testDescriptionOfExampleD
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleD];
    NSString *expected = @"3+sqrt(5)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningExampleD
{
    double expected = 5.23606798;
    double result = [RPNCalculatorBrain runProgram:exampleD usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}

- (void)testDescriptionOfExampleE
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleE];
    NSString *expected = @"pi*r*r";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningExampleE
{
    double expected = 0.0; // because 'r' is not defined and hence will be zero!!
    double result = [RPNCalculatorBrain runProgram:exampleE usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}

- (void)testDescriptionOfExampleF
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:exampleF];
    NSString *expected = @"sqrt(a*a+b*b)";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );
}


- (void)testRunningExampleF
{
    double expected = 0.0; // because neither 'x' nor 'y' is not defined and hence will be zero!!
    double result = [RPNCalculatorBrain runProgram:exampleF usingVariableValues:mockVariables];
    STAssertEqualsWithAccuracy( expected, result, 0.00001, @"Expected result to be %lf, but got %lf", expected, result );    
}


- (void)testDescriptionOfFivePlusNothing
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:fivePlusNothing];
    NSString *expected = @"5+0";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );    
}

- (void)testDescriptionOfFiveTimesNothing
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:fiveTimesNothing];
    NSString *expected = @"5*0";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );    
}


- (void)testDescriptionOfFiveDividedByNothing
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:fiveDividedByNothing];
    NSString *expected = @"5/0";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );    
}


- (void)testDescriptionOfFiveDividedByZero
{
    NSString *description = [RPNCalculatorBrain descriptionOfProgram:fiveDividedByZero];
    NSString *expected = @"5/0";
    STAssertEqualObjects( expected, description, @"Should equal %@, but equals %@", expected, description );    
}


- (void)testPrecedence
{
    NSArray *operatorsInOrder = [NSArray arrayWithObjects: @"-", @"+", @"/", @"*", @"sin", @"sqrt", nil ];
    int multiplicationPrecedence = [operatorsInOrder indexOfObject:@"*"];
    int divisionPrecedence = [operatorsInOrder indexOfObject:@"/"];
    int additionPrecedence = [operatorsInOrder indexOfObject:@"+"];
    int subtractionPrecedence = [operatorsInOrder indexOfObject:@"-"];
    int sinPrecedence = [operatorsInOrder indexOfObject:@"sin"];
    int sqrtPrecedence = [operatorsInOrder indexOfObject:@"sqrt"];
    int piPrecedence = [operatorsInOrder indexOfObject:@"pi"];
    
    NSLog( @"piPrecedence=%d", piPrecedence );

    STAssertTrue( 3 == multiplicationPrecedence, @"Multiply should be 3!!" );
    STAssertTrue( 2 == divisionPrecedence, @"divide should be 3!!" );
    STAssertTrue( 1 == additionPrecedence, @"add should be 3!!" );
    STAssertTrue( 0 == subtractionPrecedence, @"subtract should be 3!!" );
    STAssertTrue( 4 == sinPrecedence, @"sin should be 4!!" );
    STAssertTrue( 5 == sqrtPrecedence, @"sqrt should be 5!!" );
//    STAssertTrue( -1 == piPrecedence, @"pi should be -1!!" );

}

@end
