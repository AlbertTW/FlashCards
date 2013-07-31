//
//  FCExerciseViewController.h
//  Flash Card
//
//  Created by Albert on 13/6/3.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCDataSource.h"

@interface FCExerciseViewController : UIViewController<UIActionSheetDelegate>{
    NSMutableArray *arrayForQuestions;
    NSUInteger indexForQuestion;
    NSUInteger maxIndexForQuestion;
    NSUInteger numberOfYes;
    NSUInteger numberOfNo;
    NSUInteger countDownCounter;
    NSTimer *counDownTimer;
}

@property (weak,nonatomic) IBOutlet UILabel *number;
@property (weak,nonatomic) IBOutlet UILabel *word;
@property (weak,nonatomic) IBOutlet UILabel *chinese;
@property (weak,nonatomic) IBOutlet UILabel *queryLabel;
@property (weak,nonatomic) IBOutlet UIButton *queryYes;
@property (weak,nonatomic) IBOutlet UIButton *queryNo;
@property (weak,nonatomic) IBOutlet UIButton *tryAgain;
@property (weak,nonatomic) IBOutlet UILabel *countDown;
@property (weak,nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

-(void)nextQuestion;

@end
