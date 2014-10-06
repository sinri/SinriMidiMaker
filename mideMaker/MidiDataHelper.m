//
//  MidiDataHelper.m
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "MidiDataHelper.h"

@implementation MidiDataHelper
+(NSData*)dataFromByteArray:(Byte[])bytes forLength:(int)length{
    NSData *adata = [[NSData alloc] initWithBytes:bytes length:length];
    return adata;
}
+(NSData*)dataFromVariableLengthData:(NSUInteger)v{
    if(v>(0x0FFFFFFF)){
        return nil;
    }else{
        NSMutableData * data=[[NSMutableData alloc]init];
        Byte l3=(v & 0x7F) | 0x00;
        Byte l2=((v>>7) & 0x7F) | 0x80;
        Byte l1=((v>>14) & 0x7F) | 0x80;
        Byte l0=((v>>21) & 0x7F) | 0x80;
        Byte ll3[]={l3};
        Byte ll2[]={l2,l3};
        Byte ll1[]={l1,l2,l3};
        Byte ll0[]={l0,l1,l2,l3};
        if(l0>0x80){
            [data appendBytes:ll0 length:1];
        }
        if(l1>0x80){
            [data appendBytes:ll1 length:1];
        }
        if(l2>0x80){
            [data appendBytes:ll2 length:1];
        }
        if(l3>=0){
            [data appendBytes:ll3 length:1];
        }
        return data;
    }
}
+(NSArray*)charArrayFromString:(NSString*)str{
    if(str){
        NSMutableArray * ma=[[NSMutableArray alloc]init];
        for(int i=0;i<[str length];i++){
            unichar c=[str characterAtIndex:i];
            unichar cc[]={c};
            NSString * cs=[NSString stringWithCharacters:cc length:1];
            [ma addObject:cs];
        }
        return ma;
    }else{
        return nil;
    }
}

@end
