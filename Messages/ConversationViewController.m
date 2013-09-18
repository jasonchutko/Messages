//
//  ConversationViewController.m
//  Messages
//
//  Created by Jason Chutko on 2013-07-05.
//  Copyright (c) 2013 Jason Chutko. All rights reserved.
//

#import "ConversationViewController.h"
#import "Message.h"
#import "AppDelegate.h"
#import "User.h"


@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self;
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = _conversation.partner.name;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [NSFetchedResultsController deleteCacheWithName:@"Conversation"];
    _fetchedResultsController = nil;
    [super viewWillDisappear:animated];
}

- (void)setConversation:(Conversation *)conversation {
    _conversation = conversation;
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - FetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Message" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"conversation == %@", _conversation]];
    
    [NSFetchedResultsController deleteCacheWithName:@"Conversation"];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:@"Conversation"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - JSMessagesView Data Source

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self shouldHaveTimestampForRowAtIndexPath:indexPath];
}

- (JSMessagesViewTimestampPolicy)timestampPolicyForMessagesView {
    return JSMessagesViewTimestampPolicyEveryFive;
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text {
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
    NSManagedObject *newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"Message" inManagedObjectContext:context];
    [newMessage setValue:[NSDate date] forKey:@"timestamp"];
    [newMessage setValue:[NSNumber numberWithInt:0] forKey:@"type"];
    [newMessage setValue:[NSNumber numberWithInt:0] forKey:@"id"];
    [newMessage setValue:text forKey:@"body"];
    
    [newMessage setValue:_conversation forKey:@"conversation"];
    
    [_conversation setValue:newMessage forKey:@"lastMessage"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self finishSend];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JSBubbleMessageStyleOutgoingDefault;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message * message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return message.timestamp;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath {
    Message * message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return message.body;
}


@end
