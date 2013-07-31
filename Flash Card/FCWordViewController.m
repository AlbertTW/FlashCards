//
//  FCWordViewController.m
//  Flash Card
//
//  Created by Albert on 13/5/26.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "FCWordViewController.h"
#import "FCDataSource.h"

@interface FCWordViewController ()

@end

@implementation FCWordViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.word.text = self.dictionary.eng;
    self.chinese.text = self.dictionary.chinese;
    self.synonym.text = self.dictionary.synonym;
    self.antonym.text = self.dictionary.antonym;
}

- (IBAction)saveData {
    BOOL alert = NO;
    for (FlashCard *f in [[FCDataSource sharedDataSource] arrayWithAllFlashCard]) {
        if ([f.eng isEqualToString:self.dictionary.eng]){
            NSString *alertMessage = [NSString stringWithFormat:@"This word has already in the flashcard!"];
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Oops!!"
                                                              message:alertMessage
                                                             delegate:nil
                                                    cancelButtonTitle:@"Ok"
                                                    otherButtonTitles: nil];
            [message show];
            alert = YES;
        }
    }
    if (!alert) {
        [[FCDataSource sharedDataSource] addFlashCard:self.dictionary];
        NSString *alertMessage = [NSString stringWithFormat:@"'%@' has been added to the flashcard!", self.dictionary.eng];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Done!"
                                                          message:alertMessage
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles: nil];
        [message show];
        alert = YES;
    }
}


@end
