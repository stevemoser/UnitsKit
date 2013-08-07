//
//  SMQuantityEvaluator.m
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

#import "SMQuantityEvaluator.h"

#import "SMDerivedUnit.h"
#import "SMBaseUnit.h"
#import "SMConversionFactor.h"
#import "SMQuantity.h"

#include <math.h>

@interface SMQuantityEvaluator ()

@end

@implementation SMQuantityEvaluator

static SMQuantityEvaluator * _sharedEvaluator = nil;

+ (id) sharedQuantityEvaluator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
		_sharedEvaluator = [[SMQuantityEvaluator alloc] init];
    });
	return _sharedEvaluator;
}

- (id) init {
	self = [super init];
	if (self) {
        _conversions = [[NSMutableDictionary alloc] init];
        
        _derivedUnitNames = [[NSMutableDictionary alloc] init];
        _derivedUnitSymbols = [[NSMutableDictionary alloc] init];
        _allDerivedUnits = [[NSMutableDictionary alloc] init];
        _derivedUnitIdentifiers = [[NSMutableDictionary alloc] init];
        
        _derivedUnits = [[NSMutableDictionary alloc] init];

        
        _baseUnitNames = [[NSMutableDictionary alloc] init];
        _baseUnitSymbols = [[NSMutableDictionary alloc] init];
        _allBaseUnits = [[NSMutableDictionary alloc] init];
        _baseUnitIdentifiers = [[NSMutableDictionary alloc] init];
        
        _baseUnits = [[NSMutableDictionary alloc] init];

        [self registerUnits];
        
    }
    return self;
}

- (void)registerUnits;
{
    //TODO: Refactor into smaller classes by system
    SMBaseUnit *second = [[SMBaseUnit alloc] init];
    [second setSymbol:@"s"];
    [second setName:@"second"];
    [second setSystem:@"SI"];
    [second setDimension:@"time"];
    [second setFundamental:second];
    
    SMBaseUnit *meter = [[SMBaseUnit alloc] init];
    [meter setSymbol:@"m"];
    [meter setName:@"meter"];
    [meter setSystem:@"SI"];
    [meter setDimension:@"length"];
    [meter setFundamental:meter];
    
    SMBaseUnit *kelvin = [[SMBaseUnit alloc] init];
    [kelvin setSymbol:@"K"];
    [kelvin setName:@"kelvin"];
    [kelvin setSystem:@"SI"];
    [kelvin setDimension:@"temperature"];
    [kelvin setFundamental:kelvin];
    
    SMBaseUnit *ampere = [[SMBaseUnit alloc] init];
    [ampere setSymbol:@"A"];
    [ampere setName:@"ampere"];
    [ampere setSystem:@"SI"];
    [ampere setDimension:@"electrical current"];
    [ampere setFundamental:ampere];
    
    SMBaseUnit *mole = [[SMBaseUnit alloc] init];
    [mole setSymbol:@"mol"];
    [mole setName:@"mole"];
    [mole setSystem:@"SI"];
    [mole setDimension:@"quantity"];
    [mole setFundamental:mole];
    
    SMBaseUnit *candela = [[SMBaseUnit alloc] init];
    [candela setSymbol:@"cd"];
    [candela setName:@"candela"];
    [candela setSystem:@"SI"];
    [candela setDimension:@"luminous intensity"];
    [candela setFundamental:candela];
    
    SMBaseUnit *kilogram = [[SMBaseUnit alloc] init];
    [kilogram setSymbol:@"kg"];
    [kilogram setName:@"kilogram"];
    [kilogram setSystem:@"SI"];
    [kilogram setDimension:@"mass"];
    [kilogram setFundamental:kilogram];
    
    SMBaseUnit *gram = [SMBaseUnit scaledBaseUnitFromUnit:kilogram name:@"gram" symbol:@"g"  scale:10 staticRational:-3];
    
    NSArray *baseMetricUnits = @[second,meter,gram,kelvin,ampere];
    
    NSArray *siMultipleNames = @[@"deca",@"hecto",@"kilo",@"mega",@"giga",@"tera",@"peta",@"exa",@"zetta",@"yotta"];
    
    NSArray *siMultiplePrefixes = @[@"da",@"h",@"k",@"M",@"G",@"T",@"P",@"E",@"Z",@"Y"];
    
    NSArray *siMultipleFactors = @[@1,@2,@3,@6,@9,@12,@15,@18,@21,@24];
    
    NSArray *siFractionNames =
    @[@"deci",@"centi",@"milli",@"micro",@"nano",@"pico",@"femto",@"atto",@"zepto",@"yocto"];
    
    
    NSArray *siFractionPrefixes = @[@"d",@"c",@"m",@"μ",@"n",@"p",@"f",@"a",@"z",@"y"];
    
    NSArray *siFractionFactors = @[@(-1),@(-2),@(-3),@(-6),@(-9),@(-12),@(-15),@(-18),@(-21),@(-24)];
    
    for (SMBaseUnit *unit in baseMetricUnits) {
        [_baseUnits setObject:unit forKey:unit.symbol];
        
        for (NSUInteger i = 0; i < [siMultipleNames count]; i++) {
            NSString *symbol = [NSString stringWithFormat:@"%@%@",siMultiplePrefixes[i],unit.symbol];
            NSString *name = [NSString stringWithFormat:@"%@%@",siMultipleNames[i],unit.name];
            
            SMBaseUnit *baseUnit = [SMBaseUnit scaledBaseUnitFromUnit:unit name:name symbol:symbol scale:10 staticRational:([siMultipleFactors[i] intValue] + unit.staticRational) ];
            [_baseUnits setObject:baseUnit forKey:baseUnit.symbol];
        }
        
        for (NSUInteger i = 0; i < [siFractionNames count]; i++) {
            NSString *symbol = [NSString stringWithFormat:@"%@%@",siFractionPrefixes[i],unit.symbol];
            NSString *name = [NSString stringWithFormat:@"%@%@",siFractionNames[i],unit.name];
            
            SMBaseUnit *baseUnit = [SMBaseUnit scaledBaseUnitFromUnit:unit name:name symbol:symbol scale:10 staticRational:([siFractionFactors[i] intValue] + unit.staticRational) ];
            [_baseUnits setObject:baseUnit forKey:baseUnit.symbol];
        }
        
    }
    
    //Non SI Derived Units
    
    SMDerivedUnit *liter = [[SMDerivedUnit alloc] init];
    [liter setSymbol:@"L"];
    [liter setName:@"liter"];
    [liter setSystem:@"SI"];
    [liter setScale:10];
    SMBaseUnit *decameter = [_baseUnits objectForKey:@"dm"];
    [liter setBaseUnitsWithDimensionExponents:@{decameter:@3}];
    [liter setDimension:@"volume"];
    [liter setFundamental:liter];
    
    //SI Derived Units with Special Names

    SMDerivedUnit *newton = [[SMDerivedUnit alloc] init];
    [newton setSymbol:@"N"];
    [newton setName:@"newton"];
    [newton setSystem:@"SI"];
    [newton setScale:10];
    [newton setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@1,second:@(-2)}];
    [newton setDimension:@"force"];
    [newton setFundamental:newton];
    
    SMDerivedUnit *hertz = [[SMDerivedUnit alloc] init];
    [hertz setSymbol:@"Hz"];
    [hertz setName:@"hertz"];
    [hertz setSystem:@"SI"];
    [hertz setScale:10];
    [hertz setBaseUnitsWithDimensionExponents:@{second:@(-1)}];
    [hertz setDimension:@"frequency"];
    [hertz setFundamental:hertz];
    
    SMDerivedUnit *pascalUnit = [[SMDerivedUnit alloc] init]; //pascal is a keyword, thus pascalUnit
    [pascalUnit setSymbol:@"Pa"];
    [pascalUnit setName:@"pascal"];
    [pascalUnit setSystem:@"SI"];
    [pascalUnit setScale:10];
    [pascalUnit setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@(-1),second:@(-2)}];
    [pascalUnit setDimension:@"pressure"];
    [pascalUnit setFundamental:pascalUnit];
    
    SMDerivedUnit *joule = [[SMDerivedUnit alloc] init];
    [joule setSymbol:@"J"];
    [joule setName:@"joule"];
    [joule setSystem:@"SI"];
    [joule setScale:10];
    [joule setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@2,second:@(-2)}];
    [joule setDimension:@"energy"];
    [joule setFundamental:joule];
    
    SMDerivedUnit *watt = [[SMDerivedUnit alloc] init];
    [watt setSymbol:@"W"];
    [watt setName:@"watt"];
    [watt setSystem:@"SI"];
    [watt setScale:10];
    [watt setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@2,second:@(-3)}];
    [watt setDimension:@"power"];
    [watt setFundamental:watt];
    
    SMDerivedUnit *coulomb = [[SMDerivedUnit alloc] init];
    [coulomb setSymbol:@"C"];
    [coulomb setName:@"coulomb"];
    [coulomb setSystem:@"SI"];
    [coulomb setScale:10];
    [coulomb setBaseUnitsWithDimensionExponents:@{second:@1,ampere:@1}];
    [coulomb setDimension:@"electric charge"];
    [coulomb setFundamental:coulomb];
    
    SMDerivedUnit *volt = [[SMDerivedUnit alloc] init];
    [volt setSymbol:@"V"];
    [volt setName:@"volt"];
    [volt setSystem:@"SI"];
    [volt setScale:10];
    [volt setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@2,second:@(-3),ampere:@(-1)}];
    [volt setDimension:@"voltage"];
    [volt setFundamental:volt];
    
    SMDerivedUnit *farad = [[SMDerivedUnit alloc] init];
    [farad setSymbol:@"F"];
    [farad setName:@"farad"];
    [farad setSystem:@"SI"];
    [farad setScale:10];
    [farad setBaseUnitsWithDimensionExponents:@{kilogram:@(-1),meter:@(-2),second:@4,ampere:@2}];
    [farad setDimension:@"electric capacitance"];
    [farad setFundamental:farad];
    
    SMDerivedUnit *ohm = [[SMDerivedUnit alloc] init];
    [ohm setSymbol:@"Ω"]; //opt+z
    [ohm setName:@"ohm"];
    [ohm setSystem:@"SI"];
    [ohm setScale:10];
    [ohm setBaseUnitsWithDimensionExponents:@{kilogram:@1,meter:@2,second:@(-3),ampere:@(-2)}];
    [ohm setDimension:@"electric resistance"];
    [ohm setFundamental:ohm];

    
    NSArray *derivedMetricUnits = @[liter,newton,hertz,pascalUnit,joule,watt,coulomb,volt,farad,ohm];
    
    for (SMDerivedUnit *unit in derivedMetricUnits) {
        [_derivedUnits setObject:unit forKey:unit.symbol];

        for (NSUInteger i = 0; i < [siMultipleNames count]; i++) {
            NSString *symbol = [NSString stringWithFormat:@"%@%@",siMultiplePrefixes[i],unit.symbol];
            NSString *name = [NSString stringWithFormat:@"%@%@",siMultipleNames[i],unit.name];
            SMDerivedUnit *baseUnit = [SMDerivedUnit scaledUnitFromUnit:unit name:name symbol:symbol scale:10 staticRational:([siMultipleFactors[i] intValue] + unit.staticRational) ];
            [_derivedUnits setObject:baseUnit forKey:baseUnit.symbol];
        }
        
        for (NSUInteger i = 0; i < [siFractionNames count]; i++) {
            NSString *symbol = [NSString stringWithFormat:@"%@%@",siFractionPrefixes[i],unit.symbol];
            NSString *name = [NSString stringWithFormat:@"%@%@",siFractionNames[i],unit.name];
            
            SMDerivedUnit *baseUnit = [SMDerivedUnit scaledUnitFromUnit:unit name:name symbol:symbol scale:10 staticRational:([siFractionFactors[i] intValue] + unit.staticRational) ];
            [_derivedUnits setObject:baseUnit forKey:baseUnit.symbol];
        }
        
    }
    
    SMBaseUnit *celsius = [[SMBaseUnit alloc] init];
    [celsius setSymbol:@"C"];
    [celsius setName:@"celsius"];
    [celsius setSystem:@"SI"];
    [celsius setDimension:@"temperature"];
    [celsius setFundamental:celsius];
    
    
    SMBaseUnit *angstrom = [SMBaseUnit scaledBaseUnitFromUnit:meter
                                                     name:@"angstrom"
                                                   symbol:@"Å"
                                                    scale:10
                                           staticRational:-10];
    
    
    SMBaseUnit *naticalMile = [SMBaseUnit scaledBaseUnitFromUnit:meter
                                                           name:@"naticalMile"
                                                         symbol:@"NM"
                                                          scale:1
                                                 staticRational:1852];
    
    SMBaseUnit *year = [SMBaseUnit scaledBaseUnitFromUnit:second
                                                    name:@"year"
                                                  symbol:@"y"
                                                   scale:31557600
                                          staticRational:1];
    
    SMBaseUnit *day = [SMBaseUnit scaledBaseUnitFromUnit:second
                                                         name:@"day"
                                                       symbol:@"d"
                                                        scale:86400
                                               staticRational:1];
    
    SMBaseUnit *hour = [SMBaseUnit scaledBaseUnitFromUnit:second
                                                    name:@"hour"
                                                  symbol:@"h"
                                                   scale:60
                                          staticRational:2];
    
    SMBaseUnit *minute = [SMBaseUnit scaledBaseUnitFromUnit:second
                                                     name:@"minute"
                                                   symbol:@"min"
                                                    scale:60
                                           staticRational:1];
    
    SMBaseUnit *ton = [SMBaseUnit scaledBaseUnitFromUnit:kilogram
                                                       name:@"metric ton" //TODO: add alais tonne
                                                     symbol:@"t"
                                                      scale:1000
                                             staticRational:1];


    [_baseUnits addEntriesFromDictionary:@{celsius.symbol:celsius
     ,angstrom.symbol:angstrom
     ,naticalMile.symbol:naticalMile
     ,year.symbol:year
     ,day.symbol:day
     ,hour.symbol:hour
     ,minute.symbol:minute
     ,ton.symbol:ton}];

    SMDerivedUnit *knot = [[SMDerivedUnit alloc] init];
    [knot setSymbol:@"kn"];
    [knot setName:@"knot"];
    [knot setSystem:@"US"];
    [knot setScale:10];
    [knot setBaseUnitsWithDimensionExponents:@{naticalMile:@1,hour:@(-1),}];
    [knot setDimension:@"velocity"];
    [knot setFundamental:knot];

    SMDerivedUnit *bar = [SMDerivedUnit scaledUnitFromUnit:pascalUnit
                                                      name:@"bar"
                                                    symbol:@"bar"
                                                     scale:10
                                            staticRational:5];
    
    SMDerivedUnit *mmHg = [SMDerivedUnit scaledUnitFromUnit:pascalUnit
                                                      name:@"millimeter of mercury"
                                                    symbol:@"mmHg"
                                                     scale:(13.5951 * 9.80665)
                                            staticRational:1];
    
    SMDerivedUnit *torr = [SMDerivedUnit scaledUnitFromUnit:pascalUnit
                                                       name:@"torr"
                                                     symbol:@"Torr"
                                                      scale:(101325/760)
                                             staticRational:1];
    

    [_derivedUnits addEntriesFromDictionary:@{knot.symbol:knot
     ,bar.symbol:bar
     ,mmHg.symbol:mmHg
     ,torr.symbol:torr}];
    

    SMBaseUnit *pound = [[SMBaseUnit alloc] init];
    [pound setSymbol:@"lb"];
    [pound setName:@"pound"];
    [pound setSystem:@"US"];
    [pound setScale:10];
    [pound setDimension:@"mass"];
    [pound setFundamental:pound];
    
    SMBaseUnit *ounce = [SMBaseUnit scaledBaseUnitFromUnit:pound
                                                      name:@"ounce"
                                                    symbol:@"oz"
                                                     scale:2
                                            staticRational:-4];
    
    
    SMBaseUnit *dram = [SMBaseUnit scaledBaseUnitFromUnit:pound
                                                     name:@"dram"
                                                   symbol:@"dr"
                                                    scale:16
                                           staticRational:-2];
    
    SMBaseUnit *grain = [SMBaseUnit scaledBaseUnitFromUnit:pound
                                                      name:@"grain"
                                                    symbol:@"gr"
                                                     scale:7000
                                            staticRational:-1];

    SMBaseUnit *hundredweight = [SMBaseUnit scaledBaseUnitFromUnit:pound
                                                              name:@"hundredweight"
                                                            symbol:@"cwt"
                                                             scale:100
                                                    staticRational:1];
    
    SMBaseUnit *USton = [SMBaseUnit scaledBaseUnitFromUnit:pound
                                                    name:@"US ton"
                                                  symbol:@"ton"
                                                   scale:100
                                          staticRational:1];

    [_baseUnits addEntriesFromDictionary:@{pound.symbol:pound
     ,ounce.symbol:ounce
     ,dram.symbol:dram
     ,grain.symbol:grain
     ,hundredweight.symbol:hundredweight
     ,USton.symbol:USton}];
    

    SMBaseUnit *fahrenheit = [[SMBaseUnit alloc] init];
    [fahrenheit setSymbol:@"F"];
    [fahrenheit setName:@"fahrenheit"];
    [fahrenheit setSystem:@"US"];
    [fahrenheit setDimension:@"temperature"];
    [fahrenheit setFundamental:fahrenheit];
    
    [_baseUnits setObject:fahrenheit forKey:fahrenheit.symbol];

    
    SMBaseUnit *yard = [[SMBaseUnit alloc] init];
    [yard setSymbol:@"yd"];
    [yard setName:@"yard"];
    [yard setSystem:@"US"];
    [yard setScale:10];
    [yard setDimension:@"length"];
    [yard setFundamental:yard];
    
    SMBaseUnit *foot = [SMBaseUnit scaledBaseUnitFromUnit:yard
                                                     name:@"foot"
                                                   symbol:@"ft"
                                                    scale:3
                                           staticRational:-1];
    
    SMBaseUnit *inch = [SMBaseUnit scaledBaseUnitFromUnit:yard
                                                     name:@"inch"
                                                   symbol:@"in"
                                                    scale:36
                                           staticRational:-1];
    
    SMBaseUnit *mile = [SMBaseUnit scaledBaseUnitFromUnit:yard
                                                     name:@"mile"
                                                   symbol:@"mi"
                                                    scale:1760
                                           staticRational:1];
    
    SMBaseUnit *furlong = [SMBaseUnit scaledBaseUnitFromUnit:yard
                                                     name:@"furlong"
                                                   symbol:@"fur"
                                                    scale:220
                                           staticRational:1];
    
    SMBaseUnit *yardsInOneDimensionOfAPint = [SMBaseUnit scaledBaseUnitFromUnit:yard
                                                        name:@"yardsInOneDimensionOfAPint"
                                                      symbol:@"YIODOAP"
                                                       scale:11.7349286
                                              staticRational:-1];
    
    [_baseUnits addEntriesFromDictionary:@{yard.symbol:yard
     ,foot.symbol:foot
     ,inch.symbol:inch
     ,mile.symbol:mile
     ,furlong.symbol:furlong
     ,yardsInOneDimensionOfAPint.symbol:yardsInOneDimensionOfAPint}];
    
    SMDerivedUnit *pint = [[SMDerivedUnit alloc] init];
    [pint setSymbol:@"pt"];
    [pint setName:@"pint"];
    [pint setSystem:@"US"];
    [pint setScale:10];
    [pint setBaseUnitsWithDimensionExponents:@{yardsInOneDimensionOfAPint:@3}];
    [pint setDimension:@"volume"];
    [pint setFundamental:pint];

    SMDerivedUnit *cup = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"cup"
                                                    symbol:@"cp"
                                                     scale:2
                                            staticRational:-1];
    
    SMDerivedUnit *fluidDram = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"fluid dram"
                                                    symbol:@"fl dr"
                                                     scale:2
                                            staticRational:-7];
    
    SMDerivedUnit *fluidOunce = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"fluid ounce"
                                                    symbol:@"fl oz"
                                                     scale:16
                                            staticRational:-1];
    
    SMDerivedUnit *gallon = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"gallon"
                                                    symbol:@"gal"
                                                     scale:2
                                            staticRational:3];
    [gallon setFullName:@"US (Liquid) Gallons"];
    
    SMDerivedUnit *gill = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"gill"
                                                    symbol:@"gi"
                                                     scale:2
                                            staticRational:-2];
    
    SMDerivedUnit *quart = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"quart"
                                                    symbol:@"qt"
                                                     scale:2
                                            staticRational:1];
    
    SMDerivedUnit *tablespoon = [SMDerivedUnit scaledUnitFromUnit:pint
                                                      name:@"tablespoon"
                                                    symbol:@"Tbsp"
                                                     scale:2
                                            staticRational:-5];
    
    SMDerivedUnit *teaspoon = [SMDerivedUnit scaledUnitFromUnit:pint
                                                             name:@"teaspoon"
                                                           symbol:@"tsp"
                                                            scale:96
                                                   staticRational:-1];
    
    [_derivedUnits addEntriesFromDictionary:@{pint.symbol:pint
     ,cup.symbol:cup
     ,fluidDram.symbol:fluidDram
     ,fluidOunce.symbol:fluidOunce
     ,gallon.symbol:gallon
     ,gill.symbol:gill
     ,quart.symbol:quart
     ,tablespoon.symbol:tablespoon
     ,teaspoon.symbol:teaspoon}];

    
    //1 pdl = 0.138254954376 N exactly.
    SMDerivedUnit *poundal = [[SMDerivedUnit alloc] init];
    [poundal setSymbol:@"pdl"];
    [poundal setName:@"poundal"];
    [poundal setSystem:@"US"];
    [poundal setScale:10];
    [poundal setBaseUnitsWithDimensionExponents:@{pound:@1,foot:@1,second:@(-2)}];
    [poundal setDimension:@"force"];
    [poundal setFundamental:poundal];
    
    SMDerivedUnit *poundForce = [SMDerivedUnit scaledUnitFromUnit:poundal
                                                             name:@"pound force"
                                                           symbol:@"lbf"
                                                            scale:32.174049
                                                   staticRational:1];

    
    
    SMDerivedUnit *poundsPerSquareInch = [[SMDerivedUnit alloc] init];
    [poundsPerSquareInch setSymbol:@"psi"];
    [poundsPerSquareInch setName:@"pounds per square inch"];
    [poundsPerSquareInch setSystem:@"US"];
    [poundsPerSquareInch setScale:10];
    [poundsPerSquareInch setBaseUnitsWithDimensionExponents:@{poundForce:@1,inch:@(-2)}];
    [poundsPerSquareInch setDimension:@"pressure"];
    [poundsPerSquareInch setFundamental:poundsPerSquareInch];
    
    SMDerivedUnit *milesPerHour = [[SMDerivedUnit alloc] init];
    [milesPerHour setSymbol:@"mph"];
    [milesPerHour setName:@"miles per hour"];
    [milesPerHour setSystem:@"US"];
    [milesPerHour setScale:10];
    [milesPerHour setBaseUnitsWithDimensionExponents:@{mile:@1,hour:@(-1)}];
    [milesPerHour setDimension:@"velocity"];
    [milesPerHour setFundamental:milesPerHour];
    
    SMDerivedUnit *milesPerGallon = [[SMDerivedUnit alloc] init];
    [milesPerGallon setSymbol:@"mpg"];
    [milesPerGallon setName:@"miles per gallon"];
    [milesPerGallon setSystem:@"US"];
    [milesPerGallon setScale:10];
    [milesPerGallon setBaseUnitsWithDimensionExponents:@{mile:@1,gallon:@(-1)}];
    [milesPerGallon setDimension:@"fuel economy"];
    [milesPerGallon setFundamental:milesPerGallon];
    
    
    [_derivedUnits addEntriesFromDictionary:@{poundal.symbol:poundal
     ,poundForce.symbol:poundForce
     ,poundsPerSquareInch.symbol:poundsPerSquareInch
     ,milesPerHour.symbol:milesPerHour
     ,milesPerGallon.symbol:milesPerGallon}];
    
    
    
    
    //Mass Conversions
    
    SMConversionFactor *poundToKilogram = [[SMConversionFactor alloc] initWithSourceUnit:pound targetUnit:kilogram scaleFactor:0.45359237 offset:0];
    SMConversionFactor *kilogramToPound = [poundToKilogram inverseConversionFactor];
    
    [_conversions setObject:poundToKilogram forKey:poundToKilogram.identifier];
    [_conversions setObject:kilogramToPound forKey:kilogramToPound.identifier];
    
    
    //Temperature Conversions
    
    SMConversionFactor *celsiusToKelvin = [[SMConversionFactor alloc] initWithSourceUnit:celsius targetUnit:kelvin scaleFactor:1 offset:273.15];
    SMConversionFactor *kelvinToCelsius = [celsiusToKelvin inverseConversionFactor];
    
    SMConversionFactor *celsiusToFahrenheit = [[SMConversionFactor alloc] initWithSourceUnit:celsius targetUnit:fahrenheit scaleFactor:9.0/5.0 offset:32];
    SMConversionFactor *fahrenheitToCelsius = [celsiusToFahrenheit inverseConversionFactor];
    
    SMConversionFactor *kelvinToFahrenheit = [[SMConversionFactor alloc] initWithSourceUnit:kelvin targetUnit:fahrenheit scaleFactor:9.0/5.0 offset:-459.67];
    SMConversionFactor *fahrenheitToKelvin = [celsiusToFahrenheit inverseConversionFactor];
    
    
    [_conversions setObject:celsiusToKelvin forKey:celsiusToKelvin.identifier];
    [_conversions setObject:kelvinToCelsius forKey:kelvinToCelsius.identifier];
    
    [_conversions setObject:celsiusToFahrenheit forKey:celsiusToFahrenheit.identifier];
    [_conversions setObject:fahrenheitToCelsius forKey:fahrenheitToCelsius.identifier];
    
    [_conversions setObject:kelvinToFahrenheit forKey:kelvinToFahrenheit.identifier];
    [_conversions setObject:fahrenheitToKelvin forKey:fahrenheitToKelvin.identifier];
    
    
    //Length Conversion
    
    SMConversionFactor *yardToMeter = [[SMConversionFactor alloc] initWithSourceUnit:yard targetUnit:meter scaleFactor:0.9144 offset:0];
    SMConversionFactor *meterToYard = [yardToMeter inverseConversionFactor];
    
    [_conversions setObject:yardToMeter forKey:yardToMeter.identifier];
    [_conversions setObject:meterToYard forKey:meterToYard.identifier];
    
    
    //Derived Unit Conversions
    
    SMConversionFactor *poundalToNewton = [[SMConversionFactor alloc] initWithSourceUnit:poundal targetUnit:newton scaleFactor:0.138254954376 offset:0];
    SMConversionFactor *newtonToPoundal = [poundalToNewton inverseConversionFactor];
    
    [_conversions setObject:poundalToNewton forKey:poundalToNewton.identifier];
    [_conversions setObject:newtonToPoundal forKey:newtonToPoundal.identifier];
    

    double speedOfLightConstantValue = 299792458.0;
    SMQuantity *speedOfLight = [[SMQuantity alloc] init];
    [speedOfLight setValue:@(speedOfLightConstantValue)];
    SMDerivedUnit *metersPerSecond = [[SMDerivedUnit alloc] init];
    metersPerSecond.baseUnitsWithDimensionExponents = @{meter:@1,second:@(-1)};
    [metersPerSecond setDimension:@"velocity"];
    [speedOfLight setUnit:metersPerSecond];
    
    //μ0, commonly called the vacuum permeability, permeability of free space, or magnetic constant
    double magneticConstantValue = 4 * M_PI * pow(10, -7);
    SMQuantity *magneticConstant = [[SMQuantity alloc] init];
    [magneticConstant setValue:@(magneticConstantValue)];
    SMDerivedUnit *newtonsPerAmpereSquared = [[SMDerivedUnit alloc] init];
    newtonsPerAmpereSquared.baseUnitsWithDimensionExponents = @{kilogram:@1,meter:@1,second:@(-2),ampere:@(-2)};
    [newtonsPerAmpereSquared setDimension:@"force over electrical current squared"];
    [magneticConstant setUnit:newtonsPerAmpereSquared];
    
    //The physical constant ε0, commonly called the vacuum permittivity, permittivity of free space or electric constant
    double electricConstantValue = 1.0 / (magneticConstantValue * pow(speedOfLightConstantValue, 2));
    SMQuantity *electricConstant = [[SMQuantity alloc] init];
    [electricConstant setValue:@(electricConstantValue)];
    SMDerivedUnit *faradsPerMeter = [[SMDerivedUnit alloc] init];
    faradsPerMeter.baseUnitsWithDimensionExponents = @{kilogram:@(-1),meter:@(-2),second:@4,ampere:@2,meter:@(-1)};
    [faradsPerMeter setDimension:@"electric capacitance over length"];
    [electricConstant setUnit:faradsPerMeter];
    
    //The impedance of free space, Z0, is a physical constant relating the magnitudes of the electric and magnetic fields of electromagnetic radiation travelling through free space
    double characteristicImpedanceOfVacuumValue = electricConstantValue * speedOfLightConstantValue;
    SMQuantity *characteristicImpedanceOfVacuum = [[SMQuantity alloc] init];
    [characteristicImpedanceOfVacuum setValue:@(characteristicImpedanceOfVacuumValue)];
    [characteristicImpedanceOfVacuum setUnit:ohm];
    
    // Newtonian constant of gravitation
    double gravitationalConstantValue = pow(6.67428,-11);
    SMQuantity *gravitationalConstant = [[SMQuantity alloc] init];
    [gravitationalConstant setValue:@(speedOfLightConstantValue)];
    SMDerivedUnit *metersCubedPerKilogramSecond = [[SMDerivedUnit alloc] init];
    metersCubedPerKilogramSecond.baseUnitsWithDimensionExponents = @{meter:@3,kilogram:@(-1),second:@(-2)};
    [metersCubedPerKilogramSecond setDimension:@"force square length over square mass"];
    [gravitationalConstant setUnit:metersCubedPerKilogramSecond];

    // Planck constant
    double plankConstantValue = 6.6260695729;
    SMQuantity *plankConstant = [[SMQuantity alloc] init];
    [plankConstant setValue:@(plankConstantValue)];
    SMDerivedUnit *jouleSeconds = [[SMDerivedUnit alloc] init];
    jouleSeconds.baseUnitsWithDimensionExponents = @{kilogram:@1,meter:@2,second:@(-1)};
    [jouleSeconds setDimension:@"energy time"];
    [plankConstant setUnit:jouleSeconds];
    
    // Dirac constant
    double diracConstantValue = plankConstantValue / (M_PI * 2);
    SMQuantity *diracConstant = [[SMQuantity alloc] init];
    [diracConstant setValue:@(diracConstantValue)];
    [diracConstant setUnit:jouleSeconds];
    
    // Planck mass
    double plankMassValue = sqrt(diracConstantValue * speedOfLightConstantValue / gravitationalConstantValue);
    SMQuantity *plankMass = [[SMQuantity alloc] init];
    [plankConstant setValue:@(plankMassValue)];
    SMDerivedUnit *kilogramDerivedUnit = [[SMDerivedUnit alloc] init];
    kilogramDerivedUnit.baseUnitsWithDimensionExponents = @{kilogram:@1};
    [kilogramDerivedUnit setDimension:@"energy time"];
    [plankMass setUnit:kilogramDerivedUnit];
    
    //Gas constant J K−1 mol−1
    double gasConstantValue = 8.314462175;
    SMQuantity *gasConstant = [[SMQuantity alloc] init];
    [gasConstant setValue:@(gasConstantValue)];
    SMDerivedUnit *joulesPerKelvinSecond = [[SMDerivedUnit alloc] init];
    joulesPerKelvinSecond.baseUnitsWithDimensionExponents = @{kilogram:@1,meter:@2,second:@(-3),kelvin:@(-1)};
    [joulesPerKelvinSecond setDimension:@"energy over temperate time"];
    [gasConstant setUnit:jouleSeconds];
    
    //Avogadro constant
    double avogadroConstantValue = 6.0221412927 * pow(10, 23);
    SMQuantity *avogadroConstant = [[SMQuantity alloc] init];
    [avogadroConstant setValue:@(avogadroConstantValue)];
    SMDerivedUnit *inverseMoles = [[SMDerivedUnit alloc] init];
    inverseMoles.baseUnitsWithDimensionExponents = @{mole:@(-1)};
    [inverseMoles setDimension:@"inverse amount"];
    [avogadroConstant setUnit:inverseMoles];
    
    //Boltzmann constant
    double boltzmannConstantValue = gasConstantValue / avogadroConstantValue;
    SMQuantity *boltzmannConstant = [[SMQuantity alloc] init];
    [boltzmannConstant setValue:@(avogadroConstantValue)];
    SMDerivedUnit *joulesPerKelvin = [[SMDerivedUnit alloc] init];
    joulesPerKelvin.baseUnitsWithDimensionExponents = @{kilogram:@1,meter:@2,second:@(-2),kelvin:@(-1)};
    [joulesPerKelvin setDimension:@"energy over temperate"];
    [boltzmannConstant setUnit:joulesPerKelvin];
    
    // Planck temperature
    double plankTemperatureValue = plankMassValue * pow(speedOfLightConstantValue, 2) / boltzmannConstantValue;
    SMQuantity *plankTemperature = [[SMQuantity alloc] init];
    [plankTemperature setValue:@(plankTemperatureValue)];
    SMDerivedUnit *kelvinDerivedUnit = [[SMDerivedUnit alloc] init];
    kelvinDerivedUnit.baseUnitsWithDimensionExponents = @{kelvin:@1};
    [kelvinDerivedUnit setDimension:@"temperature"];
    [plankTemperature setUnit:kelvinDerivedUnit];
    
    // Planck length
    double plankLengthValue = sqrt(diracConstantValue * gravitationalConstantValue / pow(speedOfLightConstantValue, 3));
    SMQuantity *plankLength = [[SMQuantity alloc] init];
    [plankLength setValue:@(plankLengthValue)];
    SMDerivedUnit *meterDerivedUnit = [[SMDerivedUnit alloc] init];
    meterDerivedUnit.baseUnitsWithDimensionExponents = @{meter:@1};
    [meterDerivedUnit setDimension:@"length"];
    [plankLength setUnit:meterDerivedUnit];
    
    
    // Planck time
    double plankTimeValue = sqrt(diracConstantValue * gravitationalConstantValue / pow(speedOfLightConstantValue, 5));
    SMQuantity *plankTime = [[SMQuantity alloc] init];
    [plankTime setValue:@(plankTimeValue)];
    SMDerivedUnit *secondDerivedUnit = [[SMDerivedUnit alloc] init];
    secondDerivedUnit.baseUnitsWithDimensionExponents = @{second:@1};
    [secondDerivedUnit setDimension:@"time"];
    [plankTime setUnit:secondDerivedUnit];
    
    _constants = [@{@"c":speedOfLight, @"speed of light":speedOfLight,
                   @"μ0":magneticConstant, @"magnetic constant":magneticConstant, @"vacuum permeability":magneticConstant,
                   @"ε0":electricConstant, @"electric constant":electricConstant, @"vacuum permittivity":electricConstant,
                   @"Z0":characteristicImpedanceOfVacuum, @"characteristic impedance of vacuum":characteristicImpedanceOfVacuum, @"impedance of free space":characteristicImpedanceOfVacuum,
                   @"G":gravitationalConstant, @"universal gravitational constant":gravitationalConstant, @"Newton's constant":gravitationalConstant,
                   @"Plank constant":plankConstant,
                   @"hbar":diracConstant, @"Dirac Constant":diracConstant, @"reduced Planck constant":diracConstant,
                   @"Plank mass":plankMass,
                   @"R":gasConstant, @"gass constant":gasConstant,
                   @"NA":avogadroConstant, @"Avogadro constant":avogadroConstant,
                   @"k":boltzmannConstant, @"Boltzmann constant":boltzmannConstant,
                   @"Plank temperature":plankTemperature,
                   @"Plank length":plankLength,
                   @"Plank time":plankTime
                   } mutableCopy];

        
        for (SMDerivedUnit *unit in [_derivedUnits allValues]) {
            [_derivedUnitNames setObject:unit forKey:unit.name];
            [_derivedUnitSymbols setObject:unit forKey:unit.symbol];
            [_derivedUnitIdentifiers setObject:unit forKey:unit.identifier];
            
            [_allDerivedUnits setObject:unit forKey:unit.name];
            [_allDerivedUnits setObject:unit forKey:unit.symbol];
            [_allDerivedUnits setObject:unit forKey:unit.identifier];
        }

        for (SMBaseUnit *unit in [_baseUnits allValues]) {
            [_baseUnitNames setObject:unit forKey:unit.name];
            [_baseUnitSymbols setObject:unit forKey:unit.symbol];
            [_baseUnitIdentifiers setObject:unit forKey:unit.identifier];
            
            [_allBaseUnits setObject:unit forKey:unit.name];
            [_allBaseUnits setObject:unit forKey:unit.symbol];
            [_allBaseUnits setObject:unit forKey:unit.identifier];
        }
    
}

#pragma mark Built-In Functions

- (SMBaseUnit *)baseUnitFromString:(NSString *)unitString
{
    return [self.allBaseUnits objectForKey:unitString];
}

- (SMDerivedUnit *)derivedUnitFromString:(NSString *)unitString
{
    
    SMBaseUnit *baseUnit = [[self.allBaseUnits objectForKey:unitString] copy];
    
    if (baseUnit == nil) {
        SMDerivedUnit *derviedUnit = [[self.allDerivedUnits objectForKey:unitString] copy];
        if (derviedUnit == nil) {
            return nil;
        }
        return derviedUnit;
    }
    
    SMDerivedUnit *unit = [[SMDerivedUnit alloc] init];
    
    [unit setBaseUnitsWithDimensionExponents:@{baseUnit: @1}];

    
    [unit setName:baseUnit.name];
    [unit setSymbol:baseUnit.symbol];
    [unit setSystem:baseUnit.system];
    [unit setFundamental:unit.fundamental];

    return unit;

}

- (SMBaseUnit *)baseUnitFromBaseUnitIdentifier:(NSString *)baseUnitIdentifier
{
    return [_baseUnitIdentifiers objectForKey:baseUnitIdentifier];
}

- (NSNumber *)evaluateNumber:(NSNumber *)firstNumber withNumber:(NSNumber *)secondNumber usingOperator:(NSString *)operatorName
{
    if ([operatorName isEqualToString:@"multiply"]) {
        return [NSNumber numberWithDouble:[firstNumber doubleValue] * [secondNumber doubleValue]];
    } else if ([operatorName isEqualToString:@"divide"]) {
        return [NSNumber numberWithDouble:[firstNumber doubleValue] / [secondNumber doubleValue]];
    } else if ([operatorName isEqualToString:@"add"]) {
        return [NSNumber numberWithDouble:[firstNumber doubleValue] + [secondNumber doubleValue]];
    } else if ([operatorName isEqualToString:@"subtract"]) {
        return [NSNumber numberWithDouble:[firstNumber doubleValue] - [secondNumber doubleValue]];
    }
    
    return nil;
}

- (NSNumber *)evaluateDimension:(NSNumber *)firstDimension withDimension:(NSNumber *)secondDimension usingOperator:(NSString *)operatorName
{
    if ([operatorName isEqualToString:@"multiply"]) {
        NSNumber *sumOfDimensions = @([firstDimension intValue]+[secondDimension intValue]);
        if ([sumOfDimensions isEqualToNumber:@0]) {
            return nil;
        }
        return sumOfDimensions;
    } else if ([operatorName isEqualToString:@"divide"]) {
        NSNumber *differenceOfDimensions = @([firstDimension intValue]-[secondDimension intValue]);
        if ([differenceOfDimensions isEqualToNumber:@0]) {
            return nil;
        }
        return differenceOfDimensions;
    } else if ([operatorName isEqualToString:@"add"]) {
        if ([firstDimension isEqualToNumber:secondDimension] && ![firstDimension isEqualToNumber:@0]) {
            return firstDimension;
        }
        return nil;
    } else if ([operatorName isEqualToString:@"subtract"]) {
        if ([firstDimension isEqualToNumber:secondDimension] && ![firstDimension isEqualToNumber:@0]) {
            return firstDimension;
        }
        return nil;
    }
    
    return nil;
}

- (NSArray *)evaluateDimensionExponents:(NSArray *)firstDimensionExponents withDimensionExponents:(NSArray *)secondDimensionExponents usingOperator:(NSString *)operatorName
{
    NSMutableArray *resultDimensionExponents = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [firstDimensionExponents count]; i++) {
        [resultDimensionExponents addObject:[self evaluateDimension:[firstDimensionExponents objectAtIndex:i]
                                                      withDimension:[secondDimensionExponents objectAtIndex:i]
                                                      usingOperator:operatorName]];
        
    }
    return resultDimensionExponents;
}

- (SMQuantity *)evaluateQuantity:(SMQuantity *)firstQuantity withQuantity:(SMQuantity *)secondQuantity usingOperator:(NSString *)operatorName
{
    SMQuantity *result = [[SMQuantity alloc] init];
    result.unit = [[SMDerivedUnit alloc] init];
    
    if ([operatorName isEqualToString:@"add"] || [operatorName isEqualToString:@"subtract"]) {
        if (![firstQuantity.unit isCommensurableToDerivedUnit:secondQuantity.unit]) {
            return nil;
        }
    }

    if (firstQuantity.unit.baseUnitsWithDimensionExponents == nil && secondQuantity.unit.baseUnitsWithDimensionExponents == nil) { //two scalars
        [result setValue:[self evaluateNumber:firstQuantity.value withNumber:secondQuantity.value usingOperator:operatorName]];// [NSNumber numberWithDouble:[firstQuantity.value doubleValue] * [secondQuantity.value doubleValue]]];
        return result;
    }
    
    if (firstQuantity.unit.baseUnitsWithDimensionExponents == nil || secondQuantity.unit.baseUnitsWithDimensionExponents == nil) { //scalar and unit
        [result setValue:[self evaluateNumber:firstQuantity.value withNumber:secondQuantity.value usingOperator:operatorName]];// [NSNumber numberWithDouble:[firstQuantity.value doubleValue] * [secondQuantity.value doubleValue]]];
        
        NSMutableDictionary *resultBaseUnitsWithDimensionExponents = [[NSMutableDictionary alloc] init];
        if (firstQuantity.unit.baseUnitsWithDimensionExponents != nil) {
            for (SMBaseUnit *baseUnit in firstQuantity.unit.baseUnitsWithDimensionExponents) {
                NSNumber *dimensionExponent = [self evaluateDimension:firstQuantity.unit.baseUnitsWithDimensionExponents[baseUnit] withDimension:@0 usingOperator:operatorName];
                [resultBaseUnitsWithDimensionExponents setObject:dimensionExponent forKey:baseUnit];
            }
        } else {
            for (SMBaseUnit *baseUnit in secondQuantity.unit.baseUnitsWithDimensionExponents) {
                NSNumber *dimensionExponent = [self evaluateDimension:@0 withDimension:secondQuantity.unit.baseUnitsWithDimensionExponents[baseUnit] usingOperator:operatorName];
                [resultBaseUnitsWithDimensionExponents setObject:dimensionExponent forKey:baseUnit];
            }
        }
        
        [result.unit setBaseUnitsWithDimensionExponents:resultBaseUnitsWithDimensionExponents];
        return result;
    }

    if ([firstQuantity.unit isEqual:secondQuantity.unit]) {
        [result setValue:[self evaluateNumber:firstQuantity.value withNumber:secondQuantity.value usingOperator:operatorName]];
        [result setUnit:[[SMDerivedUnit alloc] init]];
        if ([operatorName isEqualToString:@"subtract"]) { //so I don't have to handle nils
            return result;
        }
        
        NSMutableDictionary *resultBaseUnitsWithDimensionExponents = [[NSMutableDictionary alloc] init];
        for (SMBaseUnit *baseUnit in firstQuantity.unit.baseUnitsWithDimensionExponents) {
            NSNumber *dimensionExponent = [self evaluateDimension:firstQuantity.unit.baseUnitsWithDimensionExponents[baseUnit] withDimension:secondQuantity.unit.baseUnitsWithDimensionExponents[baseUnit] usingOperator:operatorName];
            [resultBaseUnitsWithDimensionExponents setObject:dimensionExponent forKey:baseUnit];
        }
        
        [result.unit setBaseUnitsWithDimensionExponents:resultBaseUnitsWithDimensionExponents];
        return result;

    }
    
    
    NSMutableDictionary *resultBaseUnitsWithDimensionExponents = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *secondQuantityBaseUnitsWithDimensionExponentsMinusFirstQuantityBaseUnitsWithDimensionExponents = [secondQuantity.unit.baseUnitsWithDimensionExponents mutableCopy];
    NSDictionary *firstDimensionsWithBaseUnits = [firstQuantity.unit dimensionsWithBaseUnits];
    NSDictionary *secondDimensionsWithBaseUnits = [secondQuantity.unit dimensionsWithBaseUnits];

    
    for (SMBaseUnit *firstBaseUnit in firstQuantity.unit.baseUnitsWithDimensionExponents) {
        NSNumber *firstDimensionExponent = firstQuantity.unit.baseUnitsWithDimensionExponents[firstBaseUnit];

        SMBaseUnit *matchingSecondBaseUnit = secondDimensionsWithBaseUnits[firstBaseUnit.dimension];
        if (matchingSecondBaseUnit) {
            NSNumber *convertedValue = [self valueByConvertingBaseUnit:matchingSecondBaseUnit toBaseUnit:firstBaseUnit withValue:secondQuantity.value]; //change to fundamental maybe
            if (convertedValue) {
                [secondQuantity setValue:convertedValue];
            } else {
                return nil;
            }
            
            NSNumber *secondDimensionExponent = secondQuantity.unit.baseUnitsWithDimensionExponents[matchingSecondBaseUnit];
            NSNumber *resultDimensionExponent = [self evaluateDimension:firstDimensionExponent withDimension:secondDimensionExponent usingOperator:operatorName];
            if (resultDimensionExponent) { //could be zero in which case nil is returned from evaluateDimension
                [resultBaseUnitsWithDimensionExponents setObject:resultDimensionExponent forKey:firstBaseUnit]; //change to fundamental when heterogenous units are supported
            }
            [secondQuantityBaseUnitsWithDimensionExponentsMinusFirstQuantityBaseUnitsWithDimensionExponents removeObjectForKey:matchingSecondBaseUnit];
            
        } else {
            [resultBaseUnitsWithDimensionExponents setObject:firstDimensionExponent forKey:firstBaseUnit];
        }
    }
    
    for (SMBaseUnit *secondBaseUnit in secondQuantityBaseUnitsWithDimensionExponentsMinusFirstQuantityBaseUnitsWithDimensionExponents) {
        NSNumber *secondDimensionExponent = secondQuantity.unit.baseUnitsWithDimensionExponents[secondBaseUnit];
        
        
        SMBaseUnit *matchingFirstBaseUnit = firstDimensionsWithBaseUnits[secondBaseUnit.dimension];
        if (matchingFirstBaseUnit) {
            NSNumber *convertedValue = [self valueByConvertingBaseUnit:secondBaseUnit toBaseUnit:matchingFirstBaseUnit withValue:secondQuantity.value];
            if (convertedValue) {
                [secondQuantity setValue:convertedValue];
            } else {
                return nil;
            }
            
            NSNumber *firstDimensionExponent = firstQuantity.unit.baseUnitsWithDimensionExponents[matchingFirstBaseUnit];
            NSNumber *resultDimensionExponent = [self evaluateDimension:firstDimensionExponent withDimension:secondDimensionExponent usingOperator:operatorName];
            if (resultDimensionExponent) { //could be zero in which case nil is returned from evaluateDimension
                [resultBaseUnitsWithDimensionExponents setObject:resultDimensionExponent forKey:matchingFirstBaseUnit];
            }
        } else {
            secondDimensionExponent = [self evaluateDimension:@0 withDimension:secondDimensionExponent usingOperator:operatorName];
            [resultBaseUnitsWithDimensionExponents setObject:secondDimensionExponent forKey:secondBaseUnit];
        }
        //ELSE we know it doesn't exitst in first array
        //TODO: convert to first system if first is all in the same system
    
    }
    
    [result setValue:[self evaluateNumber:firstQuantity.value withNumber:secondQuantity.value usingOperator:operatorName]];
    
    [result.unit setBaseUnitsWithDimensionExponents:resultBaseUnitsWithDimensionExponents];
    
    return result;
}

- (NSNumber *)valueByConvertingBaseUnit:(SMUnit <SMUnit>*)sourceComponentBaseUnit toBaseUnit:(SMUnit <SMUnit>*)targetComponentBaseUnit withValue:(NSNumber *)value
{
    if ([sourceComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit.fundamental]) {
        if (![sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit] &&
            ![targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]
            ) {
            value = [NSNumber numberWithDouble:([value doubleValue] *  pow(sourceComponentBaseUnit.scale, sourceComponentBaseUnit.staticRational) )];
            return [NSNumber numberWithDouble:( (value.doubleValue / pow(targetComponentBaseUnit.scale, targetComponentBaseUnit.staticRational)) )];
        } else if ([sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit] &&
                   [targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]
                   ) {
            return value;
        } else if (![sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit] &&
                   [targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]
                   ) {
            return [NSNumber numberWithDouble:([value doubleValue] *  pow(sourceComponentBaseUnit.scale, sourceComponentBaseUnit.staticRational) )];
        } else if ([sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit] &&
                   ![targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]
                   ) {
            return [NSNumber numberWithDouble:( (value.doubleValue / pow(targetComponentBaseUnit.scale, targetComponentBaseUnit.staticRational)) )];
        }
    }
    
    NSString *conversionIdentifier = [@[sourceComponentBaseUnit.identifier,targetComponentBaseUnit.identifier] componentsJoinedByString:@"."];
    
    SMConversionFactor *conversionFactor;
    if (self.conversions[conversionIdentifier]) {
        conversionFactor = self.conversions[conversionIdentifier];
        double newResultValue = value.doubleValue * conversionFactor.scaleFactor + conversionFactor.offset;
        return [NSNumber numberWithDouble:newResultValue];
    } else if (![sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit] && ![targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]) {
        conversionIdentifier = [@[sourceComponentBaseUnit.fundamental.identifier,targetComponentBaseUnit.fundamental.identifier] componentsJoinedByString:@"."];
        if (self.conversions[conversionIdentifier]) {
            conversionFactor = self.conversions[conversionIdentifier];
            value = [NSNumber numberWithDouble:([value doubleValue] *  pow(sourceComponentBaseUnit.scale, sourceComponentBaseUnit.staticRational) )];
            double newResultValue = value.doubleValue * conversionFactor.scaleFactor + conversionFactor.offset;
            NSNumber *finalResultValue = [NSNumber numberWithDouble:( (newResultValue / pow(targetComponentBaseUnit.scale, targetComponentBaseUnit.staticRational)) )];
            return finalResultValue;
        }
    } else if (![sourceComponentBaseUnit.fundamental isEqual:sourceComponentBaseUnit]) {
        conversionIdentifier = [@[sourceComponentBaseUnit.fundamental.identifier,targetComponentBaseUnit.identifier] componentsJoinedByString:@"."];
        if (self.conversions[conversionIdentifier]) {
            conversionFactor = self.conversions[conversionIdentifier];
            value = [NSNumber numberWithDouble:([value doubleValue] *  pow(sourceComponentBaseUnit.scale, sourceComponentBaseUnit.staticRational) )];
            double newResultValue = value.doubleValue * conversionFactor.scaleFactor + conversionFactor.offset;
            return [NSNumber numberWithDouble:newResultValue];
        }
    } else if (![targetComponentBaseUnit.fundamental isEqual:targetComponentBaseUnit]) {
        conversionIdentifier = [@[sourceComponentBaseUnit.identifier,targetComponentBaseUnit.fundamental.identifier] componentsJoinedByString:@"."];
        if (self.conversions[conversionIdentifier]) {
            conversionFactor = self.conversions[conversionIdentifier];
            
            double newResultValue = value.doubleValue * conversionFactor.scaleFactor + conversionFactor.offset;
            return [NSNumber numberWithDouble:( (newResultValue / pow(targetComponentBaseUnit.scale, targetComponentBaseUnit.staticRational)) )];
        }
    }
    
    return nil;


}

- (SMQuantity *)convertQuantity:(SMQuantity *)sourceQuantity usingDerivedUnit:(SMDerivedUnit *)targetDerivedUnit
{
    SMDerivedUnit *sourceDerivedUnit = sourceQuantity.unit;
    if ([sourceDerivedUnit isEqual:targetDerivedUnit]) {
        return sourceQuantity;
    }
    
    //TODO:fail early if they are not comesurable
    
    SMQuantity *resultQuantity = [SMQuantity quantityWithValue:sourceQuantity.value unit:targetDerivedUnit];
    
    if (sourceDerivedUnit.identifier && targetDerivedUnit.identifier &&
        sourceDerivedUnit.fundamental && targetDerivedUnit.fundamental) {
        NSNumber *convertedValue = [self valueByConvertingBaseUnit:sourceDerivedUnit toBaseUnit:targetDerivedUnit withValue:resultQuantity.value];
        if (convertedValue) {
            [resultQuantity setValue:convertedValue];
            return resultQuantity;
        }
        
    }
    
    if (![sourceDerivedUnit.fundamental isEqual:sourceDerivedUnit] &&
        sourceDerivedUnit.fundamental) {
        [resultQuantity setValue:[NSNumber numberWithDouble:([resultQuantity.value doubleValue] *  pow(sourceDerivedUnit.scale, sourceDerivedUnit.staticRational) )]];

    }
    
    
    for (SMBaseUnit *sourceComponentBaseUnit in sourceDerivedUnit.baseUnitsWithDimensionExponents) {
        BOOL foundConversion = NO;
        NSNumber *sourceDimensionExponent = sourceDerivedUnit.baseUnitsWithDimensionExponents[sourceComponentBaseUnit];
        for (SMBaseUnit *targetComponentBaseUnit in targetDerivedUnit.baseUnitsWithDimensionExponents) {
            NSNumber *targetDimensionExponent = targetDerivedUnit.baseUnitsWithDimensionExponents[targetComponentBaseUnit];
            if ([sourceComponentBaseUnit isEqual:targetComponentBaseUnit]) { //same base unit, no conversion needed
                foundConversion = YES;
                break;
            }
            
            if ([sourceComponentBaseUnit.dimension isEqualToString:targetComponentBaseUnit.dimension] &&
                [sourceDimensionExponent isEqualToNumber:targetDimensionExponent])
            {
                NSNumber *convertedValue;
                
                for (NSInteger i = 0; i< [sourceDimensionExponent integerValue]; i++) {
                    convertedValue = [self valueByConvertingBaseUnit:sourceComponentBaseUnit toBaseUnit:targetComponentBaseUnit withValue:resultQuantity.value];
                    [resultQuantity setValue:convertedValue];
                }
                if (convertedValue) {
                    foundConversion = YES;
                    [resultQuantity setValue:convertedValue];
                } else {
                    return nil;
                }

                break;
            }
            
        }
        if (!foundConversion) {
            return nil;
        }
    }

    if (![targetDerivedUnit.fundamental isEqual:targetDerivedUnit] &&
        targetDerivedUnit.fundamental) {
        [resultQuantity setValue:[NSNumber numberWithDouble:( (resultQuantity.value.doubleValue / pow(targetDerivedUnit.scale, targetDerivedUnit.staticRational)) )]];
        
    }
    


    
    
    return resultQuantity;
}
@end
