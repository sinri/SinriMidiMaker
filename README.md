SinriMidiMaker
==============

A Midi File Maker For Amateur Musician and so on. Designed for Local Church Hymnal Service.

Midi is a good music media format, as it could be written without any professional device while any melody could be presented. Given the keyboard, tempo and note serials, the Sinri Midi Maker will do the next for you, to generate a Midi file.

# Usage #

## Properties ##

Midi file might be of 3 types, Single Trace, Synchronized Traces and Asynchronized Traces. To simplize the implementation, only Synchronized Traces type was implemented.

Default Settings have been included. However, you can still modify Midi Trace Name, Tempo, Time Signature, and Key Signature if needed. For details, view [Midi File Format Details](http://www.everstray.com/news/news.php?NEWS_NAME=20141004115454[Midi%20File%20Format%20Details]Everstray.log).

## Notes ##

The Note should match the following regular pattern.

    [b#]?[ABCDEFGabcdefg0](10|[0123456789])(\*(\.|1|2|3|4|8|16|32|64)(\*(([0123456789]+)|\.))?)?
    

Generally the note detail is consisted of three parts seperated by a star (*), first for Key, second for Type, and third for Length.

### Key ###

Key is not optional.

Any key on a standard piano keyboard could be represented by a code, in readable format such as "D4". If it should be a flat or sharp note, put a "b" or "#" before the normal note code, such as "bD4" and "#D4".

Commonly, C5 is linked to the middle C.

For rest, give a zero, i.e. "0".

### Type ###

Type is optional, default as 4, which means quarter note. The value for this field could be a number or a point ("."). 

**Number** Totally 1, 2, 3, 4, 8, 16, 32 and 64 are supported, to presenting the 1/x type note, i.e. one for a whole note, two for a half, etc.

**Point** Point means "plus half". When a point comes out here, comes out with one and a half quarter note. Note that if the Length is set, the affect is equals to number 4.

### Length ###

Type is optional, and only available when Type is set. Default value is 1, and the value could be any plus integer or a point. For example with a quarter note, length of 1 keeps it as long as a quarter, but length of 2 makes it as long as twice, equals to a half. A point would make the length of the target note as one and a half times of the set type in Type section.

## Sample ##

In the main.m in the project, a sapmle note serails of XB129 [Ode An die Freude].

    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 E4*. D4*8 D4*2 
    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 
    D4 D4 E4 C4 D4 E4*8 F4*8 E4 C4 D4 E4*8 F4*8 E4 D4 C4 D4 G3*2 
    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 
    
With the default settings, comes out with the following data for file.
    
    4d546864 00000006 00010002 01e04d54 726b0000 003d00ff 030ce980 89e69cac 313239e9 a69600ff 02105369 6e726920 4d696469 204d616b 657200ff 51030783 0000ff58 04040218 0800ff59 02000000 ff2f004d 54726b00 00023e00 ff200100 00b00a40 00c00100 90347883 60803400 00903478 83608034 00009035 78836080 35000090 37788360 80370000 90377883 60803700 00903578 83608035 00009034 78836080 34000090 32788360 80320000 90307883 60803000 00903078 83608030 00009032 78836080 32000090 34788360 80340000 90347885 50803400 00903278 81708032 00009032 78874080 32000090 34788360 80340000 90347883 60803400 00903578 83608035 00009037 78836080 37000090 37788360 80370000 90357883 60803500 00903478 83608034 00009032 78836080 32000090 30788360 80300000 90307883 60803000 00903278 83608032 00009034 78836080 34000090 32788550 80320000 90307881 70803000 00903078 87408030 00009032 78836080 32000090 32788360 80320000 90347883 60803400 00903078 83608030 00009032 78836080 32000090 34788170 80340000 90357881 70803500 00903478 83608034 00009030 78836080 30000090 32788360 80320000 90347881 70803400 00903578 81708035 00009034 78836080 34000090 32788360 80320000 90307883 60803000 00903278 83608032 0000902b 78874080 2b000090 34788360 80340000 90347883 60803400 00903578 83608035 00009037 78836080 37000090 37788360 80370000 90357883 60803500 00903478 83608034 00009032 78836080 32000090 30788360 80300000 90307883 60803000 00903278 83608032 00009034 78836080 34000090 32788550 80320000 90307881 70803000 00903078 87408030 0000ff2f 00