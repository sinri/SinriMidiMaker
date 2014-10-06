//
//  main.m
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidiWorker.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, Midi!");
        
        MidiWorker * mw=[[MidiWorker alloc]init];
        
        //Default Settings
        //Name
        [mw setName:@"选本129首"];
        //Tempo
        [mw setTempo:0x078300];
        //Time Signature
        [mw setTimeSignatureNumerator:4];
        [mw setTimeSignatureDenominator:2];
        [mw setTimeSignatureMetronome:24];
        [mw setTimeSignature32ndCount:8];
        //Key Signature
        [mw setKeySignature:Major_C];
        
        MidiTrace * mt=[[MidiTrace alloc]init];
        
        NSString*MidiNoteSerials=@"E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 E4*. D4*8 D4*2 \
        E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 \
        D4 D4 E4 C4 D4 E4*8 F4*8 E4 C4 D4 E4*8 F4*8 E4 D4 C4 D4 G3*2 \
        E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 ";
        MidiNoteSerials=[MidiNoteSerials stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [mt setNoteArray:[[MidiNote MidiNoteArrayMaker:[MidiNoteSerials componentsSeparatedByCharactersInSet:([NSCharacterSet whitespaceAndNewlineCharacterSet])]]mutableCopy]];

        [mw.traceArray addObject:mt];
        
        
        NSData * filedata=[mw buildMidiFileData];
        
        NSLog(@"FileData START");
        NSLog(@"%@",filedata);
        NSLog(@"FileData END");
        
        BOOL done=[filedata writeToFile:@"test.mid" atomically:YES];
        NSLog(@"written=%d",done);
    }
    return 0;
}

