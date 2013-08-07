//
//  SMQuantityFormatter.h
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

#import <Foundation/Foundation.h>

/**
 Specifies what symbol to use for display of unit symbols formed by multiplication.
 */
typedef enum {
    SMSymbolSeparatorInterpunctStyle = 0,       // e.g. "6 kg·m·s−2" option+shift+9
    SMSymbolSeparatorNonbreakingSpaceStyle,    // e.g. "6 kg m s-2" option+space (appears as Interpunct)
    SMSymbolSeparatorSpaceStyle,       // e.g. "6 kg m s−2"
} SMQuantityFormatterSymbolSeparator;

@class SMQuantity;

/**
 Instances of `SMQuantityFormatter` create localized string representations of quantities.
 
 Note that in these examples if a unit exponent is not preceded by a carrot (^) then it should appear as a superscript
 
 For example, the the value 6 netwons could be formatted as "6 N" or "6 newtons" or "6 kilogram meters per second squared" or "6 kg·m·s−2" or "6 kg·m/s2" or "6 kg m s-2" or "6 kg·m·s^−2".
 
 @discussion By default, `SMQuantityFormatter` uses CGPM rules to display unit symbols (6 kg·m·s−2). See http://en.wikipedia.org/wiki/International_System_of_Units#Writing_unit_symbols_and_the_values_of_quantities for more informaion about displaying quantites. Additionally.
 */
@interface SMQuantityFormatter : NSFormatter <NSCoding>

/**
 Specifies the `NSNumberFormatter` object used to format numeric values in all formatted strings. By default, this uses the `NSNumberFormatterDecimalStyle` number style, and sets a rounding increment of `0.01f`.
 */
@property (nonatomic, readonly) NSNumberFormatter *numberFormatter;

/**
 Specifies whether to display units in terms of symbols, as opposed to names. `YES` by default.
 */
@property (nonatomic, assign) BOOL displaysInTermsOfSymbols;

/**
 Specifies whether to use superscript for display of exponents of unit symbols. `YES` by default.
 */
@property (nonatomic, assign) BOOL usesSuperscriptForExponentForSymbolsForDisplay;

/**
 Specifies whether to use solidus for display of unit symbols formed by division. `YES` by default.
 */
@property (nonatomic, assign) BOOL usesSolidusForSymbolsForDisplay;

/**
 Specifies whether to use hyphens for display of derived unit names. `SMSymbolSeparatorInterpunctStyle` by default.
 */
@property (nonatomic, assign) SMQuantityFormatterSymbolSeparator symbolSeparator;


/**
 Returns a string representation of a given number of a specified unit of information formatted using the receiver’s current settings.
 
 @param number The number of specified units for format.
 @param unit The number unit.
 */
- (NSString *)stringFromQuantity:(SMQuantity *)quantity;

@end
