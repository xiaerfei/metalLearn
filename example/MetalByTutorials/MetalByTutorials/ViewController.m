//
//  ViewController.m
//  MetalByTutorials
//
//  Created by sharexia on 4/18/23.
//

#import "ViewController.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Masonry/Masonry.h>
@interface ViewController ()

@property (nonatomic, strong) MTKView *mtkView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    id <MTLDevice> device = MTLCreateSystemDefaultDevice();
    self.mtkView = [[MTKView alloc] initWithFrame:CGRectZero device:device];
    [self.view addSubview:self.mtkView];
    
    [self.mtkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.equalTo(@600);
    }];
    
    [self.mtkView setClearColor:MTLClearColorMake(1, 1, 0.8, 1)];
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:(vector_float3){0.2, 0.75, 0.2}
                                                    segments:(vector_uint2){100, 100}
                                               inwardNormals:NO
                                                geometryType:MDLGeometryTypeTriangles
                                                   allocator:allocator];
    NSError *error = nil;
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    if (error) {
        NSLog(@"%@", error.description);
        return;
    }
    
    id <MTLCommandQueue> commandQueue =[device newCommandQueue];
    
    
    
#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)
    
    
    NSString *shader = SHADER_STRING(
     ##include <metal_stdlib>
     using namespace metal;
     
     struct VertexIn {
         float4 position [[attribute(0)]];
     };
     
     vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
         return vertex_in.position;
     }
     
     fragment float4 fragment_main() {
         return float4(0, 0.4, 0.21, 1);
     }
    );
    
    NSLog(@"%@", shader);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
