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


#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING_(text) @ STRINGIZE2(text)

#define SHADER_STRING(text) [SHADER_STRING_(text) stringByReplacingOccurrencesOfString:@"\\" withString:@""]


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
    ///< MTKView 的 宽高不能为零
    [self.view layoutSubtreeIfNeeded];
    [self.mtkView setClearColor:MTLClearColorMake(1, 1, 0.8, 1)];
    
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    
    MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:(vector_float3){0.5, 0.5, 0.5}
                                                    segments:(vector_uint2){100, 100}
                                               inwardNormals:NO
                                                geometryType:MDLGeometryTypeTriangles
                                                   allocator:allocator];
    NSError *error = nil;
    MTKMesh *mesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:device error:&error];
    if (error) {
        NSLog(@"① %@", error.description);
        return;
    }
    
    id <MTLCommandQueue> commandQueue =[device newCommandQueue];
    
    NSString *shader = SHADER_STRING(
                                     \\#include <metal_stdlib>\n
                                     using namespace metal;
                                     
                                     struct VertexIn {
                                         float4 position [[attribute(0)]];
                                     };
                                     
                                     vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
                                         return vertex_in.position;
                                     }
                                     
                                     fragment float4 fragment_main() {
                                         return float4(2, 0, 0, 1);
                                     }
                                     );
    id <MTLLibrary> library = [device newLibraryWithSource:shader options:nil error:&error];
    if (error) {
        NSLog(@"② %@", error.description);
        return;
    }
    id <MTLFunction> vertex_main   = [library newFunctionWithName:@"vertex_main"];
    id <MTLFunction> fragment_main = [library newFunctionWithName:@"fragment_main"];
    
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = MTLRenderPipelineDescriptor.new;
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    pipelineDescriptor.vertexFunction   = vertex_main;
    pipelineDescriptor.fragmentFunction = fragment_main;
    
    pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor);
    
    id <MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (error) {
        NSLog(@"③ %@", error.description);
        return;
    }
    id <MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    
    id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:self.mtkView.currentRenderPassDescriptor];
    
    [renderEncoder setRenderPipelineState:pipelineState];
    
    [renderEncoder setVertexBuffer:mesh.vertexBuffers[0].buffer offset:0 atIndex:0];
    if (mesh.submeshes.count == 0) {
        NSLog(@"④ mesh sub meshes is zero");
        return;
    }
    MTKSubmesh *submesh = mesh.submeshes.firstObject;
    
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeLine
                              indexCount:submesh.indexCount
                               indexType:submesh.indexType
                             indexBuffer:submesh.indexBuffer.buffer
                       indexBufferOffset:0];
    [renderEncoder endEncoding];
    
    if(!self.mtkView.currentDrawable){
        NSLog(@"⑤ mtkView currentDrawable is null");
        return;
    }
    
    [commandBuffer presentDrawable:self.mtkView.currentDrawable];
    [commandBuffer commit];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
