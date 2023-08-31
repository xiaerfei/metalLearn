//
//  WindowController.m
//  MetalByTutorials
//
//  Created by sharexia on 4/19/23.
//

#import "WindowController.h"

@interface WindowController ()

@end

@implementation WindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window setAspectRatio:NSMakeSize(640, 360)];
    self.window.styleMask |= NSWindowStyleMaskResizable;
    [self.window setShowsResizeIndicator:YES];
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

//- (NSSize)windowWillResize:(NSWindow *) window toSize:(NSSize)newSize
//{
//    if([window showsResizeIndicator])
//        return newSize; //resize happens
//    else
//        return [window frame].size; //no change
//}

@end
