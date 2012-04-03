//
//  GraphController.m
//  RPNCalculator
//
//  Created by David Young on 29/03/12.
//  Copyright (c) 2012 Digital Trends. All rights reserved.
//

#import "GraphController.h"

@interface GraphController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation GraphController

@synthesize navigationBar = _navigationBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setNavigationBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
