//
//  FCDataSource.h
//  Flash Card
//
//  Created by Albert on 13/5/26.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dictionary.h"
#import "FlashCard.h"

extern NSString * const FCDataSourceDictionaryKeyWord;
extern NSString * const FCDataSourceDictionaryKeyChinese;

@interface FCDataSource : NSObject{
    NSArray *wordsInPlist;
    NSArray *allWords;
    NSArray *allFlashCards;
    NSCache *cacheForDictionary;
    BOOL hadInitializeDataBase;
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (FCDataSource *)sharedDataSource;
- (id)init;
- (void)reloadLocationData;
- (NSArray *)arrayWithDictionary;
- (NSArray *)arrayWithAllFlashCard;
- (void)addFlashCard:(Dictionary *)dictionary;
- (NSDictionary *)dictionaryWithWord:(NSString *)wordBeenSearched;
- (NSArray *)searchWord:(NSString *)searchText;
- (NSString *)dictionaryWithWordsAtIndexPath:(NSIndexPath *)indexPath;
-(void) deleteFlashCard:(NSString *)flashCardToBeDeleted;

@end
