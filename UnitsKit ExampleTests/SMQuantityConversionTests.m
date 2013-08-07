//
//  SMQuantityConversionTests.m
//  UnitsKit Example
//
//  Created by Steve Moser on 7/18/13.
//
//

#import "SMQuantityConversionTests.h"

@implementation SMQuantityConversionTests


- (void)setUp
{
    [super setUp];
    
    quantityFormatter = [[SMQuantityFormatter alloc] init];
    quantityEvaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    oneMeter = [[SMQuantity alloc] init];
    [oneMeter setValue:@1];
    [oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    oneKilometer = [[SMQuantity alloc] init];
    [oneKilometer setValue:@1];
    [oneKilometer setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    
    oneNewton = [[SMQuantity alloc] init];
    [oneNewton setValue:@1];
    [oneNewton setUnit:[quantityEvaluator derivedUnitFromString:@"newton"]];
}

- (void)testConversionIdentity
{
    
    SMQuantity *calculatedYards = [[SMQuantity alloc] init];
    [calculatedYards setValue:@1];
    [calculatedYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    SMQuantity *convertedYards = [quantityEvaluator convertQuantity:calculatedYards usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    
    STAssertTrue([convertedYards isEqualToQuantity:calculatedYards], @"should be 1 yards", nil);
    
}

- (void)testConversionFromFundamentalUnitToFundamentalUnit
{
    
    SMQuantity *calculatedYards = [[SMQuantity alloc] init];
    [calculatedYards setValue:@(1/.9144)];
    [calculatedYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    
    SMQuantity *convertedYards = [quantityEvaluator convertQuantity:oneMeter usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];

    STAssertTrue([convertedYards isEqualToQuantity:calculatedYards], @"should be 1.09361.. yards", nil);
    
    SMQuantity *calculatedMeters = [[SMQuantity alloc] init];
    [calculatedMeters setValue:@(.9144)];
    [calculatedMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    SMQuantity *oneYard = [[SMQuantity alloc] init];
    [oneYard setValue:@1];
    [oneYard setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    SMQuantity *convertedMeters = [quantityEvaluator convertQuantity:oneYard usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    STAssertTrue([convertedMeters isEqualToQuantity:calculatedMeters], @"should be .9144 meters", nil);

}

- (void)testTemperatureConversion
{
    
    SMQuantity *calculatedFahrenheit = [[SMQuantity alloc] init];
    [calculatedFahrenheit setValue:@(20*(9.0/5.0)+32)]; //68 F
    [calculatedFahrenheit setUnit:[quantityEvaluator derivedUnitFromString:@"fahrenheit"]];
    
    SMQuantity *twentyCelsius = [[SMQuantity alloc] init];
    [twentyCelsius setValue:@20]; //68 F
    [twentyCelsius setUnit:[quantityEvaluator derivedUnitFromString:@"celsius"]];
    
    SMQuantity *convertedFahrenheit = [quantityEvaluator convertQuantity:twentyCelsius usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"fahrenheit"]];
    
    STAssertTrue([convertedFahrenheit isEqualToQuantity:calculatedFahrenheit], @"should be 68 degrees Fahrenheit", nil);
    
    SMQuantity *calculatedFahrenheitFromKelvin = [[SMQuantity alloc] init];
    [calculatedFahrenheitFromKelvin setValue:@(293.15*(9.0/5.0) + -459.67)]; //68 F
    [calculatedFahrenheitFromKelvin setUnit:[quantityEvaluator derivedUnitFromString:@"fahrenheit"]];
    
    SMQuantity *almost3hundredKelvin = [[SMQuantity alloc] init];
    [almost3hundredKelvin setValue:@293.15]; //68 F
    [almost3hundredKelvin setUnit:[quantityEvaluator derivedUnitFromString:@"kelvin"]];
    
    SMQuantity *convertedFahrenheitFromKelvin = [quantityEvaluator convertQuantity:almost3hundredKelvin usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"fahrenheit"]];
    
    STAssertTrue([convertedFahrenheitFromKelvin isEqualToQuantity:calculatedFahrenheitFromKelvin], @"should be 68 degrees Fahrenheit", nil);
    
    SMQuantity *calculatedCelsius = [[SMQuantity alloc] init];
    [calculatedCelsius setValue:@((68-32)*(5.0/9.0))]; //68
    [calculatedCelsius setUnit:[quantityEvaluator derivedUnitFromString:@"celsius"]];
    
    SMQuantity *sixtyEightFahrenheit = [[SMQuantity alloc] init];
    [sixtyEightFahrenheit setValue:@68]; //20 C
    [sixtyEightFahrenheit setUnit:[quantityEvaluator derivedUnitFromString:@"fahrenheit"]];
    
    SMQuantity *convertedCelsius = [quantityEvaluator convertQuantity:sixtyEightFahrenheit usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"celsius"]];
    
    STAssertTrue([convertedCelsius isEqualToQuantity:calculatedCelsius], @"should be 20 degrees Celsius", nil);
    
}

- (void)testConversionFromScaledUnitToFundamentalUnit
{
    
    SMQuantity *calculatedYards = [[SMQuantity alloc] init];
    [calculatedYards setValue:@(1000/.9144)];
    [calculatedYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    SMQuantity *convertedYards = [quantityEvaluator convertQuantity:oneKilometer usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    
    STAssertTrue([convertedYards isEqualToQuantity:calculatedYards], @"should be 1093.61.. yards", nil);
    
    SMQuantity *calculatedKilometers = [[SMQuantity alloc] init];
    [calculatedKilometers setValue:@(.9144/1000)];
    [calculatedKilometers setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    SMQuantity *oneYard = [[SMQuantity alloc] init];
    [oneYard setValue:@1];
    [oneYard setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    SMQuantity *convertedKilometers = [quantityEvaluator convertQuantity:oneYard usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    
    STAssertTrue([convertedKilometers isEqualToQuantity:calculatedKilometers], @"should be 0.0009144 kilometers", nil);
    
}

- (void)testConversionFromScaledUnitToScaledUnit
{
    
    SMQuantity *calculatedFeet = [[SMQuantity alloc] init];
    [calculatedFeet setValue:@(1000/.9144*3)];
    [calculatedFeet setUnit:[quantityEvaluator derivedUnitFromString:@"foot"]];
    SMQuantity *convertedFeet = [quantityEvaluator convertQuantity:oneKilometer usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"foot"]];
    
    STAssertTrue([convertedFeet isEqualToQuantity:calculatedFeet], @"should be 3280.839.. feet", nil);
    
    SMQuantity *calculatedKilometers = [[SMQuantity alloc] init];
    [calculatedKilometers setValue:@(1.0/3.0*.9144/1000.0)]; //order is important otherwise rounding errors
    [calculatedKilometers setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    SMQuantity *oneFoot = [[SMQuantity alloc] init];
    [oneFoot setValue:@1];
    [oneFoot setUnit:[quantityEvaluator derivedUnitFromString:@"foot"]];
    SMQuantity *convertedKilometers = [quantityEvaluator convertQuantity:oneFoot usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    
    STAssertTrue([convertedKilometers isEqualToQuantity:calculatedKilometers], @"should be 0.0003048 kilometers", nil);
    
}

- (void)testConversionFromDerivedUnitToDerivedUnit
{
    
    SMQuantity *calculatedPoundal = [[SMQuantity alloc] init];
    [calculatedPoundal setValue:@(1/0.138254954376)];
    SMDerivedUnit *poundMassFeetPerSecondSquared = [[SMDerivedUnit alloc] init];
    //[quantityEvaluator derivedUnitFromString:@"SIsecond"]
    poundMassFeetPerSecondSquared.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"USpound"]:@1,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"USfoot"]:@1,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"SIsecond"]:@(-2)};
    [calculatedPoundal setUnit:poundMassFeetPerSecondSquared];
    
    
    SMQuantity *convertedPoundal = [quantityEvaluator convertQuantity:oneNewton usingDerivedUnit:poundMassFeetPerSecondSquared];
    
    STAssertTrue([convertedPoundal isEqualToQuantity:calculatedPoundal], @"should be 7.2330 poundals", nil);
    
}

- (void)testConversionFromStrictlyDerivedUnitToStrictlyDerivedUnit
{
    
    SMQuantity *calculatedPoundal = [[SMQuantity alloc] init];
    [calculatedPoundal setValue:@(1/0.138254954376)];
    [calculatedPoundal setUnit:[quantityEvaluator derivedUnitFromString:@"poundal"]];
    
    SMQuantity *convertedPoundal = [quantityEvaluator convertQuantity:oneNewton usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"poundal"]];
    
    STAssertTrue([convertedPoundal isEqualToQuantity:calculatedPoundal], @"should be 7.2330 poundals", nil);
    
}


- (void)testConversionFromScaledDerivedUnitToDerivedUnit
{
    
    SMQuantity *calculatedPoundal = [[SMQuantity alloc] init];
    [calculatedPoundal setValue:@(1/0.138254954376*1000)];
    SMDerivedUnit *poundMassFeetPerSecondSquared = [[SMDerivedUnit alloc] init];
    poundMassFeetPerSecondSquared.baseUnitsWithDimensionExponents = @{(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"USpound"]:@1,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"USfoot"]:@1,(id <NSCopying>)[quantityEvaluator baseUnitFromString:@"SIsecond"]:@(-2)};
    [calculatedPoundal setUnit:poundMassFeetPerSecondSquared];
    
    SMQuantity *oneKilonewton = [[SMQuantity alloc] init];
    [oneKilonewton setValue:@1];
    [oneKilonewton setUnit:[quantityEvaluator derivedUnitFromString:@"kilonewton"]];
    
    SMQuantity *convertedPoundal = [quantityEvaluator convertQuantity:oneKilonewton usingDerivedUnit:poundMassFeetPerSecondSquared];
    
    STAssertTrue([convertedPoundal isEqualToQuantity:calculatedPoundal], @"should be 7233.0 poundals", nil);
    
}

- (void)testConversionFromStrictlyScaledDerivedUnitToStrictlyDerivedUnit
{
    
    SMQuantity *calculatedPoundal = [[SMQuantity alloc] init];
    [calculatedPoundal setValue:@(1/0.138254954376*1000)];
    [calculatedPoundal setUnit:[quantityEvaluator derivedUnitFromString:@"poundal"]];
    
    SMQuantity *oneKilonewton = [[SMQuantity alloc] init];
    [oneKilonewton setValue:@1];
    [oneKilonewton setUnit:[quantityEvaluator derivedUnitFromString:@"kilonewton"]];
    
    SMQuantity *convertedPoundal = [quantityEvaluator convertQuantity:oneKilonewton usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"poundal"]];
    
    STAssertTrue([convertedPoundal isEqualToQuantity:calculatedPoundal], @"should be 7233.0 poundals", nil);
    
    
    SMQuantity *calculatedTeaspoon = [[SMQuantity alloc] init];
    [calculatedTeaspoon setValue:@(0.202910226402063270656)];//@(.001*pow(0.1*(1/.9144)*11.7349286,3)*96)];
    [calculatedTeaspoon setUnit:[quantityEvaluator derivedUnitFromString:@"teaspoon"]];
    
    SMQuantity *oneMilliliter = [[SMQuantity alloc] init];
    [oneMilliliter setValue:@1];
    [oneMilliliter setUnit:[quantityEvaluator derivedUnitFromString:@"mL"]];
    
    SMQuantity *convertedTeaspoon = [quantityEvaluator convertQuantity:oneMilliliter usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"teaspoon"]];

    STAssertTrue([convertedTeaspoon isEqualToQuantity:calculatedTeaspoon], @"should be 0.20291 teaspoons", nil);
    
}

@end
