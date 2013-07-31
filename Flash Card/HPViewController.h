//
//  HPViewController.h
//  HomePage
//
//  Created by Edison on 13/5/26.
//  Copyright (c) 2013年 Edison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface HPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *Word;
@property (weak, nonatomic) IBOutlet UILabel *Chinese;

- (void)randomWord;

@end
