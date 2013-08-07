//
//  SMDerivedUnit.m
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

#import "SMDerivedUnit.h"

#import "SMUnit.h"
#import "SMBaseUnit.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

@implementation SMDerivedUnit


+ (SMDerivedUnit *)scaledUnitFromUnit:(SMDerivedUnit *)unit name:(NSString *)name symbol:(NSString *)symbol scale:(double)scale staticRational:(NSInteger)staticRational
{
    SMDerivedUnit *newUnit = [[SMDerivedUnit alloc] init];
    [newUnit setName:name];
    [newUnit setSymbol:symbol];
    [newUnit setSystem:unit.system];
    [newUnit setBaseUnitsWithDimensionExponents:unit.baseUnitsWithDimensionExponents];
    [newUnit setScale:scale];
    [newUnit setStaticRational:staticRational];
    
    [newUnit setFundamental:unit];
    
    return newUnit;
}

- (NSDictionary *)dimensionsWithDimensionExponents
{
    NSMutableDictionary *dimensionsWithDimensionExponents = [@{} mutableCopy];
    for (SMBaseUnit *baseUnit in self.baseUnitsWithDimensionExponents) {
        [dimensionsWithDimensionExponents setObject:self.baseUnitsWithDimensionExponents[baseUnit] forKey:baseUnit.dimension];
    }
    return dimensionsWithDimensionExponents;
}

- (NSDictionary *)dimensionsWithBaseUnits
{
    NSMutableDictionary *dimensionsWithBaseUnits = [@{} mutableCopy];
    for (SMBaseUnit *baseUnit in self.baseUnitsWithDimensionExponents) {
        [dimensionsWithBaseUnits setObject:baseUnit forKey:baseUnit.dimension];
    }
    return dimensionsWithBaseUnits;
}

- (BOOL)isEqual:(id)other
{
    if (![other isKindOfClass: [SMDerivedUnit class]]) {
        return NO;
    }
    SMDerivedUnit *otherDerivedUnit = (SMDerivedUnit *)other;
    
    if (!otherDerivedUnit.baseUnitsWithDimensionExponents && !_baseUnitsWithDimensionExponents) {
        return YES;
    }

    if ([otherDerivedUnit.baseUnitsWithDimensionExponents isEqualToDictionary:_baseUnitsWithDimensionExponents] &&
        (otherDerivedUnit.staticRational == self.staticRational)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isCommensurableToDerivedUnit:(id)other
{
    if (![other isKindOfClass: [SMDerivedUnit class]]) {
        return NO;
    }
    SMDerivedUnit *otherDerivedUnit = (SMDerivedUnit *)other;
    
    if (![otherDerivedUnit.dimensionsWithDimensionExponents isEqualToDictionary:[self dimensionsWithDimensionExponents]]) {
        return NO;
    }
    
    return YES;
}

- (NSUInteger)hash
{
    return [_baseUnitsWithDimensionExponents hash];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    SMDerivedUnit *objectCopy = [[[self class] allocWithZone:zone] init];
    if(objectCopy) {
        [objectCopy setName:[self.name copyWithZone:zone]];
        [objectCopy setSymbol:[self.symbol copyWithZone:zone]];
        [objectCopy setSystem:[self.system copyWithZone:zone]];
        [objectCopy setDimension:[self.dimension copyWithZone:zone]];
        [objectCopy setScale:[self scale]];
        [objectCopy setStaticRational:[self staticRational]];
        [objectCopy setFundamental:[self fundamental]];
        
        [objectCopy setBaseUnitsWithDimensionExponents:[self.baseUnitsWithDimensionExponents copyWithZone:zone]];
    }
    return objectCopy;
}

@end