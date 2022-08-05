//
//  CusTextFieldCell.m
//  MetalTest
//
//  Created by sharexia on 2022/8/3.
//

#import "CusTextFieldCell.h"

@implementation CusTextFieldCell

- (void)editWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event {
    
    NSRect cellRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width - 30, rect.size.height);
    [super editWithFrame:cellRect inView:controlView editor:textObj delegate:delegate event:event];
}

- (void)selectWithFrame:(NSRect)rect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength {
    NSRect cellRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width - 30, rect.size.height);
    
    [super selectWithFrame:cellRect inView:controlView editor:textObj delegate:delegate start:selStart length:selLength];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
    NSRect cellRect = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width - 30, cellFrame.size.height);
    [super drawWithFrame:cellRect inView:controlView];
}


@end
