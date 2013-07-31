//
//  Dictionary.h
//  Flash Card
//
//  Created by Albert on 13/6/10.
//  Copyright (c) 2013年 Albert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * antonym;
@property (nonatomic, retain) NSString * chinese;
@property (nonatomic, retain) NSString * eng;
@property (nonatomic, retain) NSString * synonym;

@end
