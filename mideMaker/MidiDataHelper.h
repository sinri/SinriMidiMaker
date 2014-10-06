//
//  MidiDataHelper.h
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MidiDataHelper : NSObject

+(NSData*)dataFromByteArray:(Byte[])bytes forLength:(int)length;
+(NSData*)dataFromVariableLengthData:(NSUInteger)v;
+(NSArray*)charArrayFromString:(NSString*)str;
@end
