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
      
    
    _taskCounts = 0;
    
    
}


- (void) countTasks {
    
    _taskCounts++;
    
    if (_taskCounts == 4) {
        
        
        [_start_btn setTitle:@"Iniciar"];
        [_start_btn setEnabled:YES];

        
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = @"Calculations Done!";
        notification.informativeText = @"We have finish the simulations.";
        notification.soundName = NSUserNotificationDefaultSoundName;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        
    }
    
}


- (IBAction)start:(id)sender {
     
    
    _taskCounts = 0;
    
    [_start_btn setTitle:@"Working..."];
    [_start_btn setEnabled:false];
    
    
    lbl_datos_1.stringValue = @"Working...";
    lbl_datos_2.stringValue = @"Working...";
    lbl_datos_3.stringValue = @"Working...";
    lbl_datos_4.stringValue = @"Working...";
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        sincache = [[SCRCalculator alloc] init];
        [sincache startwithtype:0];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            lbl_datos_1.stringValue = [NSString stringWithFormat:@"%f µs",sincache.mips ];
            [self countTasks];
            
        });
    });
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        directo = [[SCRCalculator alloc] init];
        [directo startwithtype:1];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            lbl_datos_2.stringValue = [NSString stringWithFormat:@"%f µs",directo.mips ];
            [self countTasks];

        });
    });
    
 
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        asociativo  = [[SCRCalculator alloc] init];
        [asociativo startwithtype:2];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
           
            lbl_datos_3.stringValue = [NSString stringWithFormat:@"%f µs",asociativo.mips ];
            [self countTasks];
            
        });
    });
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        asociativo_conj = [[SCRCalculator alloc] init];
        [asociativo_conj startwithtype:3];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            lbl_datos_4.stringValue = [NSString stringWithFormat:@"%f µs",asociativo_conj.mips ];
            [self countTasks];
            
        });
    });
    
    
    
    
    
    
    
   
}

@end
