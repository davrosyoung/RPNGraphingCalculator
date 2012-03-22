//
//  RPNOperandProtocol.h
//  RPNCalculator
//
//  Created by David Young on 22/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPNOperationProtocol <NSObject>
@property (nonatomic, strong) NSString *name;
- (int)numberOperands;
- (double)evaluate:(NSArray *)args;

@end
