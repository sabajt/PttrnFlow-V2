//
//  PFLGlyph.h
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import <Foundation/Foundation.h>

@class PFLCoord, PFLPuzzle;

FOUNDATION_EXPORT NSString* const PFLGlyphTypeNone;
FOUNDATION_EXPORT NSString* const PFLGlyphTypeArrow;
FOUNDATION_EXPORT NSString* const PFLGlyphTypeEntry;
FOUNDATION_EXPORT NSString* const PFLGlyphTypeGoal;

@interface PFLGlyph : NSObject

@property (weak, nonatomic) PFLPuzzle* puzzle;

@property (strong, nonatomic) NSNumber* audioID;
@property (strong, nonatomic) PFLCoord* cell;
@property (copy, nonatomic) NSString* direction;
@property (assign) BOOL isStatic;
@property (copy, nonatomic) NSString* type;

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle;

@end
