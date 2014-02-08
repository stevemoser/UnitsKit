//
//  SMQuantityFormatterTests.m
//  UnitsKit Example
//
//  Created by Steve Moser on 7/14/13.
//
//

#import "SMQuantityFormatterTests.h"

@implementation SMQuantityFormatterTests

- (void)setUp
{
    [super setUp];
    
    quantityFormatter = [[SMQuantityFormatter alloc] init];
    quantityEvaluator = [[SMQuantityEvaluator alloc] init];
    
    oneMeter = [[SMQuantity alloc] init];
    [oneMeter setValue:@1];
    [oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    twoMeters = [[SMQuantity alloc] init];
    [twoMeters setValue:@2];
    [twoMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    threeMetersSquared = [[SMQuantity alloc] init];
    SMDerivedUnit *meterSquared = [[SMDerivedUnit alloc] init];
    meterSquared.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@2};
    [threeMetersSquared setUnit:meterSquared];
    [threeMetersSquared setValue:@3];
    
    SMQuantity *threeLiters = [[SMQuantity alloc] init];
    [threeLiters setValue:@3];
    [threeLiters setUnit:[quantityEvaluator derivedUnitFromString:@"liter"]];
    
    threeMetersSquaredInPints = [quantityEvaluator convertQuantity:threeLiters usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"pint"]];
    threeMetersSquaredInQuarts = [quantityEvaluator convertQuantity:threeLiters usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"quart"]];
    
    fourPerMetersCubed = [[SMQuantity alloc] init];
    SMDerivedUnit *reciprocalMeterCubed = [[SMDerivedUnit alloc] init];
    reciprocalMeterCubed.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@(-3)};
    [fourPerMetersCubed setUnit:reciprocalMeterCubed];
    [fourPerMetersCubed setValue:@4];
    
    sixMetersSquaredPerKilogramCubed = [[SMQuantity alloc] init];
    SMDerivedUnit *metersSquaredPerKilogramCubed = [[SMDerivedUnit alloc] init];
    metersSquaredPerKilogramCubed.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@2,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"kilogram"]:@(-3)};
    [sixMetersSquaredPerKilogramCubed setUnit:metersSquaredPerKilogramCubed];
    [sixMetersSquaredPerKilogramCubed setValue:@6];
    
    sevenMeterCubedKilogramsToTheFourth = [[SMQuantity alloc] init];
    SMDerivedUnit *meterCubedKilogramsToTheFourth = [[SMDerivedUnit alloc] init];
    meterCubedKilogramsToTheFourth.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@3,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"kilogram"]:@4};
    [sevenMeterCubedKilogramsToTheFourth setUnit:meterCubedKilogramsToTheFourth];
    [sevenMeterCubedKilogramsToTheFourth setValue:@7];
    
    eightPerMeterCubedKilogramToTheFourth = [[SMQuantity alloc] init];
    SMDerivedUnit *perMeterCubedKilogramToTheFourth = [[SMDerivedUnit alloc] init];
    perMeterCubedKilogramToTheFourth.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@(-3),(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"kilogram"]:@(-4)};
    [eightPerMeterCubedKilogramToTheFourth setUnit:perMeterCubedKilogramToTheFourth];
    [eightPerMeterCubedKilogramToTheFourth setValue:@8];
    
    nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh = [[SMQuantity alloc] init];
    SMDerivedUnit *kilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh = [[SMDerivedUnit alloc] init];
    kilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"meter"]:@(-6),(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"second"]:@(-7),(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"kilogram"]:@5};
    [nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh setUnit:kilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh];
    [nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh setValue:@9];
    
    threeNewtons = [[SMQuantity alloc] init];
    [threeNewtons setValue:@3];
    [threeNewtons setUnit:[quantityEvaluator derivedUnitFromString:@"newton"]];
    
}

//case '1':
//outp=[outp stringByAppendingFormat:@"\u00B9"];
//break;
//case '2':
//outp=[outp stringByAppendingFormat:@"\u00B2"];
//break;
//case '3':
//outp=[outp stringByAppendingFormat:@"\u00B3"];
//break;
//case '4':
//outp=[outp stringByAppendingFormat:@"\u2074"];
//break;
//case '5':
//outp=[outp stringByAppendingFormat:@"\u2075"];
//break;
//case '6':
//outp=[outp stringByAppendingFormat:@"\u2076"];
//break;
//case '7':
//outp=[outp stringByAppendingFormat:@"\u2077"];
//break;
//case '8':
//outp=[outp stringByAppendingFormat:@"\u2078"];
//break;
//case '9':
//outp=[outp stringByAppendingFormat:@"\u2079"];
//break;
//case '-':
//outp=[outp stringByAppendingFormat:@"\u207B"];
//break;
//case '0':
//outp=[outp stringByAppendingFormat:@"\u2070"];
//break;
//default:
//break;

- (void)testSingleUnitWithNoExponent
{
    STAssertEqualObjects([quantityFormatter stringFromQuantity:oneMeter], @"1 m", @"should be 1 m");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:oneMeter], @"1 m", @"should be 1 m");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:oneMeter], @"1 meter", @"should be 1 meter");
    STAssertEqualObjects([quantityFormatter stringFromQuantity:twoMeters], @"2 meters", @"should be 2 meters");

}

- (void)testSingleUnitWithPositiveExponent
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquared], @"3 m\u00B2", @"should be 3 m\u00B2");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquared], @"3 m\u00B2", @"should be 3 m\u00B2");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquared], @"3 m^2", @"should be 3 m^2");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquared], @"3 meters squared", @"should be 3 meters squared");

}

- (void)testSingleUnitWithNegativeExponent
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:fourPerMetersCubed], @"4 m\u207B\u00B3", @"should be 4 m\u207B\u00B3");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:fourPerMetersCubed], @"4 m\u207B\u00B3", @"should be 4 m\u207B\u00B3");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:fourPerMetersCubed], @"4 m^-3", @"should be 4 m^-3");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:fourPerMetersCubed], @"4 per meter cubed", @"should be 4 per meter cubed");
}

- (void)testUnitsWithOnePositiveAndWithOneNegativeExponents
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sixMetersSquaredPerKilogramCubed], @"6 m\u00B2/kg\u00B3", @"should be 6 m\u00B2/kg\u00B3");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sixMetersSquaredPerKilogramCubed], @"6 m\u00B2·kg\u207B\u00B3", @"should be 6 m\u00B2·kg\u207B");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sixMetersSquaredPerKilogramCubed], @"6 m^2·kg^-3", @"should be 6 m^2·kg^-3");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sixMetersSquaredPerKilogramCubed], @"6 meters squared per kilogram cubed", @"should be 6 meters squared per kilogram cubed");
}

- (void)testUnitsWithPositiveExponents
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sevenMeterCubedKilogramsToTheFourth], @"7 kg\u2074·m\u00B3", @"should be 7 kg\u2074·m\u00B3");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sevenMeterCubedKilogramsToTheFourth], @"7 kg\u2074·m\u00B3", @"should be 7 kg\u2074·m\u00B3");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sevenMeterCubedKilogramsToTheFourth], @"7 kg^4·m^3", @"should be 7 kg^4·m^3");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:sevenMeterCubedKilogramsToTheFourth], @"7 kilogram to the fourth meters cubed", @"should be 7 kilogram to the fourth meters cubed");
}

- (void)testUnitsWithNegativeExponents
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:eightPerMeterCubedKilogramToTheFourth], @"8 m\u207B\u00B3·kg\u207B\u2074", @"should be 8 m\u207B\u00B3·kg\u207B\u2074");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:eightPerMeterCubedKilogramToTheFourth], @"8 m\u207B\u00B3·kg\u207B\u2074", @"should be 8 m\u207B\u00B3·kg\u207B\u2074");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:eightPerMeterCubedKilogramToTheFourth], @"8 m^-3·kg^-4", @"should be 8 m^-3·kg^-4");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:eightPerMeterCubedKilogramToTheFourth], @"8 per meter cubed kilogram to the fourth", @"should be 8 per meter cubed kilogram to the fourth");
    
}

- (void)testUnitsWithOnePositiveAndWithTwoNegativeExponents
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh], @"9 kg\u2075/(m\u2076·s\u2077)", @"should be 9 kg\u2075/(m\u2076·s\u2077)");
    [quantityFormatter setUsesSolidusForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh], @"9 kg\u2075·m\u207B\u2076·s\u207B\u2077", @"should be 9 kg\u2075·m\u207B\u2076·s\u207B\u2077");
    [quantityFormatter setUsesSuperscriptForExponentForSymbolsForDisplay:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh], @"9 kg^5·m^-6·s^-7", @"should be 9 kg^5·m^-6·s^-7");
    [quantityFormatter setDisplaysInTermsOfSymbols:NO];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh], @"9 kilograms to the fifth per meter to the sixth second to the seventh", @"should be 9 kilograms to the fifth per meter to the sixth second to the seventh");
    
}

- (void)testIntermediateUnitsShouldNotBeShownAfterConversion
{
    [quantityFormatter setDisplaysInTermsOfSymbols:YES];
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquaredInPints], @"6.34 pt", @"should be 6.34 pt");
    STAssertEqualObjects([quantityFormatter stringFromQuantity:threeMetersSquaredInQuarts], @"3.17 qt", @"should be 3.17 qt");
}

@end
