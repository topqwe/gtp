//
//  DraggableCVModel.h

#import <Foundation/Foundation.h>

@interface DraggableCVModel : NSObject
- (BOOL)compareOriginData:(NSMutableArray*)oldArr withNewData:(NSMutableArray*)newArr;
- (BOOL)isEqualFinalElementInArray:(NSMutableArray*)data byX:(NSInteger)x;
- (NSMutableDictionary*)getCollectionDatasByX:(NSInteger)x byY:(NSInteger)y;
- (NSMutableDictionary*)getRotateDatasByX:(NSInteger)x byY:(NSInteger)y;
- (void)setDataIsForceInit:(BOOL)isForceInit;

@end
