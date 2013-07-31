//
//  FCExerciseViewController.m
//  Flash Card
//
//  Created by Albert on 13/6/3.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "FCExerciseViewController.h"
#import "FCDataSource.h"

NSUInteger const numberOfExercise = 20;

@interface FCExerciseViewController ()

@end

@implementation FCExerciseViewController

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
    [self createQuestionsInArrayAndRandomize];
    UIActionSheet *targetSheet = [[UIActionSheet alloc] initWithTitle:@"How many exercise do you want to do?"
                                                        delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"10", @"20", @"30", @"40", nil];
    UIWindow *mainWindow = [[UIApplication sharedApplication] windows][0];
    [targetSheet showInView:mainWindow];
    indexForQuestion = 0;
    numberOfNo = 0;
    numberOfYes = 0;
    if ([arrayForQuestions count] > numberOfExercise) {
        maxIndexForQuestion = numberOfExercise;
    }
    else{
        maxIndexForQuestion = [arrayForQuestions count];
    }
    _chinese.hidden = YES;
    _queryLabel.hidden = YES;
    _queryYes.hidden = YES;
    [_queryYes setEnabled:YES];
    [_queryNo setEnabled:YES];
    [_tapRecognizer setEnabled:YES];
    _queryNo.hidden = YES;
    _tryAgain.hidden = YES;
    _number.text = [NSString stringWithFormat:@"Question: %d", indexForQuestion+1];
    FlashCard *question = [arrayForQuestions objectAtIndex:indexForQuestion];
    _word.text = question.eng;
    _chinese.text = question.chinese;
    _countDown.text = [NSString stringWithFormat:@"Time left: 5 sec"];
    countDownCounter = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0){
        if([arrayForQuestions count] < 10){
            [self showAlertMessage];
            maxIndexForQuestion = [arrayForQuestions count];
        }
        else{
            maxIndexForQuestion = 10;
            [self start];
        }
    }
    else if(buttonIndex == 1){
        if([arrayForQuestions count] < 20){
            [self showAlertMessage];
            maxIndexForQuestion = [arrayForQuestions count];
        }
        else{
            maxIndexForQuestion = 20;
            [self start];
        }
    }
    else if(buttonIndex == 2){
        if([arrayForQuestions count] < 30){
            [self showAlertMessage];
            maxIndexForQuestion = [arrayForQuestions count];
        }
        else{
            maxIndexForQuestion = 30;
            [self start];
        }
    }
    else if (buttonIndex == 3){
        if ([arrayForQuestions count] < 40) {
            [self showAlertMessage];
            maxIndexForQuestion = [arrayForQuestions count];
        }
        else{
            maxIndexForQuestion = 40;
            [self start];
        }
    }
    else if (buttonIndex == 4){
        NSLog(@"cancel");
    }
}

-(void)showAlertMessage{
    NSString *alertMessage = [NSString stringWithFormat:@"Sorry, there is only %d words in your flashcard, so we can only have %d questions!", [arrayForQuestions count], [arrayForQuestions count]];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Too few words in flashcard."
                                                      message:alertMessage
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
    message.tag = 1;
    [message show];
}

- (void)createQuestionsInArrayAndRandomize{
    arrayForQuestions = [NSMutableArray arrayWithArray:[[FCDataSource sharedDataSource] arrayWithAllFlashCard]];
    NSUInteger count = [arrayForQuestions count];
    for (NSUInteger i = 0; i < count; i++) {
        NSUInteger nElement = count - i;
        NSUInteger n = (arc4random() % nElement) + i ;
        [arrayForQuestions exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(IBAction)handleTap:(UITapGestureRecognizer *)recognizer{
    if(countDownCounter != 0){
        NSLog(@"tap %d", maxIndexForQuestion);
        _chinese.hidden = NO;
        [_queryLabel setHidden:NO];
        [_queryYes setHidden:NO];
        [_queryNo setHidden:NO];
        [counDownTimer invalidate];
    }
    else if(countDownCounter == 0){
        countDownCounter = 5;
        if(indexForQuestion == maxIndexForQuestion-1){
            numberOfNo++;
            [self endExercise];
        }
        else{
            indexForQuestion++;
            numberOfNo++;
            [self nextQuestion];
        }
    }
}

- (IBAction)yesButtonTapped:(id)sender {
    NSLog(@"yes button tapped");
    if(indexForQuestion == maxIndexForQuestion-1){
        numberOfYes++;
        _queryYes.hidden = YES;
        _queryNo.hidden = YES;
        _queryLabel.hidden = YES;
        [self endExercise];
    }
    else{
        indexForQuestion++;
        numberOfYes++;
        [self nextQuestion];
    }
}

- (IBAction)noButtonTapped:(id)sender {
    NSLog(@"no button tapped");
    if(indexForQuestion == maxIndexForQuestion-1){
        numberOfNo++;
        _queryYes.hidden = YES;
        _queryNo.hidden = YES;
        _queryLabel.hidden = YES;
        [self endExercise];
    }
    else{
        indexForQuestion++;
        numberOfNo++;
        [self nextQuestion];
    }
}

-(void)nextQuestion{
    _chinese.hidden = YES;
    _queryLabel.hidden = YES;
    _queryYes.hidden = YES;
    _queryNo.hidden = YES;
    _number.text = [NSString stringWithFormat:@"Question: %d", indexForQuestion+1];
    FlashCard *question = [arrayForQuestions objectAtIndex:indexForQuestion];
    _word.text = question.eng;
    _chinese.text = question.chinese;
    _countDown.text = [NSString stringWithFormat:@"Time left: 5 sec"];
    countDownCounter = 5;
    [self start];
}

-(void)endExercise{
    NSString *alertMessage = [NSString stringWithFormat:@"You got %d questions correct and %d questions incorrect.", numberOfYes, numberOfNo];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Exercise finished!"
                                                      message:alertMessage
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles:@"Do it again", nil];
    message.tag = 2;
    [message show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            switch (buttonIndex) {
                case 1:
                    NSLog(@"ok");
                    [self start];
                    break;
                default:
                    NSLog(@"default");
                    [self start];
                    break;
            }
            break;
        case 2:
            switch (buttonIndex) {
                case 0:
                    NSLog(@"ok tapped");
                    _tryAgain.hidden = NO;
                    _tapRecognizer.enabled = NO;
                    NSLog(@"tap disabled");
                    break;
                case 1:
                    NSLog(@"do it again tapped");
                    [self doItAgainTapped];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

-(void)doItAgainTapped{
    [self viewDidLoad];
}

-(IBAction)tryAgainTapped:(id)sender{
    [self doItAgainTapped];
}

-(void)start{
    counDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(timerFired)
                                                   userInfo:nil
                                                    repeats:YES];
}

-(void)timerFired{
    if (countDownCounter == 0) {
        [counDownTimer invalidate];
        _countDown.text = [NSString stringWithFormat:@"Time left: %d sec", countDownCounter];
        [self timeIsUp];
    }
    else{
        countDownCounter -= 1;
        _countDown.text = [NSString stringWithFormat:@"Time left: %d sec", countDownCounter];
        NSLog(@"%d", countDownCounter);
    }
}

-(void)timeIsUp{
    NSLog(@"time is up!");
    _chinese.hidden = NO;
}

@end
