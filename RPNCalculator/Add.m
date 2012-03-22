//
//  Add.m
//  RPNCalculator
//
//  Created by David Young on 22/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "Add.h"
#import "RPNOperationProtocol.h"

@interface Add()
@end

@implementation Add
@synthesize name = _name;

- (int)numberOperands
{
    return 2;
}

- (double)evaluate:(NSArray *)args
{
    double result = 0.0;
    
    int i = 0;
    for( i = 0; i < args.count; i++)
    {
        if ( [[args objectAtIndex:i] isMemberOfClass:[NSNumber class]] )
        {
            NSNumber *operand = (NSNumber *)[args objectAtIndex:i];
            result += operand.doubleValue;
        }
    }
    
    return result;
}


@end
