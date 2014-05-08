//
//  PFLSwitchReceiver.m
//  PttrnFlowV2
//
//  Created by John Saba on 5/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLSwitchReceiverAttributes.h"

@implementation PFLSwitchReceiverAttributes

- (instancetype)initWithJson:(NSDictionary *)json
{
  self = [super init];
  if (self)
  {
    NSNumber* active = json[@"active"];
    NSAssert(active, @"Error: switch receiver attributes must contain 'active' field.");
    self.active = [active boolValue];
    
    self.direction = json[@"direction"];
  }
  return self;
}

@end
