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

#import <Foundation/Foundation.h>

@class CCSpriteFrame;


/** AnimEvents class which will be stored by a CCAnimation, populated and returned by
 CCAnimEventsCache. Not meant to be manually created.

 */
@interface CCAnimEvents : NSObject {
    NSDictionary *events;
	id target;
	SEL selector;
}

/** Sets the receiver for the animation event, and specifies the selector. 
  The selector must take one parameter which is the NSString* name of event.
 */
-(void)setTarget:(id)tgt selector:(SEL)sel;

/** Performs any events that exist for the specified frame.
 */
-(void)performEventForFrame:(CCSpriteFrame*)frame;

@end


/** Singleton that handles the storing of animation events
 It saves them keyed to the CCSpriteFrame*. Note, because NSMutableDictionary
 would normally copy keys, internally this wraps the pointer in a
 NSNumber. Because of this there is potential for abuse leading to leaking 
 of animation events. So if you do heavy adding/removing of spriteframes, 
 you may need to watch this carefully.
 

 */
@interface CCAnimEventsCache : NSObject {
    NSMutableDictionary *events_;
}

/** Returns ths shared instance of the Anim Event cache */
+ (CCAnimEventsCache *) sharedAnimEventCache;

/** Purges the cache. 
 */
+(void)purgeSharedAnimEventsCache;

/** Registers event for given frame. 
 */
-(void)addAnimEvent:(CCSpriteFrame*)frame event:(NSString*)event;

/** Removes a frame from cache
 */
-(void)removeFrameEvents:(CCSpriteFrame*)frame;

/** Retrieves an event for a frame.
 */
-(NSString*)fetchEvent:(CCSpriteFrame*)frame;

/** Returns the CCAnimEvents object which contains the subset of events
 used by this set of frames. 
 */
-(CCAnimEvents*)getEventsForFrames:(NSArray*)frames;


@end
