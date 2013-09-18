//
//  ConversationCell.m
//  Messages
//
//  Created by Jason Chutko on 2013-07-05.
//  Copyright (c) 2013 Jason Chutko. All rights reserved.
//

#import "ConversationCell.h"
#import "Message.h"

@implementation ConversationCell {
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_bodyLabel;
    IBOutlet UILabel *_timeLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if((self = [[NSBundle mainBundle] loadNibNamed:@"ConversationCell" owner:nil options:nil][0])) {
#warning This is a hack fix. For some reason, UIViews added from IB are not being added as subviews of contentView. Also, contentView is not a subview of self for an unknown reason.
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_bodyLabel];
        [self.contentView addSubview:_timeLabel];
        [self addSubview:self.contentView];
    }
    
    return self;
}

- (NSString*)timeFromNSDate:(NSDate*)date {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"HH:mm";
    
    return [timeFormatter stringFromDate:date];
}

- (void)setConversation:(Conversation *)conversation {
    Message * lastMessage = conversation.lastMessage;
    
    [_nameLabel setText:[[conversation valueForKey:@"partner"] valueForKey:@"name"]];
    [_bodyLabel setText:lastMessage.body];
    [_timeLabel setText:[self timeFromNSDate:[lastMessage timestamp]]];
}

+ (CGFloat)Height
{
    return 70;
}

@end
