@import Foundation;

#ifndef NS_SWIFT_NAME(Name)
#  define NS_SWIFT_NAME(Name) __attribute__((swift_name(#Name)))
#endif

@interface SEGreebieArray : NSObject
@end

@interface OmitNeedlessWords : NSObject
-(void)jumpToUrl:(nonnull NSURL *)url;
-(BOOL)objectIsCompatibleWithObject:(nonnull id)other;
-(void)insetByX:(NSInteger)x y:(NSInteger)y;
-(void)setIndirectlyToValue:(nonnull id)object;
-(void)jumpToTop:(nonnull id)sender;
-(void)removeWithNoRemorse:(nonnull id)object;
-(void)bookmarkWithURLs:(nonnull NSArray<NSURL *> *)urls;
-(void)saveToURL:(nonnull NSURL *)url forSaveOperation:(NSInteger)operation;
-(void)indexWithItemNamed:(nonnull NSString *)name;
-(void)methodAndReturnError:(NSError **)error;
-(nullable Class)typeOfString:(nonnull NSString *)string;
-(nullable Class)typeOfNamedString:(nonnull NSString *)string;
-(nullable Class)typeOfTypeNamed:(nonnull NSString *)string;
-(void)appendWithContentsOfString:(nonnull NSString *)string;
-(nonnull id)objectAtIndexedSubscript:(NSUInteger)idx;
-(void)exportPresetsBestMatchingString:(nonnull NSString *)string;
-(void)isCompatibleWithString:(nonnull NSString *)string;
-(void)addObjectValue:(nonnull id)object;
-(nonnull OmitNeedlessWords *)wordsBySlobbering:(nonnull NSString *)string;
-(void)drawPolygonWithPoints:(const NSPoint[])points count:(NSInteger)count;
-(void)drawFilledPolygonWithPoints:(NSPointArray)points count:(NSInteger)count;
-(void)drawGreebies:(nonnull SEGreebieArray*)greebies;
@end

@protocol OMWLanding
-(void)flipLanding;
@end

@protocol OMWWiggle
-(void)joinSub;
-(void)conflicting1 NS_SWIFT_NAME(wiggle1());
@property (readonly) NSInteger conflictingProp1 NS_SWIFT_NAME(wiggleProp1);
@end

@protocol OMWWaggle
-(void)conflicting1 NS_SWIFT_NAME(waggle1());
@property (readonly) NSInteger conflictingProp1 NS_SWIFT_NAME(waggleProp1);
@end

@interface OMWSuper : NSObject <OMWWiggle>
-(void)jumpSuper;
@property (readonly) NSInteger conflictingProp1;
@end

@interface OMWSub : OMWSuper <OMWWaggle>
-(void)jumpSuper;
-(void)joinSub;
-(void)conflicting1;
@property (readonly) NSInteger conflictingProp1;
@end
