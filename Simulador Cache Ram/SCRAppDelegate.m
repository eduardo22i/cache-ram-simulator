//
//  SCRAppDelegate.m
//  Simulador Cache Ram
//
//  Created by Eduardo Irias on 05/05/13.
//  Copyright (c) 2013 Estamp World. All rights reserved.
//

#import "SCRAppDelegate.h"


@implementation SCRAppDelegate

@synthesize table;
@synthesize sincache, directo, asociativo, asociativo_conj;
@synthesize lbl_datos_1, lbl_datos_2, lbl_datos_3, lbl_datos_4;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
      
    

    
    
}


- (IBAction)start:(id)sender {
     
    sincache = [[SCRCalculator alloc] init];
    [sincache startwithtype:0];
    
    lbl_datos_1.stringValue = [NSString stringWithFormat:@"%f µs",sincache.mips ];
    
    directo = [[SCRCalculator alloc] init];
    [directo startwithtype:1];
    
    
    lbl_datos_2.stringValue = [NSString stringWithFormat:@"%f µs",directo.mips ];
    
    asociativo  = [[SCRCalculator alloc] init];
    [asociativo startwithtype:2];
    
    
    lbl_datos_3.stringValue = [NSString stringWithFormat:@"%f µs",asociativo.mips ];
    
    asociativo_conj = [[SCRCalculator alloc] init];
    [asociativo_conj startwithtype:3];    
    
    lbl_datos_4.stringValue = [NSString stringWithFormat:@"%f µs",asociativo_conj.mips ];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Calculations Done!";
    notification.informativeText = @"We have finish the simulations.";
    notification.soundName = NSUserNotificationDefaultSoundName;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
