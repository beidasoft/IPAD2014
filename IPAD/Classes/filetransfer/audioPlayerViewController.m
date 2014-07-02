#import "audioPlayerViewController.h"
#import "Constants.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation audioPlayerViewController

@synthesize path;

- (id)initWithFileName:(NSString *)titel withRoot:(NSString*)rt
{
	self = [super init];
	if (self)
	{
		// this will appear as the title in the navigation bar
		path = [rt stringByAppendingPathComponent:titel];		 
		
	}
	return self;
}


- (IBAction)dismissAction:(id)sender
{
    //判断是否播放中
	if (isPlaying)
	{
        //停止播放
		[audioPlayer stop]; 
		isPlaying = FALSE; // For the loop every second it may fail there
	}
	if (audioPlayer)
	{
        //释放对象
		[audioPlayer release];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

-(void) updatePlayBtn
{
    //更新播放按钮图标为“暂停”
	[playBtn setImage:[UIImage imageNamed:@"Pause.png"] forState:UIControlStateNormal];		

}

-(void)updatePauseBtn
{
	//更新播放按钮图标为“播放”
	[playBtn setImage:[UIImage imageNamed:@"Play.png"] forState:UIControlStateNormal];		

}

- (IBAction)playBtnPressed:(id)sender
{
    //正在播放
	if (isPlaying) {
		[self updatePauseBtn];
		[audioPlayer pause];
	}
	else {
		[self updatePlayBtn];
		[audioPlayer play];
	}

	
	isPlaying = !isPlaying;

}



- (IBAction)previousBtnPressed:(id)sender
{
		
}
- (IBAction)nextBtnPressed:(id)sender
{
	
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
	
	NSLog(@"remoteControlReceivedWithEvent");
	
    if (receivedEvent.type == UIEventTypeRemoteControl) {
		
        switch (receivedEvent.subtype) {
				
            case UIEventSubtypeRemoteControlTogglePlayPause:
				[self playBtnPressed:self];
                break;
				
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previousBtnPressed:self];
                break;
				
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextBtnPressed:self];
                break;
				
            default:
                break;
        }
    }
}

//已经开始播放了，事件
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	isPlaying = FALSE;
	[self updatePauseBtn];

}
//暂停播放了事件
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
	isPlaying = FALSE;
	[self updatePauseBtn];
}
//播放停止了事件
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
	isPlaying = TRUE;
	[player play];
	[self updatePlayBtn];
}

- (IBAction)playerDidScrub:(id)sender
{
	[audioPlayer setCurrentTime:[slider value]];
	
	NSUInteger durationInMinutes = (int)[slider value] / 60;
	NSUInteger durationInRemainder = (int)[slider value] % 60;
	
	[positionLbl setText:[NSString stringWithFormat:@"%02i:%02i", durationInMinutes, durationInRemainder]];
	
}

- (void) updateSliderAndPositionLabel
{
		if (isPlaying && audioPlayer)
		{
			
			[slider setValue:audioPlayer.currentTime]; 
			
			NSUInteger durationInMinutes = (int)audioPlayer.currentTime / 60;
			NSUInteger durationInRemainder = (int)audioPlayer.currentTime % 60;
			
			[positionLbl setText:[NSString stringWithFormat:@"%02i:%02i", durationInMinutes, durationInRemainder]];
			
		}
	
	[self performSelector:@selector(updateSliderAndPositionLabel) withObject:nil afterDelay:1.0];
	
}
// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

// Called after the view has been loaded. For view controllers created in code, this is after -loadView. For view controllers unarchived from a nib, this is after the view is set.
-(void) viewDidLoad
{
	
	isPlaying = TRUE;
	NSError *error;
	NSURL *url = [[NSURL alloc] initFileURLWithPath:path isDirectory:NO];

	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	[audioPlayer setDelegate:self];
	
	if (error)
	{
		isPlaying = FALSE;
		NSLog(@"Error : %@",error);
	}
	
	if (audioPlayer.duration)
	{
		[slider setMaximumValue:audioPlayer.duration];
	}
	
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[[AVAudioSession sharedInstance] setActive: YES error:nil];

	[audioPlayer play];	
	[self updatePlayBtn];
	[self updateSliderAndPositionLabel];

	// Now we are going to extract info (id3 tags) from the file
	
	AudioFileID fileID  = nil;
    OSStatus err        = noErr;
    
    err = AudioFileOpenURL( (CFURLRef) url, kAudioFileReadPermission, 0, &fileID );
    if( err != noErr ) {
        NSLog( @"AudioFileOpenURL failed" );
    }

	UInt32 id3DataSize  = 0;
    char * rawID3Tag    = NULL;
	
    err = AudioFileGetPropertyInfo( fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL );
    if( err != noErr ) {
        NSLog( @"AudioFileGetPropertyInfo failed for ID3 tag" );
    }
    NSLog( @"id3 data size is %d bytes", id3DataSize );
	
    rawID3Tag = (char *) malloc( id3DataSize );
    if( rawID3Tag == NULL ) {
        NSLog( @"could not allocate %d bytes of memory for ID3 tag", id3DataSize );
    }
    
    err = AudioFileGetProperty( fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for ID3 tag" );
    }
    NSLog( @"read %d bytes of ID3 info", id3DataSize );

	UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
    err = AudioFormatGetProperty( kAudioFormatProperty_ID3TagSize, 
                                 id3DataSize, 
                                 rawID3Tag, 
                                 &id3TagSizeLength, 
                                 &id3TagSize
                                 );
    if( err != noErr ) {
        NSLog( @"AudioFormatGetProperty failed for ID3 tag size" );
        switch( err ) {
            case kAudioFormatUnspecifiedError:
                NSLog( @"err: audio format unspecified error" ); 
                break;
            case kAudioFormatUnsupportedPropertyError:
                NSLog( @"err: audio format unsupported property error" ); 
                break;
            case kAudioFormatBadPropertySizeError:
                NSLog( @"err: audio format bad property size error" ); 
                break;
            case kAudioFormatBadSpecifierSizeError:
                NSLog( @"err: audio format bad specifier size error" ); 
                break;
            case kAudioFormatUnsupportedDataFormatError:
                NSLog( @"err: audio format unsupported data format error" ); 
                break;
            case kAudioFormatUnknownFormatError:
                NSLog( @"err: audio format unknown format error" ); 
                break;
            default:
                NSLog( @"err: some other audio format error" ); 
                break;
        }
    }
    NSLog( @"id3 tag size is %d bytes", id3TagSize );

	
	CFDictionaryRef piDict = nil;
    UInt32 piDataSize   = sizeof( piDict );
	
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary" );
    }

    NSLog( @"property info: %@", (NSDictionary*)piDict );

	NSDictionary *infoDict = (NSDictionary*)piDict;
	
	if ([infoDict objectForKey:@"title"])
	{
		[id3TitleLbl setText:[infoDict objectForKey:@"title"]];
	}
	
	if ([infoDict objectForKey:@"artist"])
	{
		[id3ArtistLbl setText:[infoDict objectForKey:@"artist"]];
	}
	
	if ([infoDict objectForKey:@"album"])
	{
		[id3AlbumLbl setText:[infoDict objectForKey:@"album"]];
	}
	
	if ([infoDict objectForKey:@"genre"])
	{
		[id3GenreLbl setText:[infoDict objectForKey:@"genre"]];
	}

	if ([infoDict objectForKey:@"year"])
	{
		[id3YearLbl setText:[infoDict objectForKey:@"year"]];
	}	
	
	CFRelease( piDict );
    free( rawID3Tag );

	
	// End info
	
	[url release];
}

// Needed for the mediacontroller of the multitasking bar
-(BOOL) canBecomeFirstResponder
{
	return YES;
}
// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

//对象释放
- (void)dealloc
{
	[super dealloc];
}


@end
