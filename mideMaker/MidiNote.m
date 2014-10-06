//
//  MidiNote.m
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "MidiNote.h"
#import "MidiDataHelper.h"


@implementation MidiNote

+(NSArray*)MidiNoteArrayMakerForChannel:(Byte)cn NumberedMusicialNotation:(NSString*)mmn{
    NSString * target=[mmn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray*array=[target componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray * ma=[[NSMutableArray alloc]init];
    
    Byte baseCode=60;//C5
    
    BOOL isInCycle=NO;
    NSMutableArray * cycle_ma=[[NSMutableArray alloc]init];
    
    for (NSString* mnote in array) {
        NSString * mn=[mnote stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![mn isEqualToString:@""] && ![mn isEqualToString:@"|"]){
//            NSLog(@"MN = %@",mn);
            
            if([mn hasPrefix:@"|:"]){
                isInCycle=YES;
                continue;
            }else if([mn hasPrefix:@":|"]){
                isInCycle=NO;
                [ma addObjectsFromArray:cycle_ma];
                [ma addObjectsFromArray:cycle_ma];
                cycle_ma=[[NSMutableArray alloc]init];
                if([mn hasSuffix:@"||"]){
                    break;
                }else{
                    continue;
                }
            }
            
            if([mn hasSuffix:@"||"]){
                break;
            }
            
            if ([mn hasPrefix:@"1="]) {
                if([mn length]>2){
                    
                    NSString*t2=[mn substringWithRange:NSMakeRange(2, 1)];
                    if([t2 isEqualToString:@"b"]){
                        //flat
                        baseCode-=1;
                    }else if([t2 isEqualToString:@"#"]){
                        //sharp
                        baseCode+=1;
                    }
                    if([mn length]>3){
                        t2=[mn substringWithRange:NSMakeRange(3, 1)];
                    }
                    if([t2 isEqualToString:@"C"] || [t2 isEqualToString:@"c"]){
                        baseCode+=0;
                    }else if([t2 isEqualToString:@"D"] || [t2 isEqualToString:@"d"]){
                        baseCode+=2;
                    }else if([t2 isEqualToString:@"E"] || [t2 isEqualToString:@"e"]){
                        baseCode+=4;
                    }else if([t2 isEqualToString:@"F"] || [t2 isEqualToString:@"f"]){
                        baseCode+=5;
                    }else if([t2 isEqualToString:@"G"] || [t2 isEqualToString:@"g"]){
                        baseCode+=7;
                    }else if([t2 isEqualToString:@"A"] || [t2 isEqualToString:@"a"]){
                        baseCode+=9;
                    }else if([t2 isEqualToString:@"B"] || [t2 isEqualToString:@"b"]){
                        baseCode+=11;
                    }
                }
            }else{
                Byte code=baseCode;
                unsigned int type=4;
                unsigned int len=1;
                NSArray*charArray=[MidiDataHelper charArrayFromString:mn];
                int state=-1;
                for (NSString*onechar in charArray) {
                    if(state==-1){
                        if([onechar isEqualToString:@"-"]){
                            code-=12;
                        }else if([onechar isEqualToString:@"+"]){
                            code+=12;
                        }else{
                            state=0;
                        }
                    }
                    if(state==0){
                        if([onechar isEqualToString:@"b"]){
                            code-=1;
                        }else if([onechar isEqualToString:@"#"]){
                            code+=1;
                        }else if([onechar isEqualToString:@"0"]){
                            code=0xFF;
                        }else if([onechar isEqualToString:@"1"]){
                            code+=0;
                        }else if([onechar isEqualToString:@"2"]){
                            code+=2;
                        }else if([onechar isEqualToString:@"3"]){
                            code+=4;
                        }else if([onechar isEqualToString:@"4"]){
                            code+=5;
                        }else if([onechar isEqualToString:@"5"]){
                            code+=7;
                        }else if([onechar isEqualToString:@"6"]){
                            code+=9;
                        }else if([onechar isEqualToString:@"7"]){
                            code+=11;
                        }else{
                            state=1;
                        }
                    }
                    if(state==1){
                        if([onechar isEqualToString:@"_"]){
                            type<<=1;
                        }else if([onechar isEqualToString:@"-"]){
                            len+=1;
                        }else if([onechar isEqualToString:@"="]){
                            type=3;
                            len=1;
                        }else if([onechar isEqualToString:@"."]){
                            type<<=1;
                            len*=3;
                        }
                    }
                }
                MidiNote * thenote=[[MidiNote alloc]initWithCode:code Type:type Length:len Channel:cn];
                if(isInCycle){
                    [cycle_ma addObject:thenote];
//                    NSLog(@"add in cycle: %@",mn);
                }else{
                    [ma addObject:thenote];
//                    NSLog(@"add in main: %@",mn);
                }
            }  
        }
    }
    
    return ma;
}

-(id)initWithCode:(Byte)code Type:(unsigned int)type Length:(unsigned int)len Channel:(Byte)channelNo{
    self=[super init];
    if(self){
        noteCode=code;
        noteType=type;
        noteLength=len;
        _channelNo=channelNo;
    }
    return self;
}

+(NSArray*)MidiNoteArrayMaker:(NSArray*)noteDetailArray{
    return [MidiNote MidiNoteArrayMaker:noteDetailArray ofChannel:0];
}

+(NSArray*)MidiNoteArrayMaker:(NSArray*)noteDetailArray ofChannel:(Byte)channelNo{
    NSMutableArray * ma=[[NSMutableArray alloc]init];
    if(noteDetailArray && [noteDetailArray count]>0){
        for (NSString* noteDetail in noteDetailArray) {
            
            NSString * target=[noteDetail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSError* error=nil;
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"[b#]?[ABCDEFGabcdefg0](10|[0123456789])(\\*(\\.|1|2|3|4|8|16|32|64)(\\*(([0123456789]+)|\\.))?)?"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:&error];
            
            NSArray*array=[regex matchesInString:target options:(NSMatchingReportCompletion) range:NSMakeRange(0,[target length]) ];
            
            if(array && [array count]>0){
                MidiNote * mn=[[MidiNote alloc]initWithDetail:target withChannelNo:channelNo];
                [ma addObject:mn];
            }
        }
    }
    return ma;
}

-(id)initWithDetail:(NSString*)detail{
    self=[super init];
    if(self){
        [self setWithDetail:detail];
        _channelNo=0;
    }
    return self;
}
-(id)initWithDetail:(NSString*)detail withChannelNo:(Byte)cno{
    self=[super init];
    if(self){
        [self setWithDetail:detail withChannelNo:cno];
    }
    return self;
}
-(void)setWithDetail:(NSString*)detail withChannelNo:(Byte)cno{
    // (0|[b#][ABCDEFG][0-10])*[1|2|3|4|8|16|32]
    //Try to separate the detail string by *
    NSArray* lr=[detail componentsSeparatedByString:@"*"];
    if(lr){
        if([lr count]>=1){
            NSString * l=[lr objectAtIndex:0];
            if(!l || [l hasPrefix:@"0"] || [l rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFG"]].location==NSNotFound){
                //rest
                noteCode=0xFF;
            }else{
                NSArray * chars=[MidiDataHelper charArrayFromString:l];
//                NSLog(@"chars=%@",chars);
                if(chars){
                    //non rest
                    int v=0;
                    int vv=0;
                    for (int i=0; i<[chars count]; i++) {
                        NSString*s=[chars objectAtIndex:i];
                        if([s isEqualToString:@"b"]){
                            v-=1;
                        }else if([s isEqualToString:@"#"]){
                            v+=1;
                        }else if([s isEqualToString:@"C"]||[s isEqualToString:@"c"]){
                            v+=0;
                        }else if([s isEqualToString:@"D"]||[s isEqualToString:@"d"]){
                            v+=2;
                        }else if([s isEqualToString:@"E"]||[s isEqualToString:@"e"]){
                            v+=4;
                        }else if([s isEqualToString:@"F"]||[s isEqualToString:@"f"]){
                            v+=5;
                        }else if([s isEqualToString:@"G"]||[s isEqualToString:@"g"]){
                            v+=7;
                        }else if([s isEqualToString:@"A"]||[s isEqualToString:@"a"]){
                            v+=9;
                        }else if([s isEqualToString:@"B"]||[s isEqualToString:@"b"]){
                            v+=11;
                        }else if([s rangeOfCharacterFromSet:([NSCharacterSet characterSetWithCharactersInString:@"0123456789"])].location!=NSNotFound){
//                            NSLog(@"s=%@ s.v=%d",s,[s intValue]);
                            vv=vv*10+[s intValue];
                        }
                    }
//                    NSLog(@"v=%d vv=%d",v,vv);
                    noteCode=(v+(vv)*12)&0x7F;
                    
                }else{
                    //rest
                    noteCode=0xFF;
                }
            }
        }
        if([lr count]>=2){
            NSString * r=[lr objectAtIndex:1];
            if([lr count]==2 && [r isEqualToString:@"."]){
                noteType=8;
                noteLength=3;
            }else{
                noteType=[r intValue];
                noteLength=1;
            }
        }else{
            //default as a quareter
            noteType=4;// 1/lr, 4 for quarter-note. 1,2,3,4,8,16,32
            noteLength=1;// 1 or 1-, 1 for 1 and 2 for 1-
        }
        if([lr count]>=3){
            NSString * r=[lr objectAtIndex:2];
            if([r isEqualToString:@"."]){
                noteType*=2;
                noteLength=3;
            }else{
                noteLength=[r intValue];
            }
        }
        
    }else{
        //REST as a quareter note
        noteCode=0xFF;
        noteType=4;// 1/lr, 4 for quarter-note. 1,2,3,4,8,16,32
        noteLength=1;// 1 or 1-, 1 for 1 and 2 for 1-
    }
    
//    NSLog(@"SET NOTE : KEY %d, Type %d, Length %d",noteCode,noteType,noteLength);
}
-(void)setWithDetail:(NSString*)detail{
    [self setWithDetail:detail withChannelNo:0];
}



-(NSData*)dataForNote{
    NSMutableData * data=[[NSMutableData alloc]init];
    
    if(noteCode==0xFF){
        //REST
        //Time delta
        NSUInteger dt=STANDARD_TICKS_FOR_QUARTER_NOTE*4*noteLength/noteType;
//        NSLog(@"dt=%lu => %@",(unsigned long)dt,[MidiDataHelper dataFromVariableLengthData:dt]);
        [data appendData:[MidiDataHelper dataFromVariableLengthData:dt]];
        
        //note off
        Byte offCmd=0x80 | (0x0F & _channelNo);
        Byte noteOff[]={offCmd,0x00,0x00};
//        NSLog(@"Note off: %@",[MidiDataHelper dataFromByteArray:noteOff forLength:3]);
        [data appendData:[MidiDataHelper dataFromByteArray:noteOff forLength:3]];
    }else{
    //Note on
    Byte onCmd=0x90 | (0x0F & _channelNo);
    Byte noteOn[]={0x00,onCmd,noteCode,STANDARD_VELOCITY_FOR_KEY};
//    NSLog(@"Note on: %@",[MidiDataHelper dataFromByteArray:noteOn forLength:4]);
    [data appendData:[MidiDataHelper dataFromByteArray:noteOn forLength:4]];
    
    //Time delta
    NSUInteger dt=STANDARD_TICKS_FOR_QUARTER_NOTE*4*noteLength/noteType;
//    NSLog(@"type=%d length=%d  dt=%lu => %@",noteType,noteLength,(unsigned long)dt,[MidiDataHelper dataFromVariableLengthData:dt]);
    [data appendData:[MidiDataHelper dataFromVariableLengthData:dt]];
    
    //note off
    Byte offCmd=0x80 | (0x0F & _channelNo);
    Byte noteOff[]={offCmd,noteCode,0x00};
//    NSLog(@"Note off: %@",[MidiDataHelper dataFromByteArray:noteOff forLength:3]);
    [data appendData:[MidiDataHelper dataFromByteArray:noteOff forLength:3]];
    }
    return data;
}

@end
