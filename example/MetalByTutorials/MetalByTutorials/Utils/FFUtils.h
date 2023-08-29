//
//  FFUtils.h
//  MetalByTutorials
//
//  Created by sharexia on 8/29/23.
//

#import <Foundation/Foundation.h>
#import <simd/vector.h>

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING_(text) @ STRINGIZE2(text)

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    vector_float4 position;
    vector_float2 textureCoordinate;
} LYVertex;


typedef NS_ENUM(NSInteger, FFRenderType) {
    FFRenderTypeImage,
};

@protocol FFRenderProtocol <NSObject>
@required
- (FFRenderType)currentRenderType;

@optional

@end


@interface FFUtils : NSObject

@end

NS_ASSUME_NONNULL_END
