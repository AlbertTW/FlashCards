//
//  FCWordCell.h
//  Flash Card
//
//  Created by Albert on 13/5/27.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface FCWordCell : UITableViewCell

@property IBOutlet UILabel *word;
@property Dictionary *dictionary;

@end
