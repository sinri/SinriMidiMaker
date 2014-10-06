//
//  MidiWorker.m
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "MidiWorker.h"
#import "MidiDataHelper.h"


@implementation MidiWorker

-(id)init{
    self=[super init];
    if(self){
        _traceFormatType=MidiTraceSyncMulti;
        _traceArray=[[NSMutableArray alloc]init];
        _TicksPerBeat= STANDARD_TICKS_FOR_QUARTER_NOTE;//480;
        
        _name=@"Noname";
        _copyright=@"Sinri Midi Maker";
        
        _tempo=0x078300;
        
        _timeSignatureNumerator=4;
        _timeSignatureDenominator=2;
        _timeSignatureMetronome=24;
        _timeSignature32ndCount=8;
        
        _keySignature=Major_C;
    }
    return self;
}

-(NSData*)buildMidiFileData{
    NSMutableData * data=[[NSMutableData alloc]init];
    
    NSData * headerChunk =[self makeHeaderChunk];
    if(!headerChunk){
        NSLog(@"headerChunk made as nil");
        return nil;
    }
    [data appendData:headerChunk];
    
    NSData * infoTrace=[self makeInfoTraceChunk];
    if(!infoTrace){
        NSLog(@"infoTrace made as nil");
        return nil;
    }
    [data appendData:infoTrace];
    
    return data;
}

-(NSData*)makeHeaderChunk{
    NSMutableData * data=[[NSMutableData alloc]init];
    
    Byte byte_chunk_header_0[] = {0x4D,0x54,0x68,0x64,0x00,0x00,0x00,0x06};
    [data appendData:[self dataFromByteArray:byte_chunk_header_0 forLength:8]];
    switch (_traceFormatType) {
        case MidiTraceSingle:
            if(SUPPORT_MidiTraceSingle){
                Byte byte_chunk_header_1[]={0x00,0x00};
                [data appendData:[self dataFromByteArray:byte_chunk_header_1 forLength:2]];
                
                if(!_traceArray || [_traceArray count]!=1){
                    NSLog(@"makeHeaderChunk failed as Trace Array Count Error");
                    return nil;
                }else{
                    Byte hc=([_traceArray count] & 0xFF00)>>8;
                    Byte lc=([_traceArray count] & 0xFF);
                    Byte byte_chunk_header_2[]={hc,lc};
                    [data appendData:[self dataFromByteArray:byte_chunk_header_2 forLength:2]];
                }
                
                Byte hc=(_TicksPerBeat & 0xFF00)>>8;
                Byte lc=(_TicksPerBeat & 0xFF);
                Byte byte_chunk_header_3[]={hc,lc};
                [data appendData:[self dataFromByteArray:byte_chunk_header_3 forLength:2]];
            }else{
                NSLog(@"makeHeaderChunk trace type unsupported");
                return nil;
            }
            break;
        case MidiTraceAsyncMulti:
            if(SUPPORT_MidiTraceAsyncMulti){
                Byte byte_chunk_header_1[]={0x00,0x02};
                [data appendData:[self dataFromByteArray:byte_chunk_header_1 forLength:2]];
                
               
                    if(!_traceArray || [_traceArray count]<1){
                        NSLog(@"makeHeaderChunk failed as Trace Array Count Error");
                        return nil;
                    }else{
                        Byte hc=([_traceArray count] & 0xFF00)>>8;
                        Byte lc=([_traceArray count] & 0xFF);
                        Byte byte_chunk_header_2[]={hc,lc};
                        [data appendData:[self dataFromByteArray:byte_chunk_header_2 forLength:2]];
                    }
                
                
                Byte hc=(_TicksPerBeat & 0xFF00)>>8;
                Byte lc=(_TicksPerBeat & 0xFF);
                Byte byte_chunk_header_3[]={hc,lc};
                [data appendData:[self dataFromByteArray:byte_chunk_header_3 forLength:2]];
            }else{
                NSLog(@"makeHeaderChunk trace type unsupported");
                return nil;
            }
            break;
        default:
        {
            Byte byte_chunk_header_1[]={0x00,0x01};
            [data appendData:[self dataFromByteArray:byte_chunk_header_1 forLength:2]];
            
            if(!_traceArray || [_traceArray count]!=1){
                NSLog(@"makeHeaderChunk failed as Trace Array Count Error");
                return nil;
            }else{
                Byte byte_chunk_header_2[]={0x00,0x02};
                [data appendData:[self dataFromByteArray:byte_chunk_header_2 forLength:2]];
            }
            
            Byte hc=(_TicksPerBeat & 0xFF00)>>8;
            Byte lc=(_TicksPerBeat & 0xFF);
            Byte byte_chunk_header_3[]={hc,lc};
            [data appendData:[self dataFromByteArray:byte_chunk_header_3 forLength:2]];
        }
            break;
    }
    
    return data;
}

-(NSData*)makeInfoTraceChunk{
    NSMutableData * data=[[NSMutableData alloc]init];
    
    Byte byte_chunk_header_0[] = {0x4D,0x54,0x72,0x6B};
    [data appendData:[self dataFromByteArray:byte_chunk_header_0 forLength:4]];
    
    NSMutableData * body=[[NSMutableData alloc]init];
    //Name
    Byte byte_chunk_header_1[] = {0x00,0xFF,0x03};
    if(!_name || [_name isEqualToString:@""]){
        _name=@"Noname";
    }
    [body appendData:[self dataFromByteArray:byte_chunk_header_1 forLength:3]];
    [body appendData:[self dataFromVariableLengthData:[_name lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    const char * name_chars=[_name cStringUsingEncoding:NSUTF8StringEncoding];
    [body appendBytes:name_chars length:[_name lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    //Copyright
    Byte byte_chunk_header_2[] = {0x00,0xFF,0x02};
    if(!_copyright || [_copyright isEqualToString:@""]){
        _copyright=@"Copyright 2014 SinriMidiMaker";
    }
    [body appendData:[self dataFromByteArray:byte_chunk_header_2 forLength:3]];
    [body appendData:[self dataFromVariableLengthData:[_copyright lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    const char * copyright_chars=[_copyright cStringUsingEncoding:NSUTF8StringEncoding];
    [body appendBytes:copyright_chars length:[_copyright lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];

    
    //Tempo
    Byte t0=(_tempo>>16)&0xFF;
    Byte t1=(_tempo>>8)&0xFF;
    Byte t2=(_tempo)&0xFF;
    Byte byte_chunk_header_3[] = {0x00,0xFF,0x51,0x03,t0,t1,t2};
    [body appendData:[self dataFromByteArray:byte_chunk_header_3 forLength:7]];
    
    //timeSignature
    Byte byte_chunk_header_4[] = {0x00,0xFF,0x58,0x04,_timeSignatureNumerator,_timeSignatureDenominator,_timeSignatureMetronome,_timeSignature32ndCount};
    [body appendData:[self dataFromByteArray:byte_chunk_header_4 forLength:8]];
    
    //keySignature
    Byte byte_chunk_header_5[] = {0x00,0xFF,0x59,0x02};
    [body appendData:[self dataFromByteArray:byte_chunk_header_5 forLength:4]];
    [body appendData:[self dataForKeySignature:_keySignature]];
    
    //Put up
    NSUInteger body_len=[body length]+4;
    Byte l0=(body_len & 0xFF000000)>>24;
    Byte l1=(body_len & 0xFF0000)>>16;
    Byte l2=(body_len & 0xFF00)>>8;
    Byte l3=(body_len & 0xFF);
    Byte byte_chunk_header_11[] = {l0,l1,l2,l3};
    [data appendData:[self dataFromByteArray:byte_chunk_header_11 forLength:4]];
    
    [data appendData:body];
    
    //Owari
    Byte byte_chunk_header_12[] = {0x00,0xFF,0x2F,0x00};
    [data appendData:[self dataFromByteArray:byte_chunk_header_12 forLength:4]];
    
    if(_traceArray && [_traceArray count]>0){
        for (MidiTrace * trace in _traceArray) {
            [data appendData:[trace dataForTrace]];
        }
    }
    
    return data;
}



-(NSData*)dataFromByteArray:(Byte[])bytes forLength:(int)length{
    return [MidiDataHelper dataFromByteArray:bytes forLength:length];
}

-(NSData*)dataFromVariableLengthData:(NSUInteger)v{
    return [MidiDataHelper dataFromVariableLengthData:v];
}

-(NSData *)dataForKeySignature:(MIDI_TRACE_KEY_SIGNATURE)ks{
    Byte l1=(ks>150)?1:0;
    Byte l0=ks-(100+100*l1);
    Byte l[]={l0,l1};
//    NSLog(@"dataForKeySignature=%d data=%@",ks,[self dataFromByteArray:l forLength:2]);
    return [self dataFromByteArray:l forLength:2];
}


@end
