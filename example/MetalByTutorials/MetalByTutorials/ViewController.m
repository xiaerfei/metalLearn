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


#include <pthread.h>
#import "FFRenderImageView.h"
#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)


@interface ViewController ()
@property (nonatomic, strong) FFRenderImageView *renderImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.renderImageView = [[FFRenderImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.renderImageView];
    
    [self.renderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
