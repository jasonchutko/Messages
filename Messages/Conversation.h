//
//  Conversation.h
//  Messages
//
//  Created by Jason Chutko on 2013-07-06.
//  Copyright (c) 2013 Jason Chutko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, User;

@interface Conversation : NSManagedObject

@property (nonatomic, retain) Message *lastMessage;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) User *partner;
@end

@interface Conversation (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
