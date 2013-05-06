//
//  SCRCalculator.h
//  Simulador Cache Ram
//
//  Created by Eduardo Irias on 05/05/13.
//  Copyright (c) 2013 Estamp World. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCRCalculator : NSObject

@property (assign) double mips;


@property (nonatomic) NSMutableArray *ram;
@property (nonatomic) NSMutableArray *cache;
@property (nonatomic) NSMutableArray *lineaassconj;


- (void) startwithtype:(int)tipo;

@end
