//
//  MidiNote.h
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STANDARD_TICKS_FOR_QUARTER_NOTE 480
#define STANDARD_VELOCITY_FOR_KEY 0x78

@interface MidiNote : NSObject{
    Byte noteCode;//0-127 is common, 0xff is rest
    unsigned int noteType;// 1/lr, 4 for quarter-note. 1,2,3,4,8,16,32;
    unsigned int noteLength;// 1 or 1-, 1 for 1 and 2 for 1-
    //Nagasa ha , STANDARD_TICKS_FOR_QUARTER_NOTE*4/noteType*noteLength
}
@property Byte channelNo;

+(NSArray*)MidiNoteArrayMaker:(NSArray*)noteDetailArray;
+(NSArray*)MidiNoteArrayMaker:(NSArray*)noteDetailArray ofChannel:(Byte)channelNo;

-(id)initWithDetail:(NSString*)detail;
-(void)setWithDetail:(NSString*)detail;

-(id)initWithDetail:(NSString*)detail withChannelNo:(Byte)cno;
-(void)setWithDetail:(NSString*)detail withChannelNo:(Byte)cno;

-(NSData*)dataForNote;
@end
