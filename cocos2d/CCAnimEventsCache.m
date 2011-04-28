/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2009 Jason Booth
 * Copyright (c) 2009 Robert J Payne
 * Copyright (c) 2011 Charles Randall (this file only)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Platforms/CCNS.h"
#import "ccMacros.h"
#import "CCAnimEventsCache.h"

#pragma mark CCAnimEvents

@implementation CCAnimEvents

-(id)initWithDictionary:(NSDictionary*)dictionary
{
	if((self=[super init]))
	{
		events = [dictionary retain];
	}
	return self;
}

-(void)dealloc
{
	[events release];
}

-(void)setTarget:(id)tgt selector:(SEL)sel
{
	target = tgt;
	selector = sel;
	
}

-(void)performEventForFrame:(CCSpriteFrame*)frame
{
	NSString* event = (NSString*)[events objectForKey:[NSNumber numberWithInt:(int)frame]];
	if(event != nil)
	{
		[target performSelector:selector withObject:event];
	}
}


@end


#pragma mark -
#pragma mark CCAnimEventsCache

@implementation CCAnimEventsCache

#pragma mark CCAnimEventsCache - Alloc, Init & Dealloc

static CCAnimEventsCache *sharedAnimEventsCache_=nil;

+(CCAnimEventsCache *)sharedAnimEventCache
{
	if (!sharedAnimEventsCache_)
		sharedAnimEventsCache_ = [[CCAnimEventsCache alloc] init];
	
	return sharedAnimEventsCache_;
}

+(id)alloc
{
	NSAssert(sharedAnimEventsCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+(void)purgeSharedAnimEventsCache
{
	[sharedAnimEventsCache_ release];
	sharedAnimEventsCache_ = nil;
}

-(id) init
{
	if( (self=[super init]) ) {
		events_ = [[NSMutableDictionary alloc] initWithCapacity: 10];
	}
	
	return self;
}

- (NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | num of anim events =  %i>", [self class], self, [events_ count]];
}

-(void) dealloc
{
	CCLOGINFO(@"cocos2d: deallocing %@", self);
	
	[events_ release];
	[super dealloc];
}

#pragma mark CCAnimEventsCache - implementation

-(void)addAnimEvent:(CCSpriteFrame*)frame event:(NSString*)event
{
	[events_ setObject:event forKey:[NSNumber numberWithInt:(int)frame]];
}

-(void)removeFrameEvents:(CCSpriteFrame*)frame
{
	[events_ removeObjectForKey:[NSNumber numberWithInt:(int)frame]];
}

-(NSString*)fetchEvent:(CCSpriteFrame*)frame
{
	return (NSString*)[events_ objectForKey:[NSNumber numberWithInt:(int)frame]];
}

-(CCAnimEvents*)getEventsForFrames:(NSArray*)frames
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	
	for(CCSpriteFrame* f in frames)
	{
		NSString* event = [self fetchEvent:f];
		if( event != nil )
		{
			[dict setObject:event forKey:[NSNumber numberWithInt:(int)f]];
		}
	}
	
	return [[[CCAnimEvents alloc] initWithDictionary:dict] autorelease];
}

@end
