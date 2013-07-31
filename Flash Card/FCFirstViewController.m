//
//  FCFirstViewController.m
//  Flash Card
//
//  Created by Edison on 13/6/5.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "FCFirstViewController.h"

@interface FCFirstViewController ()

@end

@implementation FCFirstViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"handleTap");
    [self performSegueWithIdentifier:@"changeView" sender:self];
}


@end
