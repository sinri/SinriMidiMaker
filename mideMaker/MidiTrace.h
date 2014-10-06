//
//  MidiTrace.h
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MidiNote.h"

@interface MidiTrace : NSObject
@property Byte channelNo;//0-15
@property Byte instrumentNo;//0-127
@property NSMutableArray * noteArray;


-(NSData*)dataForTrace;
@end
