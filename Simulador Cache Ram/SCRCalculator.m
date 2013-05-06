//
//  SCRCalculator.m
//  Simulador Cache Ram
//
//  Created by Eduardo Irias on 05/05/13.
//  Copyright (c) 2013 Estamp World. All rights reserved.
//

#import "SCRCalculator.h"

@implementation SCRCalculator

@synthesize mips;
@synthesize ram, cache;
@synthesize lineaassconj;

- (id) init {
    
    mips = 0;
    
    ram = [[NSMutableArray alloc] initWithCapacity:4096];
    cache = [[NSMutableArray alloc] initWithCapacity:512];
    
    
    lineaassconj = [[NSMutableArray alloc] initWithCapacity:16];
    
    
    for (int i = 0; i<64; i++) {
        cache[i] = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:-1],
                    [NSNumber numberWithInt:0],
                    [NSNumber numberWithInt:0],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    [NSNumber numberWithInt:-99999],
                    nil];
    }
    
    for (int i = 0; i<16; i++) {
        [lineaassconj insertObject:[NSNumber numberWithInt:0] atIndex:i];
    }
    
    mips = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"datos" ofType:@"txt"];
    if (filePath) {
        NSString *stringFromFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        ram = [[NSMutableArray alloc] initWithArray:[stringFromFile componentsSeparatedByString:@"\n"]];
    }
    
    
    
    return self;
}


#pragma mark ayuda

- (bool) etiquetassoniguales:(int)linea and:(int)etiqueta {
    
    if ([[[cache objectAtIndex:linea] objectAtIndex:0] isEqual:[[NSNumber alloc] initWithInt:etiqueta]]) {
        return true;
    }
    return false;
}

- (bool) valido:(int)linea {
    if ([[[cache objectAtIndex:linea] objectAtIndex:1] isEqual:[[NSNumber alloc] initWithInt:1]]) {
        return true;
    }
    return false;
}


- (bool) modificado:(int)linea {
    if ([[[cache objectAtIndex:linea] objectAtIndex:2] isEqual:[[NSNumber alloc] initWithInt:1]]) {
        return true;
    }
    return false;
}

/**/


- (int) proximalinea:(int)conj and:(int)vias {

    int proximalineaR;
    
    proximalineaR = [[lineaassconj objectAtIndex:conj] intValue];
    
    if(proximalineaR == vias-1){
        [lineaassconj setObject:[[NSNumber alloc] initWithInt:0] atIndexedSubscript:conj];
    }else{
        [lineaassconj setObject:[[NSNumber alloc] initWithInt:proximalineaR+1] atIndexedSubscript:conj];
    }
    
    
    return proximalineaR;
}


#pragma mark leer

- (int) leerconposicion:(int)posicion ycontipo:(int)tipo {

    
    if (tipo == 0) {
        mips += 0.1;
        return [[ram objectAtIndex:posicion] intValue];
    }
    
   
    if (tipo == 1) {
        int bloque = posicion/8;
        int linea = bloque%64;
        int etiqueta = bloque/64;
        int palabra = (posicion%8)+3;
        
        
        
        int etiquetaAnt = [[[cache objectAtIndex:linea] objectAtIndex:0] intValue];
        
        
        
        if ([self valido:linea]) {
            if ([self etiquetassoniguales:linea and:etiqueta]) {
                mips += 0.01;
            } else {
                
                if ([self modificado:linea]) {
                    mips += 0.66;
                    
                    int w = 3;
                    
                    int g = (etiquetaAnt*512)+(linea*8);
                    
                    for (int i = g; i < g+8; i++) {
                       [ram setObject:[[cache objectAtIndex:linea] objectAtIndex:w]  atIndexedSubscript:i];
                        w++;
                    }
                    
                    
                }
                
                mips += 0.67;
                
                
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:0]  atIndexedSubscript:2];
                
                int w = 3;
                for (int i = bloque*8; i < (bloque*8)+8; i++) {
                    [[cache objectAtIndex:linea] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                    w++;
                }
                
                
            }
        } else {
            mips += 0.67;
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:0]  atIndexedSubscript:2];
            
            int w = 3;
            for (int i = bloque*8; i < (bloque*8)+8; i++) {
                [[cache objectAtIndex:linea] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
        }
        
        
        
        return [[[cache objectAtIndex:linea] objectAtIndex:palabra] intValue];
        
    }
    
    
     
    if (tipo == 2) {
        int bloque = posicion/8;
        int conjunto = 0;
        int etiqueta = bloque;
        int palabra = (posicion%8)+3;
        int lineaetiquetaconjunto = 0;
        int vias = 64;
        int linealeer = 0;
        int lineaescribir = 0;
        int etiquetaant = 0;
        bool etiquetaexiste = false;
        int ver = conjunto * 64;
        
        for (int i = ver; i < ver+64; i++) {
            
            if ([self etiquetassoniguales:i and:etiqueta]) {
                lineaetiquetaconjunto = i - ver;
                etiquetaexiste = true;
            }
        }
        
        linealeer = ver + lineaetiquetaconjunto;
        
        
        if (etiquetaexiste) {
            mips += 0.01;
            return [[[cache objectAtIndex:linealeer] objectAtIndex:palabra] intValue];
        } else {
            
            
            lineaescribir = [self proximalinea:conjunto and:vias] + ver;
            
            
            etiquetaant = [[[cache objectAtIndex:lineaescribir] objectAtIndex:0] intValue];
            
            
            if ([self modificado:lineaescribir]) {
                mips += 0.66;
                int w = 3;
                
                int g = etiquetaant *8;
                
                for (int i = g; i < g+8; i++) {
                    
                    [ram setObject:[[cache objectAtIndex:lineaescribir] objectAtIndex:w] atIndexedSubscript:i];
                    w++;
                }
                
            }
            
            
            mips += 0.67;
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:0]  atIndexedSubscript:2];
            
            
            
            
            
            
            
            int w = 3;
            
            
            for (int i = bloque*8; i < (bloque*8)+8; i++) {
                [[cache objectAtIndex:lineaescribir] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
            
            return [[[cache objectAtIndex:lineaescribir] objectAtIndex:palabra] intValue];
            
        }
        
    }
    
    if (tipo == 3) {
        int bloque = posicion/8;
        int conjunto = bloque%16;
        int etiqueta = bloque/16;
        int palabra = (posicion%8)+3;
        int lineaetiquetaconjunto = 0;
        int vias = 4;
        int linealeer = 0;
        int lineaescribir = 0;
        int etiquetaant = 0;
        bool etiquetaexiste = false;
        int ver = conjunto * 4;
        
        for (int i = ver; i < ver+4; i++) {
            if ([self etiquetassoniguales:i and:etiqueta]) {
                lineaetiquetaconjunto = i - ver;
                etiquetaexiste = true;
            }
        }
        
        linealeer = ver + lineaetiquetaconjunto;
        
        
        if (etiquetaexiste) {
            mips += 0.01;
            return [[[cache objectAtIndex:linealeer] objectAtIndex:palabra] intValue];
        } else {
            
            lineaescribir = [self proximalinea:conjunto and:vias] + ver;
            etiquetaant = [[[cache objectAtIndex:lineaescribir] objectAtIndex:0] intValue];
            
            if ([self modificado:lineaescribir]) {
                mips += 0.66;
                int w = 3;
                
                int g = (etiquetaant *128)+conjunto*8;
                
                for (int i = g; i < g+8; i++) {
                    [ram setObject:[[cache objectAtIndex:lineaescribir] objectAtIndex:w] atIndexedSubscript:i];
                    w++;
                }
                
            }
            
            
            mips += 0.67;
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:0]  atIndexedSubscript:2];
            
            
            int w = 3;
            
            
            for (int i = bloque*8; i < (bloque*8)+8; i++) {
                [[cache objectAtIndex:lineaescribir] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
            
            return [[[cache objectAtIndex:lineaescribir] objectAtIndex:palabra] intValue];
            
        }
        
    }
    
    return [[ram objectAtIndex:posicion] intValue];
    
}


- (void) escribirconposicion:(int)posicion contipo:(int)tipo yconvalor:(int)valor  {
    if (tipo == 0) {
        mips += 0.1;
        [ram setObject:[[NSNumber alloc] initWithInt:valor] atIndexedSubscript:posicion];
    }
    
    
    if (tipo == 1) {
        int bloque = posicion/8;
        int linea = bloque%64;
        int etiqueta = bloque/64;
        int palabra = (posicion%8)+3;
        
        
        int etiquetaAnt = [[[cache objectAtIndex:linea] objectAtIndex:0] intValue];
        
        
        if ([self valido:linea]) {
            if ([self etiquetassoniguales:linea and:etiqueta]) {
                mips += 0.01;
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            } else {
                if ([self modificado:linea]) {
                    mips += 0.66;
                    
                    int w = 3;
                    
                    int g = (etiquetaAnt*512)+(linea*8);
                    
                    for (int i = g; i < g+8; i++) {
                       [ram setObject:[[cache objectAtIndex:linea] objectAtIndex:w]  atIndexedSubscript:i];
                        w++;
                    }
                }
                
                mips += 0.67;
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
                [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
                
                int w = 3;
                for (int i = bloque*8; i < (bloque*8)+8; i++) {
                    [[cache objectAtIndex:linea] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                    w++;
                }
                
                
            }
        } else {
            mips += 0.67;
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            
            int w = 3;
            for (int i = bloque*8; i < (bloque*8)+8; i++) {
                [[cache objectAtIndex:linea] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
        }
        
        [[cache objectAtIndex:linea] setObject:[[NSNumber alloc] initWithInt:valor] atIndex:palabra];
    }
    
    
    
    if (tipo == 2) {
        int bloque = posicion/8;
        int conjunto = 0;
        int etiqueta = bloque;
        int palabra = (posicion%8)+3;
        int lineaetiquetaconjunto = 0;
        int vias = 64;
        int linealeer = 0;
        int lineaescribir = 0;
        int etiquetaant = 0;
        bool etiquetaexiste = false;
        int ver = conjunto * 64;
        
        for (int i = ver; i < ver+64; i++) {
            if ([self etiquetassoniguales:i and:etiqueta]) {
                lineaetiquetaconjunto = i - ver;
                etiquetaexiste = true;
            }
        }
        
        linealeer = ver + lineaetiquetaconjunto;
        
        
        if (etiquetaexiste) {
            mips += 0.01;
            
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:valor]  atIndexedSubscript:palabra];
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            
            
            
            
            

            
            
        } else {
            lineaescribir = [self proximalinea:conjunto and:vias]+ver;
            etiquetaant = [[[cache objectAtIndex:lineaescribir] objectAtIndex:0] intValue];
            
            if ([self modificado:lineaescribir]) {
                mips += 0.66;
                
                int w = 3;
                
                int g = (etiquetaant *8);
                
                for (int i = g; i < g+8; i++) {
                    [ram setObject:[[cache objectAtIndex:lineaescribir] objectAtIndex:w] atIndexedSubscript:i];
                    w++;
                }
            }
            
            mips += 0.67;
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            
            
            
            int w = 3;
            
            
            for (int i = bloque*8; i < (bloque *8)+8; i++) {
                [[cache objectAtIndex:lineaescribir] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
            
            
            
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:valor] atIndex:palabra];
            
        }
        
    }
    
    
    
    
    if (tipo == 3) {
        int bloque = posicion/8;
        int conjunto = bloque%16;
        int etiqueta = bloque/16;
        int palabra = (posicion%8)+3;
        int lineaetiquetaconjunto = 0;
        int vias = 4;
        int linealeer = 0;
        int lineaescribir = 0;
        int etiquetaant = 0;
        bool etiquetaexiste = false;
        int ver = conjunto * 4;
        
        for (int i = ver; i < ver+4; i++) {
            if ([self etiquetassoniguales:i and:etiqueta]) {
                lineaetiquetaconjunto = i - ver;
                etiquetaexiste = true;
            }
        }
        
        linealeer = ver + lineaetiquetaconjunto;
        
        
        if (etiquetaexiste) {
            mips += 0.01;
            
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:valor]  atIndexedSubscript:palabra];
            
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:linealeer] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            
            
        } else {
            lineaescribir = [self proximalinea:conjunto and:vias]+ver;
            etiquetaant = [[[cache objectAtIndex:lineaescribir] objectAtIndex:0] intValue];
            
            if ([self modificado:lineaescribir]) {
                mips += 0.66;
                
                int w = 3;
                
                int g = (etiquetaant *128) + (conjunto*8);
                
                for (int i = g; i < g+8; i++) {
                    [ram setObject:[[cache objectAtIndex:lineaescribir] objectAtIndex:w] atIndexedSubscript:i];
                    w++;
                }
            }
            
            mips += 0.67;
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:etiqueta]  atIndexedSubscript:0];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:1];
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:1]  atIndexedSubscript:2];
            
            
            int w = 3;
            
            
            for (int i = bloque*8; i < (bloque *8)+8; i++) {
                [[cache objectAtIndex:lineaescribir] setObject:[ram objectAtIndex:i] atIndexedSubscript:w];
                w++;
            }
            
            [[cache objectAtIndex:lineaescribir] setObject:[[NSNumber alloc] initWithInt:valor] atIndex:palabra];
            
        }
        
    }
    
    
}






#pragma mark start

- (void) startwithtype:(int)tipo {
    
    mips = 0;
        
    for (int i = 0; i<=4094; i++) {
        for (int j = i+1; j<=4095; j++) {
            
            
            if ( [self leerconposicion:i ycontipo:tipo]  > [self leerconposicion:j ycontipo:tipo])   {
                int temp = [self leerconposicion:i ycontipo:tipo] ;
                
                [self escribirconposicion:i contipo:tipo yconvalor: [self leerconposicion:j ycontipo:tipo]];
                [self escribirconposicion:j contipo:tipo yconvalor: temp];
            }
        }
    }
    
    NSLog(@"%f", mips);
    
}

@end
