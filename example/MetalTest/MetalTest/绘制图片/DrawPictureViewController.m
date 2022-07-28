//
//  DrawPictureViewController.m
//  MetalTest
//
//  Created by sharexia on 2022/7/27.
//

#import "DrawPictureViewController.h"
#import <MetalKit/MetalKit.h>
#import <Masonry.h>

typedef struct {
    vector_float4 position;
    vector_float2 textureCoordinate;
} LYVertex;






@interface DrawPictureViewController () <MTKViewDelegate>

@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id <MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id <MTLTexture> texture;
@property (nonatomic, assign) vector_uint2 viewportSize;
@property (nonatomic, strong) id <MTLBuffer> vertices;
@property (nonatomic, assign) NSUInteger numVertices;

@end

@implementation DrawPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView = [[MTKView alloc] init];
    [self.view addSubview:self.mtkView];
    
    
    [self.mtkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
    self.mtkView.device = MTLCreateSystemDefaultDevice(); // 获取默认的device
    self.mtkView.delegate = self;
    
    
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
    NSImage *image = [NSImage imageNamed:@"abc"];
    // 纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
    self.texture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
    
    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}}; // 纹理上传的范围
    Byte *imageBytes = [self loadImage:image];
    if (imageBytes) { // UIImage的数据需要转成二进制才能上传，且不用jpg、png的NSData
        [self.texture replaceRegion:region
                    mipmapLevel:0
                      withBytes:imageBytes
                    bytesPerRow:4 * image.size.width];
        free(imageBytes); // 需要释放资源
        imageBytes = NULL;
    }
}

- (Byte *)loadImage:(NSImage *)image {
    NSSize imageSize = image.size;
    NSRect imageRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);

    // Create a context to hold the image data

    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);

    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageSize.width,
                                             imageSize.height,
                                             8,
                                             0,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedLast);

    // Wrap graphics context

    NSGraphicsContext* gctx = [NSGraphicsContext graphicsContextWithCGContext:ctx flipped:NO];

    // Make our bitmap context current and render the NSImage into it

    [NSGraphicsContext setCurrentContext:gctx];
    [image drawInRect:imageRect];

    uint32_t* pixel = (uint32_t*)CGBitmapContextGetData(ctx);

    [NSGraphicsContext setCurrentContext:nil];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    
}



@end
