//
//  ViewController.m
//  TSAlertView
//
//  Created by Local Dev User on 22/10/12.
//  Copyright (c) 2012 Sawtell Software. All rights reserved.
//

#import "ViewController.h"
#import "TSAlertViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self showTouched:nil];
}

- (IBAction)showTouched:(id)sender
{
    TSAlertViewController *alertView = [TSAlertViewController new];
    [alertView showForViewController:self withTitle:@"Gabe Newell" withContent:@"Gabe Logan Newell (sometimes nicknamed Gaben, born November 3, 1962) is the co-founder and managing director of the video game development and online distribution company Valve Corporation."];
}
@end
