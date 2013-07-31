//
//  FCFlashCell.h
//  Flash Card
//
//  Created by FeHe on 6/5/13.
//  Copyright (c) 2013 FeHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface FCFlashCell : UITableViewCell

@property IBOutlet UILabel *word;
@property FlashCard *flashcard;

@end
