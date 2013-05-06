//
//  SCRAppDelegate.h
//  Simulador Cache Ram
//
//  Created by Eduardo Irias on 05/05/13.
//  Copyright (c) 2013 Estamp World. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SCRCalculator.h"


@interface SCRAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSScrollView *table;
@property (weak) IBOutlet NSButton *start_btn;


@property (nonatomic) SCRCalculator *sincache;
@property (nonatomic) SCRCalculator *directo;
@property (nonatomic) SCRCalculator *asociativo;
@property (nonatomic) SCRCalculator *asociativo_conj;

@property (weak) IBOutlet NSTextField *lbl_datos_1;
@property (weak) IBOutlet NSTextField *lbl_datos_2;
@property (weak) IBOutlet NSTextField *lbl_datos_3;
@property (weak) IBOutlet NSTextField *lbl_datos_4;

- (IBAction)start:(id)sender;

@end
