//
//  FFRenderImageView.m
//  MetalByTutorials
//
//  Created by sharexia on 8/29/23.
//

#import "FFRenderImageView.h"
#import <MetalKit/MetalKit.h>
#import <CoreImage/CoreImage.h>
#import <Masonry/Masonry.h>
@interface FFRenderImageView ()<MTKViewDelegate>

@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, assign) vector_uint2 viewportSize;

@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;

@property (nonatomic, strong) id <MTLBuffer> vertices;

@property (nonatomic, assign) int numVertices;

@property (nonatomic, strong) id<MTLTexture> texture;
@end

@implementation FFRenderImageView
- (instancetype)initWithFrame:(CGRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        [self configure];
    }
    return self;
}

//- (void)updateConstraints {
//    NSDictionary *views = NSDictionaryOfVariableBindings(_mtkView);
//
//    NSArray *constraintsHorizontal =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_mtkView]-0-|"
//                                            options:0
//                                            metrics:nil
//                                              views:views];
//    [self addConstraints:constraintsHorizontal];
//
//    NSArray *constraintsVertical =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_mtkView]-0-|"
//                                            options:0
//                                            metrics:nil
//                                              views:views];
//    [self addConstraints:constraintsVertical];
//    [super updateConstraints];
//}
#pragma mark - Private
- (void)configure {
    // 初始化 MTKView
    self.mtkView = [[MTKView alloc] initWithFrame:self.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice(); // 获取默认的device
    self.mtkView.delegate = self;
    self.viewportSize = (vector_uint2){self.mtkView.drawableSize.width, self.mtkView.drawableSize.height};
    [self addSubview:self.mtkView];
    [self.mtkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self);
    }];
    
    
    [self setupPipeline];
    [self setupVertex];
    [self setupTexture];
}

// 设置渲染管道
-(void)setupPipeline {
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary]; // .metal
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"]; // 顶点shader，vertexShader是函数名
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"]; // 片元shader，samplingShader是函数名
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                         error:NULL]; // 创建图形渲染管道，耗性能操作不宜频繁调用
    self.commandQueue = [self.mtkView.device newCommandQueue]; // CommandQueue是渲染指令队列，保证渲染指令有序地提交到GPU
}

- (void)setupVertex {
    static const LYVertex quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  0.5, -0.5, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5, -0.5, 0.0, 1.0 },  { 0.f, 1.f } },
        { { -0.5,  0.5, 0.0, 1.0 },  { 0.f, 0.f } },
        
        { {  0.5, -0.5, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -0.5,  0.5, 0.0, 1.0 },  { 0.f, 0.f } },
        { {  0.5,  0.5, 0.0, 1.0 },  { 1.f, 0.f } },
    };
    self.vertices = [self.mtkView.device newBufferWithBytes:quadVertices
                                                     length:sizeof(quadVertices)
                                                    options:MTLResourceStorageModeShared]; // 创建顶点缓存
    self.numVertices = sizeof(quadVertices) / sizeof(LYVertex); // 顶点个数
}

- (void)setupTexture {
    CIImage *image = [[CIImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForImageResource:@"WechatIMG24.jpeg"]];
    // 纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDescriptor.width = image.extent.size.width;
    textureDescriptor.height = image.extent.size.height;
    self.texture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
    
    MTLRegion region = {{ 0, 0, 0 }, {image.extent.size.width, image.extent.size.height, 1}}; // 纹理上传的范围
    Byte *imageBytes = [self loadImage:image];
    if (imageBytes) { // UIImage的数据需要转成二进制才能上传，且不用jpg、png的NSData
        [self.texture replaceRegion:region
                    mipmapLevel:0
                      withBytes:imageBytes
                    bytesPerRow:4 * image.extent.size.width];
        free(imageBytes); // 需要释放资源
        imageBytes = NULL;
    }
}

- (Byte *)loadImage:(CIImage *)image {
    if (!image) {
        return NULL;
    }
    // 2 读取图片的大小
    size_t width  = image.extent.size.width;
    size_t height = image.extent.size.height;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    Byte * spriteData  = (Byte *) calloc(width * height * 4, sizeof(Byte)); //rgba共4个byte
    
    [context render:image
           toBitmap:spriteData
           rowBytes:width * 4
             bounds:image.extent
             format:kCIFormatRGBA8 colorSpace:CGColorSpaceCreateDeviceRGB()];
    
    return spriteData;
}
#pragma mark - delegate

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}

- (void)drawInMTKView:(MTKView *)view {
    // 每次渲染都要单独创建一个CommandBuffer
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    // MTLRenderPassDescriptor描述一系列attachments的值，类似GL的FrameBuffer；同时也用来创建MTLRenderCommandEncoder
    if(renderPassDescriptor != nil)
    {
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.5, 0.5, 1.0f); // 设置默认颜色
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor]; //编码绘制指令的Encoder
        [renderEncoder pushDebugGroup:@"Draw G-Buffer"];
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }]; // 设置显示区域
        [renderEncoder setRenderPipelineState:self.pipelineState]; // 设置渲染管道，以保证顶点和片元两个shader会被调用
        
        [renderEncoder setVertexBuffer:self.vertices
                                offset:0
                               atIndex:0]; // 设置顶点缓存

        [renderEncoder setFragmentTexture:self.texture
                                  atIndex:0]; // 设置纹理
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                          vertexStart:0
                          vertexCount:self.numVertices]; // 绘制
        
        [renderEncoder endEncoding]; // 结束
        
        [commandBuffer presentDrawable:view.currentDrawable]; // 显示
        [renderEncoder popDebugGroup];
    }
    
    [commandBuffer commit]; // 提交；
}

#pragma mark - FFRenderProtocol

- (FFRenderType)currentRenderType {
    return FFRenderTypeImage;
}

@end
