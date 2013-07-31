//
//  FCDataSource.m
//  Flash Card
//
//  Created by Albert on 13/5/26.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import "FCDataSource.h"

//static NSString *FCDataSourceCacheForDictionaryKeyWords = @"FCDataSource.Cache.%@.Word";

NSString * const FCDataSourceDictionaryKeyWord = @"Word";
NSString * const FCDataSourceDictionaryKeyChinese = @"Chinese";
NSString * const FCDataSourceDictionaryKeySynonym = @"Synonym";
NSString * const FCDataSourceDictionaryKeyAntonym = @"Antonym";


@implementation FCDataSource

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (FCDataSource *)sharedDataSource {
    static dispatch_once_t once;
    static FCDataSource *sharedDataSource;
    dispatch_once(&once, ^ {
        sharedDataSource = [[self alloc] init];
    });
    return sharedDataSource;
}

- (id)init {
    //reserve these
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Property List"
                                                         ofType:@"plist"];
        wordsInPlist = [NSArray arrayWithContentsOfFile:path];
        cacheForDictionary = [[NSCache alloc] init];
        [self reloadLocationData];
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionary" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    allWords = [_managedObjectContext executeFetchRequest:fetch error:nil];
    if([allWords count] == 0){
        Dictionary *dictionary;
        FlashCard *flashcard;
        for (NSDictionary *dic in wordsInPlist) {
            dictionary = [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:context];
            dictionary.eng = dic[FCDataSourceDictionaryKeyWord];
            dictionary.chinese = dic[FCDataSourceDictionaryKeyChinese];
            dictionary.synonym = dic[FCDataSourceDictionaryKeySynonym];
            dictionary.antonym = dic[FCDataSourceDictionaryKeyAntonym];
            [context save:nil];
            [fetch setEntity:entity];
            [fetch setSortDescriptors:sortArray];
            allWords = [_managedObjectContext executeFetchRequest:fetch error:nil];
        }
        for (int i = 0; i < 139; i = i+10) {
            Dictionary *d = allWords[i];
            flashcard = [NSEntityDescription insertNewObjectForEntityForName:@"FlashCard" inManagedObjectContext:context];
            flashcard.eng = d.eng;
            flashcard.chinese = d.chinese;
            flashcard.synonym = d.synonym;
            flashcard.antonym = d.antonym;
            [context save:nil];
        }
    }
    NSFetchRequest *fetchFC = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityFC = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetchFC setEntity:entityFC];
    NSSortDescriptor *sortFC = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArrayFC = [[NSArray alloc] initWithObjects:sortFC, nil];
    [fetchFC setSortDescriptors:sortArrayFC];
    allFlashCards = [_managedObjectContext executeFetchRequest:fetchFC error:nil];
    self = [super init];
    return self;
}

- (void)reloadLocationData {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *plistFile = [docPath stringByAppendingPathComponent:@"Property List.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistFile]) {
        plistFile = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    }
    wordsInPlist = [NSArray arrayWithContentsOfFile:plistFile];
}

- (NSArray *)arrayWithDictionary{
    return allWords;
}

- (NSArray *)arrayWithAllFlashCard{
    return allFlashCards;
}

-(void)addFlashCard:(Dictionary *)dictionary{
    NSManagedObjectContext *context = [self managedObjectContext];
    FlashCard *flashCard = [NSEntityDescription insertNewObjectForEntityForName:@"FlashCard" inManagedObjectContext:context];
    flashCard.eng = dictionary.eng;
    flashCard.chinese = dictionary.chinese;
    flashCard.synonym = dictionary.synonym;
    flashCard.antonym = dictionary.antonym;
    [context save:nil];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    allFlashCards = [_managedObjectContext executeFetchRequest:fetch error:nil];
    [context save:nil];
}

- (void)updateArrayForFlashCard{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    allFlashCards = [_managedObjectContext executeFetchRequest:fetch error:nil];
}

- (Dictionary *)dictionaryWithWord:(NSString *)wordBeenSearched{
    for(Dictionary *word in allWords){
        if([word.eng isEqualToString:wordBeenSearched]){
            return word;
        }
    }
}

-(NSArray *)searchWord:(NSString *)searchText{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dictionary" inManagedObjectContext:context];
    [fetch setEntity:entity];
    NSString *text = [NSString stringWithFormat:@"eng like '%@*'", searchText];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:text];
    [fetch setPredicate:predicate];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]  initWithKey:@"eng" ascending:YES];
    NSArray *sortArray = [[NSArray alloc] initWithObjects:sort, nil];
    [fetch setSortDescriptors:sortArray];
    NSArray *result = [_managedObjectContext executeFetchRequest:fetch error:nil];
    return result;
}

- (NSString *)dictionaryWithWordsAtIndexPath:(NSIndexPath *)indexPath {
    Dictionary *dic = [self arrayWithDictionary][indexPath.row];
    NSString *word = dic.eng;
    return word;
}

-(void) deleteFlashCard:(NSString *)flashCardToBeDeleted{
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FlashCard" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eng == %@", flashCardToBeDeleted];
    [fetch setPredicate:predicate];
    NSArray *flashcard = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (FlashCard *f in flashcard) {
        [self.managedObjectContext deleteObject:f];
    }
    [self.managedObjectContext save:nil];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Dictionary" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Dictionary.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
