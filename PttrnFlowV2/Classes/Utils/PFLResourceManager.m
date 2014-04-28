//
//  PFLResourceManager.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/26/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "PFLResourceManager.h"
#import "PFLPuzzle.h"

@interface PFLResourceManager ()

@property (strong, nonatomic) NSMutableDictionary* puzzles;

@end

@implementation PFLResourceManager

+ (PFLResourceManager*)sharedInstance
{
  static PFLResourceManager* sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[PFLResourceManager alloc] init];
  });
  return sharedInstance;
}

@end
