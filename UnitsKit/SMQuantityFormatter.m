//
//  SMQuantityFormatter.m
//  UnitsKit
//
//  Created by Steve Moser on 6/15/13.
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

#import "SMQuantityFormatter.h"

#import "SMQuantityEvaluator.h"
#import "SMQuantity.h"
#import "SMBaseUnit.h"

@implementation SMQuantityFormatter

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_numberFormatter setRoundingIncrement:[NSNumber numberWithFloat:0.01f]];
    
    self.displaysInTermsOfSymbols = YES;
    self.usesSuperscriptForExponentForSymbolsForDisplay = YES;
    self.symbolSeparator = SMSymbolSeparatorInterpunctStyle;
    self.usesSolidusForSymbolsForDisplay = YES;
    
    return self;
}


- (NSString*)removeLastCharOfString:(NSString*)aString
{
    return [aString substringToIndex:[aString length]-1];
}

//adopted from http://stackoverflow.com/questions/6716596/is-there-an-objective-c-method-that-takes-a-number-and-spells-it-out
//fixed > 99 and <= 1000000000 issue
-(NSString *)spelledOutRootOfNumber:(NSNumber *)number
{
    number = [NSNumber numberWithInteger:ABS([number integerValue])];
    
    if ([number isEqualToNumber:@2]) {
        return @"squared";
    } else if ([number isEqualToNumber:@3]) {
        return @"cubed";
    } else if ([number isEqualToNumber:@100]) {
        return @"to the hundredth";
    } else if ([number isEqualToNumber:@1000]) {
        return @"to the thousandth";
    } else if ([number isEqualToNumber:@1000000]) {
        return @"to the millionth";
    } else if ([number isEqualToNumber:@1000000000]) {
        return @"to the billionth";
    } 
    
    static dispatch_once_t onceMark;
    static NSNumberFormatter *formatter = nil;
    dispatch_once(&onceMark, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle: NSNumberFormatterSpellOutStyle];
    });
    
    NSString* spelledOutNumber = [formatter stringFromNumber:number];
    
    NSMutableArray *numberParts = [[spelledOutNumber componentsSeparatedByString:@" "] mutableCopy];
    
    // replace all '-'
    spelledOutNumber = [[numberParts lastObject] stringByReplacingOccurrencesOfString:@"-"
                                                                   withString:@" "];
    
    NSArray *lessThanAHundredNumberParts = [spelledOutNumber componentsSeparatedByString:@" "];
    
    [numberParts removeLastObject];
    NSString *greaterThanAHundredNumberSpelledOut = [numberParts componentsJoinedByString:@" "];
    
    NSMutableString *output = [NSMutableString string];
    
    NSUInteger numberOfParts = [lessThanAHundredNumberParts count];
    for (int i=0; i<numberOfParts; i++) {
        NSString *numberPart = [lessThanAHundredNumberParts objectAtIndex:i];
        
        if ([numberPart isEqualToString:@"one"])
            [output appendString:@"first"];
        else if([numberPart isEqualToString:@"two"])
            [output appendString:@"second"];
        else if([numberPart isEqualToString:@"three"])
            [output appendString:@"third"];
        else if([numberPart isEqualToString:@"five"])
            [output appendString:@"fifth"];
        else {
            NSUInteger characterCount = [numberPart length];
            unichar lastChar = [numberPart characterAtIndex:characterCount-1];
            if (lastChar == 'y')
            {
                // check if it is the last word
                if (numberOfParts-1 == i)
                { // it is
                    [output appendString:[NSString stringWithFormat:@"%@ieth ", [self removeLastCharOfString:numberPart]]];
                }
                else
                { // it isn't
                    [output appendString:[NSString stringWithFormat:@"%@-", numberPart]];
                }
            }
            else if (lastChar == 't' || lastChar == 'e')
            {
                [output appendString:[NSString stringWithFormat:@"%@th-", [self removeLastCharOfString:numberPart]]];
            }
            else
            {
                [output appendString:[NSString stringWithFormat:@"%@th ", numberPart]];
            }
        }
    }
    
    // eventually remove last char
    unichar lastChar = [output characterAtIndex:[output length]-1];
    if (lastChar == '-' || lastChar == ' ') {
        output = [[self removeLastCharOfString:output] mutableCopy];
    }
    
    if ([greaterThanAHundredNumberSpelledOut length] > 0) {
        return [NSString stringWithFormat:@"to the %@ %@",greaterThanAHundredNumberSpelledOut,output];
    }
    return [NSString stringWithFormat:@"to the %@",output];
}

//http://stackoverflow.com/a/7937760/142358
-(NSString *)superScriptOf:(NSString *)inputNumber{
    
    NSString *outp=@"";
    for (int i =0; i<[inputNumber length]; i++) {
        unichar chara=[inputNumber characterAtIndex:i] ;
        switch (chara) {
            case '1':
                outp=[outp stringByAppendingFormat:@"\u00B9"];
                break;
            case '2':
                outp=[outp stringByAppendingFormat:@"\u00B2"];
                break;
            case '3':
                outp=[outp stringByAppendingFormat:@"\u00B3"];
                break;
            case '4':
                outp=[outp stringByAppendingFormat:@"\u2074"];
                break;
            case '5':
                outp=[outp stringByAppendingFormat:@"\u2075"];
                break;
            case '6':
                outp=[outp stringByAppendingFormat:@"\u2076"];
                break;
            case '7':
                outp=[outp stringByAppendingFormat:@"\u2077"];
                break;
            case '8':
                outp=[outp stringByAppendingFormat:@"\u2078"];
                break;
            case '9':
                outp=[outp stringByAppendingFormat:@"\u2079"];
                break;
            case '-':
                outp=[outp stringByAppendingFormat:@"\u207B"];
                break;
            case '0':
                outp=[outp stringByAppendingFormat:@"\u2070"];
                break;
            default:
                break;
        }
    }
    return outp;   
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    if ([obj isKindOfClass:[SMQuantity class]]) {
        return [self stringFromQuantity:(SMQuantity *)obj];
    } else {
        return nil;
    }
}

- (NSString *)preprendUnitString:(NSString *)unitString toNumberOfDimensions:(NSNumber *)dimensions
{
    if (!self.displaysInTermsOfSymbols) {
        NSString *spelledOutRoot = [self spelledOutRootOfNumber:dimensions];
        return [NSString stringWithFormat:@"%@ %@",unitString,spelledOutRoot];
    }
    if (self.usesSuperscriptForExponentForSymbolsForDisplay) {
        NSString *superscriptNumberOfDimension = [self superScriptOf:[dimensions stringValue]];
        return [NSString stringWithFormat:@"%@%@",unitString,superscriptNumberOfDimension];
    } else {
        return [NSString stringWithFormat:@"%@^%@",unitString,[dimensions stringValue]];
    }
}

- (NSString *)unitStringWithDimensionFromBaseUnit:(SMBaseUnit *)baseUnit
                                                 dimensions:(NSNumber *)dimensions
                                                     plural:(BOOL)plural
{
    
    NSString *baseUnitName = baseUnit.name;
    
    // lux, hertz, and siemens are irregular plurals TODO:find proper inflections of even user defined units
    if (plural &&
        ![baseUnitName isEqualToString:@"lux"] &&
        ![baseUnitName isEqualToString:@"hertz"] &&
        ![baseUnitName isEqualToString:@"siemens"]) {
        baseUnitName = [NSString stringWithFormat:@"%@s",baseUnitName];
    }
    
    BOOL numberOfDimensionsIsEqualToOne = [dimensions isEqualToNumber:@1];
    
    if (numberOfDimensionsIsEqualToOne && !self.displaysInTermsOfSymbols) {
        return baseUnitName;
    }
    
    if (numberOfDimensionsIsEqualToOne && self.displaysInTermsOfSymbols) {
        return baseUnit.symbol;
    }
    
    if (!numberOfDimensionsIsEqualToOne && !self.displaysInTermsOfSymbols) {
        return [self preprendUnitString:baseUnitName toNumberOfDimensions:dimensions];
    }

    if (!numberOfDimensionsIsEqualToOne && self.displaysInTermsOfSymbols) {
        return [self preprendUnitString:baseUnit.symbol toNumberOfDimensions:dimensions];
    }
    
    return nil;
}

- (NSString *)stringFromQuantity:(SMQuantity *)quantity
{
    NSString *unitStringsWithDimensions = nil;
    double doubleValue = [quantity.value doubleValue];
    
    //SMQuantityEvaluator *evaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    //TODO: support ordering of units i.e. mass length time A temp amount light, negative exponents last, proper names first
    NSArray *sortedbaseUnits = [quantity.unit.baseUnitsWithDimensionExponents keysSortedByValueUsingComparator:^NSComparisonResult(id dimension1, id dimension2) {
        int v1 = [dimension1 intValue];
        int v2 = [dimension2 intValue];
        if (v1 < v2)
            return NSOrderedDescending;
        else if (v1 > v2)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    
    NSMutableArray *unitStringsWithPositiveDimensionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *unitStringsWithNegativeDimensionsArray = [[NSMutableArray alloc] init];

    for (SMBaseUnit *baseUnit in sortedbaseUnits) {
        NSString *baseUnitString;
        //find the last unit with a positive exponent and make it plural
        BOOL plural = NO;
        if (doubleValue != 1.0 && doubleValue !=-1.0 &&
            [unitStringsWithNegativeDimensionsArray count] == 0) {
            int index = [sortedbaseUnits indexOfObject:baseUnit];
            if (![baseUnit isEqual:[sortedbaseUnits lastObject]]) {
                index++;
                NSString *possibleBaseUnitPastLastBaseUnitWithPositiveExponent = [sortedbaseUnits objectAtIndex:index];
                if ([quantity.unit.baseUnitsWithDimensionExponents[possibleBaseUnitPastLastBaseUnitWithPositiveExponent] intValue] < 0 &&
                    [quantity.unit.baseUnitsWithDimensionExponents[baseUnit] intValue] > 0) {
                    plural = YES;
                }
            } else {
                NSString *possibleLastBaseUnitWithPositiveExponent = [sortedbaseUnits objectAtIndex:index];
                if ([quantity.unit.baseUnitsWithDimensionExponents[possibleLastBaseUnitWithPositiveExponent] intValue] > 0) {
                    plural = YES;
                }
            }

        }
        
        baseUnitString = [self unitStringWithDimensionFromBaseUnit:baseUnit dimensions:quantity.unit.baseUnitsWithDimensionExponents[baseUnit] plural:plural];

        if ([quantity.unit.baseUnitsWithDimensionExponents[baseUnit] intValue] > -1) {
            [unitStringsWithPositiveDimensionsArray addObject:baseUnitString];
        } else {
            [unitStringsWithNegativeDimensionsArray addObject:baseUnitString];
        }
    }
    
    

    NSString *joinString = @" ";
    NSString *joinStringForUnitsFormedByDivision = @"";
    
    if (self.displaysInTermsOfSymbols) {
        switch (self.symbolSeparator) {
            case SMSymbolSeparatorInterpunctStyle:
                joinString = @"·";
                break;
            case SMSymbolSeparatorNonbreakingSpaceStyle:
                joinString = @" ";
                break;
            case SMSymbolSeparatorSpaceStyle:
                joinString = @" ";
                break;
        }
        
        if (self.usesSolidusForSymbolsForDisplay) {
            joinStringForUnitsFormedByDivision = @"/";
        } else {
            joinStringForUnitsFormedByDivision = joinString;
        }
    } else if ([unitStringsWithPositiveDimensionsArray count] == 0 && [unitStringsWithNegativeDimensionsArray count] > 0) {
        //prevent extra space before per if no positive dimensions
        joinStringForUnitsFormedByDivision = @"per ";
        
    } else {
        joinStringForUnitsFormedByDivision = @" per ";
    }

    NSString *unitsWithPositiveDimensionsString = [unitStringsWithPositiveDimensionsArray componentsJoinedByString:joinString];
    NSString *unitsWithNegativeDimensionsString = [unitStringsWithNegativeDimensionsArray componentsJoinedByString:joinString];

    if ([unitStringsWithPositiveDimensionsArray count] > 0 &&
        [unitStringsWithNegativeDimensionsArray count] == 0) {
        unitStringsWithDimensions = unitsWithPositiveDimensionsString;
    } else if ([unitStringsWithPositiveDimensionsArray count] == 0 && [unitStringsWithNegativeDimensionsArray count] > 0) {
        if (!self.displaysInTermsOfSymbols) {
            unitStringsWithDimensions = [NSString stringWithFormat:@"%@%@",joinStringForUnitsFormedByDivision,unitsWithNegativeDimensionsString];

        } else {
            unitStringsWithDimensions = unitsWithNegativeDimensionsString;
        }
    } else if (self.usesSolidusForSymbolsForDisplay && self.displaysInTermsOfSymbols) {
        unitsWithNegativeDimensionsString = [unitsWithNegativeDimensionsString
                                         stringByReplacingOccurrencesOfString:@"-" withString:@""];
        unitsWithNegativeDimensionsString = [unitsWithNegativeDimensionsString
                                             stringByReplacingOccurrencesOfString:@"\u207B" withString:@""];
        if ([unitStringsWithNegativeDimensionsArray count] > 1) {
            unitsWithNegativeDimensionsString = [NSString stringWithFormat:@"(%@)",unitsWithNegativeDimensionsString];
        }
        unitStringsWithDimensions = [@[unitsWithPositiveDimensionsString,unitsWithNegativeDimensionsString] componentsJoinedByString:joinStringForUnitsFormedByDivision];

    } else {
        unitStringsWithDimensions = [@[unitsWithPositiveDimensionsString,unitsWithNegativeDimensionsString] componentsJoinedByString:joinStringForUnitsFormedByDivision];
        
    }

    return [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"Unit Format String", nil, [NSBundle mainBundle], @"%@ %@", @"#{Value} #{Unit}"), [_numberFormatter stringFromNumber:[NSNumber numberWithDouble:doubleValue]], unitStringsWithDimensions];
}

//- (NSString *)stringFromNumber:(NSNumber *)number
//                        ofUnit:(TTTUnitOfInformation)unit
//{
//    return [self stringFromNumberOfBits:[NSNumber numberWithInteger:(TTTNumberOfBitsInUnit(unit) * [number integerValue])]];
//}
//
//- (NSString *)stringFromNumber:(NSNumber *)number
//                        ofUnit:(TTTUnitOfInformation)unit
//                    withPrefix:(TTTUnitPrefix)prefix
//{
//    return [self stringFromNumber:[NSNumber numberWithDouble:([self scaleFactorForPrefix:prefix] * [number integerValue])] ofUnit:unit];
//}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    self.displaysInTermsOfSymbols = [aDecoder decodeBoolForKey:@"displaysInTermsOfSymbols"];
    
    _numberFormatter = [aDecoder decodeObjectForKey:@"numberFormatter"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeBool:self.displaysInTermsOfSymbols forKey:@"displaysInTermsOfSymbols"];
    
    [aCoder encodeObject:_numberFormatter forKey:@"numberFormatter"];
}

@end
