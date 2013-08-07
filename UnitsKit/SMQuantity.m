//
//  SMQuantity.m
//  UnitsKit
//
//  Created by Steve Moser on 4/14/13.
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

#import "SMQuantity.h"

@implementation SMQuantity

+ (SMQuantity *)quantityWithValue:(NSNumber *)value unit:(SMDerivedUnit *)unit;
{
    SMQuantity *quantity = [[SMQuantity alloc] init];
    [quantity setValue:value];
    [quantity setUnit:unit];
    
    return quantity;
}

- (id)init
{
    self = [super init];
    if (self) {
        _unit = [[SMDerivedUnit alloc] init];
    }
    
    return self;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"%@ %@",self.value.description,self.unit.description];
}

- (BOOL)isEqualToQuantity:(id)other
{
    return ([other isKindOfClass: [SMQuantity class]] &&
            [[(SMQuantity *)other value] isEqualToNumber:_value] &&
            [[(SMQuantity *)other unit] isEqual:_unit] );
}

- (NSComparisonResult)compare:(SMQuantity *)otherObject {
    if(![otherObject isKindOfClass:[SMQuantity class]]) return NSOrderedSame;
    
    if (![otherObject.unit isEqual:_unit]) {
        return NSOrderedSame;
    }
    NSComparisonResult result = [_value compare:otherObject.value];
    
    return result;
}

@end
