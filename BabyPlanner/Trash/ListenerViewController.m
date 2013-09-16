//
//  ListenerViewController.m
//  SafeSound
//
//  Created by Demetri Miller on 10/25/10.
//  Copyright 2010 Demetri Miller. All rights reserved.
//

#import "ListenerViewController.h"
#import "RIOInterface.h"
#import "KeyHelper.h"
#import "BPUtils.h"

@implementation ListenerViewController

@synthesize listenButton;
@synthesize key;
@synthesize prevChar;
@synthesize isListening;
@synthesize	rioRef;
@synthesize currentFrequency;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"Test";
    }
    
    return self;
}

#pragma mark -
#pragma mark Listener Controls
- (IBAction)toggleListening:(id)sender {
	if (isListening) {
		[self stopListener];
		[listenButton setTitle:@"Begin Listening" forState:UIControlStateNormal];
	} else {
		[self startListener];
		[listenButton setTitle:@"Stop Listening" forState:UIControlStateNormal];
	}
	
	isListening = !isListening;
}

- (void)startListener {
	[rioRef startListening:self];
}

- (void)stopListener {
	[rioRef stopListening];
}



#pragma mark -
#pragma mark Lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	rioRef = [RIOInterface sharedInstance];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    listenButton = nil;
    [super viewDidUnload];
}

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Key Management
// This method gets called by the rendering function. Update the UI with
// the character type and store it in our string.
- (void)frequencyChangedWithValue:(float)newFrequency{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	self.currentFrequency = newFrequency;
	[self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
	
	
	/*
	 * If you want to display letter values for pitches, uncomment this code and
	 * add your frequency to pitch mappings in KeyHelper.m
	 */
	
	/*
	KeyHelper *helper = [KeyHelper sharedInstance];
	NSString *closestChar = [helper closestCharForFrequency:newFrequency];
	
	// If the new sample has the same frequency as the last one, we should ignore
	// it. This is a pretty inefficient way of doing comparisons, but it works.
	if (![prevChar isEqualToString:closestChar]) {
		self.prevChar = closestChar;
		if ([closestChar isEqualToString:@"0"]) {
		//	[self toggleListening:nil];
		}
		[self performSelectorInBackground:@selector(updateFrequencyLabel) withObject:nil];
		NSString *appendedString = [key stringByAppendingString:closestChar];
		self.key = [NSMutableString stringWithString:appendedString];
	}
	*/
	[pool drain];
	pool = nil;
	
}
		 
- (void)updateFrequencyLabel {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    float temperature = 0.00286498831762*self.currentFrequency+3.89924954358;
//    float temperature = 0.0028649883095*self.currentFrequency+3.89924963297;
	self.titleLabel.text = [NSString stringWithFormat:@"%.2fHz - %@", self.currentFrequency, [BPUtils temperatureFromNumber:@(temperature)]];
//	[self.titleLabel setNeedsDisplay];
	[pool drain];
	pool = nil;
}


@end
