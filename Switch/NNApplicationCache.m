//
//  NNApplicationCache.m
//  Switch
//
//  Created by Scott Perry on 06/20/13.
//  Copyright © 2013 Scott Perry.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NNApplicationCache.h"


@interface NNApplicationCache ()

@property (nonatomic, strong, readonly) NSMutableDictionary *cache;

@end


@implementation NNApplicationCache

+ (instancetype)sharedCache;
{
    static NNApplicationCache *_sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCache = [self new];
    });
    
    return _sharedCache;
}

- (instancetype)init;
{
    self = [super init];
    if (!self) { return nil; }
    
    _cache = [NSMutableDictionary new];
    
    return self;
}

- (NNApplication *)cachedApplicationWithPID:(pid_t)pid;
{
    return [self.cache objectForKey:@(pid)];
}

- (void)cacheApplication:(NNApplication *)application withPID:(pid_t)pid;
{
    if ([self cachedApplicationWithPID:pid]) {
        Log(@"Already have a application for pid %u!", pid);
    }
    
    Log(@"Added %@ to application cache", application);

    [self.cache setObject:application forKey:@(pid)];
}

- (void)removeApplicationWithPID:(pid_t)pid;
{
    if (![self cachedApplicationWithPID:pid]) {
        Log(@"Don't have a window for id %u!", pid);
    }
    
    Log(@"Removed %@ from application cache", [self cachedApplicationWithPID:pid]);

    [self.cache removeObjectForKey:@(pid)];
}

@end