//
//  MidiWorker.h
//  mideMaker
//
//  Created by 倪 李俊 on 14-10-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//
//  A simple implement, only support sync multi
//

#import <Foundation/Foundation.h>

#import "MidiTrace.h"


#define SUPPORT_MidiTraceSingle NO
#define SUPPORT_MidiTraceAsyncMulti NO

typedef enum MIDI_TRACE_FORMAT_TYPE {
    MidiTraceSingle=0, //Not implemented yet
    MidiTraceSyncMulti=1,
    MidiTraceAsyncMulti=2 //Not implemented yet
} MIDI_TRACE_FORMAT_TYPE;

typedef enum MIDI_TRACE_KEY_SIGNATURE {
    //Major
    Major_Cb=93,
    Major_Gb=94,
    Major_Db=95,
    Major_Ab=96,
    Major_Eb=97,
    Major_Bb=98,
    Major_F=99,
    Major_C=100,
    Major_G=101,
    Major_D=102,
    Major_A=103,
    Major_E=104,
    Major_B=105,
    Major_Fs=106,
    Major_Cs=107,
    //Minor
    Minor_Ab=193,
    Minor_Eb=194,
    Minor_Bb=195,
    Minor_F=196,
    Minor_C=197,
    Minor_G=198,
    Minor_D=199,
    Minor_A=200,
    Minor_E=201,
    Minor_B=202,
    Minor_Fs=203,
    Minor_Cs=204,
    Minor_Gs=205,
    Minor_Ds=206,
    Minor_As=207
} MIDI_TRACE_KEY_SIGNATURE;

@interface MidiWorker : NSObject

//HEADER

@property MIDI_TRACE_FORMAT_TYPE traceFormatType;//default as MidiTraceSyncMulti

@property NSMutableArray * traceArray;

/**
 The first bit is 0; the following 15 bits describe the time division in ticks per beat. Ticks per beat translate to the number of clock ticks or track delta positions (described in the Track Chunk section) in every quarter note of music. Common values range from 48 to 960, although newer sequencers go far beyond this range to ease working with MIDI and digital audio together.
 Default as 480=0x01e0
 **/
@property unsigned int TicksPerBeat;

//INFO TRACE
/**
 Name of the first trace, which would be used for the whole midi file in Mode 1(SyncMulti)
 **/
@property NSString * name;
/**
 It should be edited. To use this library without modified, you must declare the copyright signature as Sinri Midi Maker.
 **/
@property (readonly) NSString * copyright;

/**
 microseconds per quarter-note which is encoded in three bytes
 0x078300 as default
 **/
@property NSUInteger tempo;

/**
 This meta event is used to set a sequences time signature. The time signature defined with 4 bytes, a numerator, a denominator, a metronome pulse and number of 32nd notes per MIDI quarter-note. 
 The numerator is specified as a literal value, but the denominator is specified as (get ready) the value to which the power of 2 must be raised to equal the number of subdivisions per whole note. For example, a value of 0 means a whole note because 2 to the power of 0 is 1 (whole note), a value of 1 means a half-note because 2 to the power of 1 is 2 (half-note), and so on.
 The metronome pulse specifies how often the metronome should click in terms of the number of clock signals per click, which come at a rate of 24 per quarter-note. For example, a value of 24 would mean to click once every quarter-note (beat) and a value of 48 would mean to click once every half-note (2 beats). 
 And finally, the fourth byte specifies the number of 32nd notes per 24 MIDI clock signals. This value is usually 8 because there are usually 8 32nd notes in a quarter-note. At least one Time Signature Event should appear in the first track chunk (or all track chunks in a Type 2 file) before any non-zero delta time events. If one is not specified 4/4, 24, 8 should be assumed.
 中文说明：
 numerator 是计数分子
 denominator 表示了计数目标为(2^d)分之一音符，拍子记号：n/(2^d)
 metronome 节拍器 24表示每四分音符一下，48表示每二分音符一下。
 32nd 每24个MIDI的时钟周期（即一般的四分音符周期）有多少个32分音符
 **/
@property Byte timeSignatureNumerator;//default as 4
@property Byte timeSignatureDenominator;//default as 2 (2^2=4)
@property Byte timeSignatureMetronome;//default as 24
@property Byte timeSignature32ndCount;//default as 8

/**
 default as Major_C
 **/
@property MIDI_TRACE_KEY_SIGNATURE keySignature;

-(NSData*)buildMidiFileData;

@end
