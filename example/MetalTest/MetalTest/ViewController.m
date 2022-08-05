//
//  ViewController.m
//  MetalTest
//
//  Created by sharexia on 2022/7/27.
//

#import "ViewController.h"


@interface ViewController ()
@property (strong) IBOutlet NSSearchField *searchField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSSearchFieldCell *cell = self.searchField.cell;
    cell.searchButtonCell = nil;
    NSLog(@"%@", cell);
    
    cell.cancelButtonCell = [[NSButtonCell alloc] initImageCell:[NSImage imageNamed:@"ddd"]];
    cell.cancelButtonCell.backgroundColor = [NSColor grayColor];
    cell.cancelButtonCell.target = self;
    cell.cancelButtonCell.action = @selector(cancellAction:);
}

- (void)cancellAction:(NSButtonCell *)cell {
    self.searchField.cell.stringValue = @"";
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
