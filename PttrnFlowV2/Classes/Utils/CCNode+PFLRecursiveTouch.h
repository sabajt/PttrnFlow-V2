//
//  CCNode+PFLRecursiveTouch.h
//  PttrnFlowV2
//
//  Created by John Saba on 4/8/14.
//  Copyright (c) 2014 John Saba. All rights reserved.
//

#import "CCNode.h"

@interface CCNode (PFLRecursiveTouch)

-(BOOL) hitTestWithWorldPos:(CGPoint)worldPos forNodeTree:(id)parentNode shouldIncludeParentNode:(BOOL)includeParent;

@end
