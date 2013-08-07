//
//  SMUnit.m
//  UnitsKit
//
//  Created by Steve Moser on 6/17/13.
//  Copyright (c) 2013 Steve Moser (http://stevemoser.org)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "SMUnit.h"

@implementation SMUnit

- (id)init
{
    self = [super init];
    if (self) {
        _staticRational = 0;
    }
    
    return self;
}

- (NSString *)identifier
{
    return [_system stringByAppendingString:_name];
}

- (NSString *)fullName
{
    if (_fullName) {
        return _fullName;
    }
    
    return [NSString stringWithFormat:@"%@ %@",_system,_name];
}

@end
