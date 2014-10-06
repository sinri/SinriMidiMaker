SinriMidiMaker
==============

A Midi File Maker For Amateur Musician and so on. Designed for Local Church Hymnal Service.

Midi is a good music media format, as it could be written without any professional device while any melody could be presented. Given the keyboard, tempo and note serials, the Sinri Midi Maker will do the next for you, to generate a Midi file.

It is made for Objective-C platform on OS X and iOS, relesed under GNU GPL v3.0. It could be used with Fundation Library directly, by including the h and m files except main. I think it is convinent to turn it into pure C or C++, or any other languages :P

# Usage #

## Properties ##

Midi file might be of 3 types, Single Trace, Synchronized Traces and Asynchronized Traces. To simplize the implementation, only Synchronized Traces type was implemented.

Default Settings have been included. However, you can still modify Midi Trace Name, Tempo, Time Signature, and Key Signature if needed. For details, view [Midi File Format Details](http://www.everstray.com/news/news.php?NEWS_NAME=20141004115454[Midi%20File%20Format%20Details]Everstray.log).

## Numbered Musical Notation ##

You can use a string of numbers and symbols to describe a score. 

Btw, it is the real object of mine to make up the things. The hymn book used by Local Church in China Mainland is generally printed with Numbered Musical Notation. A great sample is ``` XB (选本诗歌) ```.

### Key ###

Key is optional for the display of the scores, in the format of ```1=[b#][CDEFGAB]```. Default is C5.

### Bar and Cycle and End ###

Use ``` bar (|) ``` to make the notes clear for reading.

Use ``` Cycle Start (|:) ``` to begin a cycle, and use ``` Cycle End (:|) ``` to end a cycle. The note serials included in the cycle would be repeated once more.

Use ``` Score End (||) ``` to end the score, no matter whether any more characters after it. If the Score End is also the Cycle End, use ``` Cycle-Score End (:||) ``` to save time.

### Note ###

The note format is ``` (0|[\-\+]*[b#]?[1234567])[\-_]*.?  ```.

Zero is for rest.
One is equal to the set Key, from 2 to 7 is floating with their relative location on piano keyboard, the same rule for flat or sharp. One plus and minus before the number is for lifting or falling one octave.

The ``` underline (_) ``` is to half the note length, while the ``` hyphen (-) ``` is to twice the length of the note. The ``` dot (.) ``` is make the length once and a half. For one third of note, use ``` equal (=) ```.

Give some samples.

When ``` 1=C ``` was set,

 ``` 1 ``` is C5, ``` 2 ``` is D5, ``` b2 ``` is bD5, they are all quarter of note.
 
And ``` 1_ ``` is one eighth of note, ``` 1- ``` is one second of note. 

For one third of note, use ``` 1= ```. 

## Standard Notation ##

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

## Sample 1: Numbered ##

In the main.m in the project, a sapmle note serails of XB129 [Ode An die Freude].

    1=C 
    3 3 4 5 | 5 4 3 2 | 1 1 2 3 | 3. 2_ 2- | 
    3 3 4 5 | 5 4 3 2 | 1 1 2 3 | 2. 1_ 1- | 
    2 2 3 1 | 2 3_ 4_ 3 1 | 2 3_ 4_ 3 2 | 1 2 -5- | 
    3 3 4 5 | 5 4 3 2 | 1 1 2 3 | 2. 1_ 1- | 
    |: 1 3 5 1 :||

With the default settings, comes out with the following data for file.

    4d546864 00000006 00010002 01e04d54 726b0000 003d00ff 030ce980 89e69cac 313239e9 a69600ff 02105369 6e726920 4d696469 204d616b 657200ff 51030783 0000ff58 04040218 0800ff59 02000000 ff2f004d 54726b00 00028600 ff200100 00b00a40 00c00100 90407883 60804000 00904078 83608040 00009041 78836080 41000090 43788360 80430000 90437883 60804300 00904178 83608041 00009040 78836080 40000090 3e788360 803e0000 903c7883 60803c00 00903c78 8360803c 0000903e 78836080 3e000090 40788360 80400000 90407885 50804000 00903e78 8170803e 0000903e 78874080 3e000090 40788360 80400000 90407883 60804000 00904178 83608041 00009043 78836080 43000090 43788360 80430000 90417883 60804100 00904078 83608040 0000903e 78836080 3e000090 3c788360 803c0000 903c7883 60803c00 00903e78 8360803e 00009040 78836080 40000090 3e788550 803e0000 903c7881 70803c00 00903c78 8740803c 0000903e 78836080 3e000090 3e788360 803e0000 90407883 60804000 00903c78 8360803c 0000903e 78836080 3e000090 40788170 80400000 90417881 70804100 00904078 83608040 0000903c 78836080 3c000090 3e788360 803e0000 90407881 70804000 00904178 81708041 00009040 78836080 40000090 3e788360 803e0000 903c7883 60803c00 00903e78 8360803e 00009037 78874080 37000090 40788360 80400000 90407883 60804000 00904178 83608041 00009043 78836080 43000090 43788360 80430000 90417883 60804100 00904078 83608040 0000903e 78836080 3e000090 3c788360 803c0000 903c7883 60803c00 00903e78 8360803e 00009040 78836080 40000090 3e788550 803e0000 903c7881 70803c00 00903c78 8740803c 0000903c 78836080 3c000090 40788360 80400000 90437883 60804300 00903c78 8360803c 0000903c 78836080 3c000090 40788360 80400000 90437883 60804300 00903c78 8360803c 0000ff2f 00

## Sample 2: Standard ##

In the main.m in the project, a sapmle note serails of XB129 [Ode An die Freude].

    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 E4*. D4*8 D4*2 
    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 
    D4 D4 E4 C4 D4 E4*8 F4*8 E4 C4 D4 E4*8 F4*8 E4 D4 C4 D4 G3*2 
    E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4*. C4*8 C4*2 
    
With the default settings, comes out with the following data for file.
    
    4d546864 00000006 00010002 01e04d54 726b0000 003d00ff 030ce980 89e69cac 313239e9 a69600ff 02105369 6e726920 4d696469 204d616b 657200ff 51030783 0000ff58 04040218 0800ff59 02000000 ff2f004d 54726b00 00023e00 ff200100 00b00a40 00c00100 90347883 60803400 00903478 83608034 00009035 78836080 35000090 37788360 80370000 90377883 60803700 00903578 83608035 00009034 78836080 34000090 32788360 80320000 90307883 60803000 00903078 83608030 00009032 78836080 32000090 34788360 80340000 90347885 50803400 00903278 81708032 00009032 78874080 32000090 34788360 80340000 90347883 60803400 00903578 83608035 00009037 78836080 37000090 37788360 80370000 90357883 60803500 00903478 83608034 00009032 78836080 32000090 30788360 80300000 90307883 60803000 00903278 83608032 00009034 78836080 34000090 32788550 80320000 90307881 70803000 00903078 87408030 00009032 78836080 32000090 32788360 80320000 90347883 60803400 00903078 83608030 00009032 78836080 32000090 34788170 80340000 90357881 70803500 00903478 83608034 00009030 78836080 30000090 32788360 80320000 90347881 70803400 00903578 81708035 00009034 78836080 34000090 32788360 80320000 90307883 60803000 00903278 83608032 0000902b 78874080 2b000090 34788360 80340000 90347883 60803400 00903578 83608035 00009037 78836080 37000090 37788360 80370000 90357883 60803500 00903478 83608034 00009032 78836080 32000090 30788360 80300000 90307883 60803000 00903278 83608032 00009034 78836080 34000090 32788550 80320000 90307881 70803000 00903078 87408030 0000ff2f 00