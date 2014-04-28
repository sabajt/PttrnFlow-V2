//
//  PFLJsonUtils.m
//  PttrnFlow
//
//  Created by John Saba on 3/16/14.
//
//

#import "AppDelegate.h"
#import "PFLJsonUtils.h"

@implementation PFLJsonUtils

+ (NSDictionary*)deserializeJsonObjectResource:(NSString*)resource
{
  return [self deserializeJsonObjectResource:resource bundle:[NSBundle mainBundle]];
}

+ (NSDictionary*)deserializeJsonObjectResource:(NSString*)resource bundle:(NSBundle*)bundle
{
  NSString* path = [bundle pathForResource:resource ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:path];
  NSError* error;
  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  NSAssert(!error, @"Failed to deserialize %@.json with error: %@", resource, error.description);
  return json;
}

+ (NSArray*)deserializeJsonArrayResource:(NSString*)resource
{
  return [self deserializeJsonArrayResource:resource bundle:[NSBundle mainBundle]];
}

+ (NSArray*)deserializeJsonArrayResource:(NSString*)resource bundle:(NSBundle*)bundle
{
  NSString* path = [bundle pathForResource:resource ofType:@"json"];
  NSData* data = [NSData dataWithContentsOfFile:path];
  NSError* error;
  NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
  NSAssert(!error, @"Failed to deserialize %@.json with error: %@", resource, error.description);
  return json;
}

+ (void)serializeJsonObject:(id)object withName:(NSString*)name
{
  NSError* error;
  NSData* data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
  NSAssert(!error, @"Failed to serialize object with error: %@", error.description);
  NSString* path = [[AppDelegate applicationDocumentsDirectory] stringByAppendingFormat:@"%@.json", name];
  [data writeToFile:path atomically:YES];
}

@end
