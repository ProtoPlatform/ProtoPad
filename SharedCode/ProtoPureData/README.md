# Proto Runtime Engine VM 
## For iPhone, iPad, tvOS, macOS
### Proto PureData Objective-C wrapper object for libpd for iOS (includes `multi`)

Self contained object for interfacing with all relevant functions in `[PdBase ...]` and its self contained AudioUnit from ProtoScriptVM's `PAudioLib` with the following methods:

```objective-c
-(instancetype)initWithPatch:(NSString *)patch withSearchPath:(NSString *)searchPath andDelegate:(id)delegate;
-(void)addSearchPath:(NSString *)searchPath;
// audio engine methods
-(PdAudioStatus)configurePlaybackWithSampleRate:(int)sampleRate numberChannels:(int) numChannels inputEnabled:(BOOL)inputEnabled mixingEnabled:(BOOL)mixingEnabled;
-(PdAudioStatus)configureAmbientWithSampleRate:(int)sampleRate numberChannels:(int)numChannels mixingEnabled:(BOOL)mixingEnabled;
-(void)configureTicksPerBuffer:(int)ticksPerBuffer;
-(BOOL)inputEnabled;
-(void)activeEnabled:(BOOL)activeEnabled;
// return $0 for patch
-(int)dollarZero;
// DSP Methods
-(void)dspOn;
-(void)dspOff;
// Send To Pd - Atoms
-(void)sendList:(NSArray *)list toReceiver:(NSString *)receiver;
-(void)sendBangToReceiver:(NSString *)receiver;
-(void)sendFloat:(float)floatValue toReceiver:(NSString *)receiver;
-(void)sendSymbol:(NSString *)symbol toReceiver:(NSString *)receiver;
-(void)sendMessage:(NSString *)message withArguments:(NSArray *)list toReceiver:(NSString *)receiver;
/// Receive is handled by PdReceiverDelegate
// Send To Pd - MIDI
-(void)sendNoteOn:(int)midiChan pitch:(int)pitch velocity:(int)velocity;
-(void)sendControlChange:(int)midiChan controller:(int)controller value:(int)value;
-(void)sendProgramChange:(int)midiChan value:(int)value;
-(void)sendPitchBend:(int)midiChan value:(int)value;
-(void)sendAftertouch:(int)midiChan value:(int)value;
-(void)sendPolyAftertouch:(int)midiChan pitch:(int)pitch value:(int)value;
-(void)sendMidiByte:(int)midiByte byte:(int)byte;
-(void)sendSysex:(int)sysex byte:(int)byte;
-(void)sendSysRealTime:(int)sysRealTime byte:(int)byte;
/// MIDI Receive is handled by PdMidiReceiverDelegate
// Arrays
// Size for array
-(int)arraySizeForArrayNamed:(NSString *)arrayName;
// Zero out an array
-(void)clearArrayNamed:(NSString *)arrayName;
// Read Array From Pd
-(void)copyArrayNamed:(NSString *)arrayName withOffset:(int)offset toArray:(float *)array count:(int)length;
// Write Array To Pd
-(void)copyArray:(float *)array toArrayNamed:(NSString *)arrayName withOffset:(int)offset count:(int)length;
// receive messages to from Pd: [r fromPD]
-(void)subscribe:(NSString *)receiveSymbol;
// stop receiving messages from Pd [r fromPD]
-(void)unsubscribe:(NSString *)receiveSymbol;
// Close and destroy Pd instance
-(void)onDestroy;
```

/blee/
