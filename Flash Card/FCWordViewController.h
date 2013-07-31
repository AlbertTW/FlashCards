//
//  FCWordViewController.h
//  Flash Card
//
//  Created by Albert on 13/5/26.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface FCWordViewController : UIViewController

@property Dictionary *dictionary;

@property IBOutlet UILabel *word;
@property IBOutlet UILabel *chinese;
@property IBOutlet UILabel *synonym;
@property IBOutlet UILabel *antonym;


@property (strong, nonatomic) NSString *WordHere;
@property (strong, nonatomic) NSString *ChineseHere;

- (IBAction) saveData;

@end
