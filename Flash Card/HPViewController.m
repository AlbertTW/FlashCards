//
//  HPViewController.m
//  HomePage
//
//  Created by Edison on 13/5/26.
//  Copyright (c) 2013年 Edison. All rights reserved.
//

#import "HPViewController.h"


@interface HPViewController ()

@end

@implementation HPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self randomWord];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)randomWord {
    NSArray *wordgroup = [[FCDataSource sharedDataSource] arrayWithDictionary];
    int dividend = [wordgroup count];
    int val = 1+arc4random()%dividend;
    Dictionary *word = [wordgroup objectAtIndex:val];
    [_Word setText:word.eng];
    [_Chinese setText:word.chinese];
}

@end
