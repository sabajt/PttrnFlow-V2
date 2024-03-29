//
//  PFLPuzzle.h
//  PttrnFlow
//
//  Created by John Saba on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@class PFLPuzzleSet;

@interface PFLPuzzle : NSObject

@property (strong, nonatomic) NSArray* area;
@property (strong, nonatomic) NSArray* audio;
@property (copy, nonatomic) NSString* file;
@property (strong, nonatomic) NSArray* inventoryGlyphs;
@property (copy, nonatomic) NSString* name;
@property (weak, nonatomic) PFLPuzzleSet* puzzleSet;
@property (strong, nonatomic) NSArray* solutionEvents;
@property (strong, nonatomic) NSArray* staticGlyphs;

+ (PFLPuzzle*)puzzleFromResource:(NSString*)resource puzzleSet:(PFLPuzzleSet*)puzzleSet;
- (id)initWithJson:(NSDictionary*)json puzzleSet:(PFLPuzzleSet*)puzzleSet;

@end
