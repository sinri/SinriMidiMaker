//
//  MidiTrace.m
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "MidiTrace.h"

#import "MidiDataHelper.h"


@implementation MidiTrace

-(id)init{
    self=[super init];
    if(self){
        _channelNo=0;
        _instrumentNo=1;
        _noteArray=[[NSMutableArray alloc]init];
    }
    return self;
}

-(NSData*)dataForTrace{
    NSMutableData * data=[[NSMutableData alloc]init];
    
    Byte byte_chunk_header_0[] = {0x4D,0x54,0x72,0x6B};
    [data appendData:[MidiDataHelper dataFromByteArray:byte_chunk_header_0 forLength:4]];
    
    NSMutableData * body=[[NSMutableData alloc]init];
    
    //Set Channal
    Byte channalBytes[]={0x00,0xFF,0x20,0x01,_channelNo};
    [body appendData:[MidiDataHelper dataFromByteArray:channalBytes forLength:5]];
    
    //Controller, not implement now
    Byte controllerBytes[]={0x00,0xB0,0x0A,0x40};
    [body appendData:[MidiDataHelper dataFromByteArray:controllerBytes forLength:4]];
    
    //program or instrument
    Byte programBytes[]={0x00,0xC0,_instrumentNo};
    [body appendData:[MidiDataHelper dataFromByteArray:programBytes forLength:3]];
    
    if(_noteArray && [_noteArray count]>0){
        for (MidiNote * note in _noteArray) {
            [body appendData:[note dataForNote]];
        }
    }
    
    //Put up
    NSUInteger body_len=[body length]+4;
    Byte l0=(body_len & 0xFF000000)>>24;
    Byte l1=(body_len & 0xFF0000)>>16;
    Byte l2=(body_len & 0xFF00)>>8;
    Byte l3=(body_len & 0xFF);
    Byte byte_chunk_header_11[] = {l0,l1,l2,l3};
    [data appendData:[MidiDataHelper dataFromByteArray:byte_chunk_header_11 forLength:4]];
    
    [data appendData:body];
    
    //Owari
    Byte byte_chunk_header_12[] = {0x00,0xFF,0x2F,0x00};
    [data appendData:[MidiDataHelper dataFromByteArray:byte_chunk_header_12 forLength:4]];
    
    return data;
}
@end
