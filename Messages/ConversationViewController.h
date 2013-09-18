//
//  ConversationViewController.h
//  Messages
//
//  Created by Jason Chutko on 2013-07-05.
//  Copyright (c) 2013 Jason Chutko. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "Conversation.h"

@interface ConversationViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) Conversation * conversation;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
