//
//  ConversationCell.h
//  Messages
//
//  Created by Jason Chutko on 2013-07-05.
//  Copyright (c) 2013 Jason Chutko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"

@interface ConversationCell : UITableViewCell

+(CGFloat)Height;

@property (nonatomic) Conversation * conversation;

@end
