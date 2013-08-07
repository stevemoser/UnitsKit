//
//  SMQuantityEvaluator.h
//  UnitsKit
//
//  Created by Steve Moser on 4/13/13.
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

#import <Foundation/Foundation.h>

@class SMQuantity;
@class SMDerivedUnit;
@class SMBaseUnit;

@interface SMQuantityEvaluator : NSObject

@property (nonatomic, strong) NSMutableDictionary *derivedUnitIdentifiers;
@property (nonatomic, strong) NSMutableDictionary *derivedUnitSymbols;
@property (nonatomic, strong) NSMutableDictionary *derivedUnitNames;
@property (nonatomic, strong) NSMutableDictionary *allDerivedUnits;
@property (nonatomic, strong) NSMutableDictionary *derivedUnits;

@property (nonatomic, strong) NSMutableDictionary *baseUnitIdentifiers;
@property (nonatomic, strong) NSMutableDictionary *baseUnitSymbols;
@property (nonatomic, strong) NSMutableDictionary *baseUnitNames;
@property (nonatomic, strong) NSMutableDictionary *allBaseUnits;
@property (nonatomic, strong) NSMutableDictionary *baseUnits;

@property (nonatomic, strong) NSMutableDictionary *conversions;
@property (nonatomic, strong) NSMutableDictionary *systems;

@property (nonatomic, strong) NSMutableDictionary *constants;


+ (id) sharedQuantityEvaluator;

- (SMBaseUnit *)baseUnitFromString:(NSString *)unitString;
- (SMDerivedUnit *)derivedUnitFromString:(NSString *)unitString;

- (SMBaseUnit *)baseUnitFromBaseUnitIdentifier:(NSString *)baseUnitIdentifier;

- (SMQuantity *)evaluateQuantity:(SMQuantity *)firstQuantity withQuanity:(SMQuantity *)secondQuantity usingOperator:(NSString *)operatorName;
- (SMQuantity *)convertQuantity:(SMQuantity *)sourceQuantity usingDerivedUnit:(SMDerivedUnit *)targetUnit;
@end
