//
//  FCViewController.m
//  Flash Card
//
//  Created by Albert on 13/5/13.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "FCViewController.h"

@interface FCViewController ()

@end

@implementation FCViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        //custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    flashCard = [self.wordsInFlashCard objectAtIndex:self.indexForFlashCards];
    self.word.text = flashCard.eng;
    self.chinese.text = flashCard.chinese;
    self.chinese.hidden=YES;
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload{
    [self setChinese:nil];
    //  [self setWord:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteFlashCard:(id)sender{
    FlashCard *word = [self.wordsInFlashCard objectAtIndex:self.indexForFlashCards];
    NSString *wordToBeDeleted = word.eng;
    if(self.indexForFlashCards+1 == [self.wordsInFlashCard count]){
        [self.wordsInFlashCard removeObjectAtIndex:self.indexForFlashCards];
        self.indexForFlashCards--;
        maxIndexForFlashCards--;
        [self viewDidLoad];
    }
    else{
        NSLog(@"index %d count %d", self.indexForFlashCards, [self.wordsInFlashCard count]);
        [self.wordsInFlashCard removeObjectAtIndex:self.indexForFlashCards];
        maxIndexForFlashCards--;
        [self viewDidLoad];
    }
    [[FCDataSource sharedDataSource] deleteFlashCard:wordToBeDeleted];
}

- (IBAction)handleTap:(UITapGestureRecognizer *) recognizer{
    NSLog(@"tap");
    self.chinese.hidden = NO;
}

- (IBAction)handleSwipe:(UIGestureRecognizer *)sender {
    UISwipeGestureRecognizerDirection direction = [(UISwipeGestureRecognizer *) sender direction];
    switch (direction){
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.indexForFlashCards+1 <= [self.wordsInFlashCard count]-1) {
                self.indexForFlashCards++;
                NSLog(@"swipe left %d", self.indexForFlashCards);
                [self viewDidLoad];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if((int)(self.indexForFlashCards-1) >= 0){
                self.indexForFlashCards--;
                NSLog(@"swipe right %d", self.indexForFlashCards);
                [self viewDidLoad];
            }
            break;
        default:
            break;
    }
}

@end
