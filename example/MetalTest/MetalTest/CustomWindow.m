//
//  CustomWindow.m
//  MetalTest
//
//  Created by sharexia on 2022/8/10.
//

#import "CustomWindow.h"

@interface CustomWindow ()
@property (strong) IBOutlet NSToolbar *toolBar;
@property (strong) IBOutlet NSToolbarItem *networkToolBarItem;
@property (strong) IBOutlet NSToolbarItem *titleToolBarItem;

@end

@implementation CustomWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window setTitleVisibility:NSWindowTitleHidden];
    
    // ToolBarVisiable
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toolBarVisiable:)
                                                 name:@"ToolBarVisiable"
                                               object:nil];
    
    NSPopoverTouchBarItem *item = nil;
    NSPopover *over = nil;
    
}
- (IBAction)networkAction:(id)sender {
    [self.window.toolbar setVisible:NO];
    [self.window setTitleVisibility:NSWindowTitleVisible];
}
- (IBAction)titleAction:(id)sender {
    static int cnt = 0;
    static BOOL icon_good = YES;
    if (@available(macOS 10.15, *)) {
        self.titleToolBarItem.title = [NSString stringWithFormat:@"窗口名称 窗口名称 %d", cnt++];
    } else {
        // Fallback on earlier versions
    }
    self.titleToolBarItem.maxSize = NSMakeSize(100, 40);
    [self.titleToolBarItem validate];
    
    icon_good = !icon_good;
    self.networkToolBarItem.image = [NSImage imageNamed:icon_good ? @"network_good":@"network_mid"];
}

- (void)toolBarVisiable:(NSNotification *)notify {
    [self.window setTitleVisibility:NSWindowTitleHidden];
    [self.window.toolbar setVisible:YES];
}

@end
