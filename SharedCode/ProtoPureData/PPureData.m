//
//  PPureData.m
//  ProtoScriptVM
//
//  Created by blee on 12/17/20.
//  Copyright © 2020 Brian Lee. All rights reserved.
//

#import "PPureData.h"

@interface PPureData()
{
    BOOL isDealloced;
}
@end

@implementation PPureData : NSObject
#pragma mark - Ctor Methods
-(instancetype)initWithPatch:(NSString *)patch withSearchPath:(NSString *)searchPath andDelegate:(id)delegate
{
    self = [super init];
    isDealloced = FALSE;
    if (delegate) self.delegate = delegate;
    [PdBase addToSearchPath:searchPath];
    self.patch = [PdFile openFileNamed:[patch lastPathComponent] path:[patch stringByDeletingLastPathComponent]];
    NSLog(@"PPureData Open Patch: %@", self.patch);
    // close patch (this doesn't close the engine or path, just handle to file, its OK
    [self.patch closeFile];
    return self;
}
#pragma mark - Patch Search Path Methods
-(void)addSearchPath:(NSString *)searchPath
{
    if (!searchPath || isDealloced) return;
    [PdBase addToSearchPath:searchPath];
}
#pragma mark - DSP Audio Methods
-(PdAudioStatus)configurePlaybackWithSampleRate:(int)sampleRate numberChannels:(int) numChannels inputEnabled:(BOOL)inputEnabled mixingEnabled:(BOOL)mixingEnabled
{
    if (isDealloced) return PdAudioError;

    self.audioController = [[PdAudioController alloc] init];
    PdAudioStatus status = [self.audioController configurePlaybackWithSampleRate:sampleRate
                                                                  numberChannels:numChannels
                                                                    inputEnabled:inputEnabled
                                                                   mixingEnabled:mixingEnabled];
    if (status == PdAudioError) {
        NSLog(@"Error! Could not configure PdAudioController (ambient)");
        return PdAudioError;
    } else if (status == PdAudioPropertyChanged) {
        NSLog(@"Warning: some of the audio parameters were not accceptable.");
        return PdAudioError;
    } else {
        NSLog(@"Audio Configuration successful.");
    }
    // log actual settings
    [self.audioController print];
    // set AppDelegate as PdRecieverDelegate to receive messages from pd
    if (self.delegate)
    {
        [PdBase setDelegate:self.delegate];
        [PdBase setMidiDelegate:self.delegate]; // for midi too
    }
    return status;
}
-(PdAudioStatus)configureAmbientWithSampleRate:(int)sampleRate numberChannels:(int)numChannels mixingEnabled:(BOOL)mixingEnabled
{
    if (isDealloced) return PdAudioError;

    self.audioController = [[PdAudioController alloc] init];
    PdAudioStatus status = [self.audioController configureAmbientWithSampleRate:sampleRate numberChannels:numChannels mixingEnabled:mixingEnabled];
    
    if (status == PdAudioError) {
        NSLog(@"Error! Could not configure PdAudioController (ambient)");
        return PdAudioError;
    } else if (status == PdAudioPropertyChanged) {
        NSLog(@"Warning: some of the audio parameters were not accceptable.");
        return PdAudioError;
    } else {
        NSLog(@"Audio Configuration successful.");
    }
    // log actual settings
    [self.audioController print];
    // set AppDelegate as PdRecieverDelegate to receive messages from pd
    if (self.delegate)
    {
        [PdBase setDelegate:self.delegate];
        [PdBase setMidiDelegate:self.delegate]; // for midi too
    }
    return status;
}
-(void)configureTicksPerBuffer:(int)ticksPerBuffer
{
    if (isDealloced || ticksPerBuffer == 0) return;
    [self.audioController configureTicksPerBuffer:ticksPerBuffer];
    [self.audioController audioUnit];
    [self.audioController inputEnabled];
}
-(BOOL)inputEnabled
{
    return [self.audioController inputEnabled];
}
-(void)activeEnabled:(BOOL)activeEnabled
{
    [self.audioController setActive:activeEnabled];
}
-(int)dollarZero
{
    if (self.patch.dollarZero) return self.patch.dollarZero;
    return 0;
}
-(void)dspOn
{
    // turn on dsp
    if (isDealloced) return;
    self.audioController.active = YES;
    [PdBase computeAudio:YES];
}
-(void)dspOff
{
    // turn off dsp
    if (isDealloced) return;
    self.audioController.active = NO;
    [PdBase computeAudio:NO];
}
#pragma mark - Atom Sender Methods

// Send To Pd - Atoms
-(void)sendList:(NSArray *)list toReceiver:(NSString *)receiver
{
    if (!list || !receiver || isDealloced) return;
    [PdBase sendList:list toReceiver:receiver];
}
-(void)sendBangToReceiver:(NSString *)receiver
{
    if (!receiver || isDealloced) return;
    [PdBase sendBangToReceiver:receiver];
}
-(void)sendFloat:(float)floatValue toReceiver:(NSString *)receiver
{
    if (!receiver || isDealloced) return;
    [PdBase sendFloat:floatValue toReceiver:receiver];
}
-(void)sendSymbol:(NSString *)symbol toReceiver:(NSString *)receiver
{
    if (!symbol || !receiver) return;
    [PdBase sendSymbol:symbol toReceiver:receiver];
}
-(void)sendMessage:(NSString *)message withArguments:(NSArray *)list toReceiver:(NSString *)receiver
{
    if (!message || !list || !receiver || isDealloced) return;
    [PdBase sendMessage:message withArguments:list toReceiver:receiver];
}
#pragma mark - MIDI Methods
-(void)sendNoteOn:(int)midiChan pitch:(int)pitch velocity:(int)velocity
{
    if (isDealloced) return;
    [PdBase sendNoteOn:midiChan pitch:pitch velocity:velocity];
}
-(void)sendControlChange:(int)midiChan controller:(int)controller value:(int)value
{
    if (isDealloced) return;
    [PdBase sendControlChange:midiChan controller:controller value:value];
}
-(void)sendProgramChange:(int)midiChan value:(int)value
{
    if (isDealloced) return;
    [PdBase sendProgramChange:midiChan value:value];
}
-(void)sendPitchBend:(int)midiChan value:(int)value
{
    if (isDealloced) return;
    [PdBase sendPitchBend:midiChan value:value];
}
-(void)sendAftertouch:(int)midiChan value:(int)value
{
    if (isDealloced) return;
    [PdBase sendAftertouch:midiChan value:value];
}
-(void)sendPolyAftertouch:(int)midiChan pitch:(int)pitch value:(int)value
{
    if (isDealloced) return;
    [PdBase sendPolyAftertouch:midiChan pitch:pitch value:value];
}
-(void)sendMidiByte:(int)midiByte byte:(int)byte
{
    if (isDealloced) return;
    [PdBase sendMidiByte:midiByte byte:byte];
}
-(void)sendSysex:(int)sysex byte:(int)byte
{
    if (isDealloced) return;
    [PdBase sendSysex:sysex byte:byte];
}
-(void)sendSysRealTime:(int)sysRealTime byte:(int)byte
{
    if (isDealloced) return;
    [PdBase sendSysRealTime:sysRealTime byte:byte];
}
#pragma mark - PdArray Methods
-(int)arraySizeForArrayNamed:(NSString *)arrayName
{
    if (isDealloced) return 0;
    return [PdBase arraySizeForArrayNamed:arrayName];
}
-(void)clearArrayNamed:(NSString *)arrayName
{
    if (isDealloced) return;
     // array check length
     int array1Len = [PdBase arraySizeForArrayNamed:arrayName];
     NSLog(@"array1 len: %d", array1Len);
     // read array
     float array1[array1Len];
     [PdBase copyArrayNamed:arrayName withOffset:0 toArray:array1 count:array1Len];
     for(int i = 0; i < array1Len; ++i)
        array1[i] = 0;
     [PdBase copyArray:array1 toArrayNamed:arrayName withOffset:0 count:array1Len];
}
// Read Array From Pd
-(void)copyArrayNamed:(NSString *)arrayName withOffset:(int)offset toArray:(float *)array count:(int)length
{
    if (isDealloced) return;
    // array check length
    int array1Len = [PdBase arraySizeForArrayNamed:arrayName];
    NSLog(@"array1 len: %d", array1Len);
    // read array
    float array1[array1Len];
    [PdBase copyArrayNamed:arrayName withOffset:offset toArray:array1 count:array1Len];

}
// Write Array To Pd
-(void)copyArray:(float *)array toArrayNamed:(NSString *)arrayName withOffset:(int)offset count:(int)length
{
    if (!arrayName || !array || isDealloced) return;
    [PdBase copyArray:array toArrayNamed:arrayName withOffset:offset count:length];
}
#pragma mark - Message Subscription Methods
// receive messages to from Pd: [r fromPD]
-(void)subscribe:(NSString *)receiveSymbol
{
    if (!receiveSymbol || isDealloced) return;
    [PdBase subscribe:receiveSymbol];
    [PdBase unsubscribe:receiveSymbol];
}
// stop receiving messages to from Pd: [r fromPD]
-(void)unsubscribe:(NSString *)receiveSymbol
{
    if (!receiveSymbol || isDealloced) return;
    [PdBase unsubscribe:receiveSymbol];
}
#pragma mark - Dtor Methods
-(void)onDestroy
{
    if (isDealloced) return;
    [self dspOff];
    [PdBase setDelegate:nil]; // clear delegate & stop polling timer
    [PdBase setMidiDelegate:nil];
    self.delegate = nil;
    isDealloced = TRUE;
    [self.patch dealloc];
    [self.audioController dealloc];
}
-(void)dealloc
{
    if (!isDealloced)[self onDestroy];
    [super dealloc];
}
@end
