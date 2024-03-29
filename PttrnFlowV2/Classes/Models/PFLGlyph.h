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
FOUNDATION_EXPORT NSString* const PFLGlyphTypeSwitchSender;
FOUNDATION_EXPORT NSString* const PFLGlyphTypeWarp;

@interface PFLGlyph : NSObject

@property (weak, nonatomic) PFLPuzzle* puzzle;

@property (strong, nonatomic) NSNumber* responderID;
@property (strong, nonatomic) NSNumber* audioID;
@property (strong, nonatomic) PFLCoord* cell;
@property (copy, nonatomic) NSString* direction;
@property (copy, nonatomic) NSString* type;
@property BOOL isStatic;
@property (strong, nonatomic) NSArray* switchReceiverAttributes;
@property (strong, nonatomic) NSNumber* switchChannel;
@property (strong, nonatomic) NSNumber* warpChannel;

- (id)initWithObject:(NSDictionary*)object puzzle:(PFLPuzzle*)puzzle isStatic:(BOOL)isStatic;

@end
