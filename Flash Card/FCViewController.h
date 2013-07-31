//
//  FCViewController.h
//  Flash Card
//
//  Created by Albert on 13/5/13.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface FCViewController : UIViewController{
    NSUInteger maxIndexForFlashCards;
    FlashCard *flashCard;
}

@property NSMutableArray *wordsInFlashCard;
@property NSUInteger indexForFlashCards;
@property (strong, nonatomic) IBOutlet UILabel *word;
@property (strong, nonatomic) IBOutlet UILabel *chinese;
@property (strong, nonatomic) IBOutlet UIView *TextVie;
@property (weak,nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

- (IBAction)deleteFlashCard:(id)sender;
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer;
- (IBAction)handleSwipe:(UIGestureRecognizer *)sender;

@end
