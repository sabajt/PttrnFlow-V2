//
//  PFLSwitchReceiver.h
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFLSwitchReceiverAttributes : NSObject

// required attribute
@property BOOL active;

// optional attributes
@property (copy, nonatomic) NSString* direction;

- (instancetype)initWithJson:(NSDictionary*)json;

@end
