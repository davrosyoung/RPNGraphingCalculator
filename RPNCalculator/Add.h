//
//  Add.h
//  RPNCalculator
//
//  Created by David Young on 22/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPNOperationProtocol.h"

@interface Add : NSObject <RPNOperationProtocol>

@property (nonatomic,strong) NSString *name;
- (double)evaluate:(NSArray *)args;
- (int)numberOperands;

@end
