//
//  CCNode+PFLRecursiveTouch.m
//  PttrnFlowV2
//
//  Created by John Saba on 4/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode+PFLRecursiveTouch.h"

@implementation CCNode (PFLRecursiveTouch)

-(BOOL) hitTestWithWorldPos:(CGPoint)worldPos forNodeTree:(id)parentNode shouldIncludeParentNode:(BOOL)includeParent
//- (BOOL)hitTestWithWorldPos:(CGPoint)worldPos isRoot:(BOOL)isRoot
{
    BOOL hit = NO;
    if (includeParent && [parentNode hitTestWithWorldPos:worldPos]) {
        hit = YES;
    }
    
    for(CCNode *child in [parentNode children]) {
        if ([child hitTestWithWorldPos:worldPos]) {
            hit = YES;
        }
      
        // on recurse, don't process parent again
        if (child.children.count &&
            [self hitTestWithWorldPos:worldPos forNodeTree:child shouldIncludeParentNode:NO])
        {
            hit = YES;
        }
    }
    return  hit;
}

@end
