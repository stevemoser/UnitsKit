//
//  SMQuantityEvaluatorTests.m
//  UnitsKit Example
//
//  Created by Steve Moser on 7/21/13.
//
//

#import "SMQuantityEvaluatorTests.h"

@interface SMQuantityEvaluatorTests () 

@end

@implementation SMQuantityEvaluatorTests

- (void)setUp
{
    [super setUp];
        
    quantityEvaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    oneMeter = [[SMQuantity alloc] init];
    [oneMeter setValue:@1];
    [oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    twoMeters = [[SMQuantity alloc] init];
    [twoMeters setValue:@2];
    [twoMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    threeMeters = [[SMQuantity alloc] init];
    [threeMeters setValue:@3];
    [threeMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    fourMeters = [[SMQuantity alloc] init];
    [fourMeters setValue:@1];
    [fourMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    fiveMeters = [[SMQuantity alloc] init];
    [fiveMeters setValue:@1];
    [fiveMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    sixMeters = [[SMQuantity alloc] init];
    [sixMeters setValue:@1];
    [sixMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    
    oneKilometer = [[SMQuantity alloc] init];
    [oneKilometer setValue:@1];
    [oneKilometer setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    
    oneMillimeter = [[SMQuantity alloc] init];
    [oneMillimeter setValue:@1];
    [oneMillimeter setUnit:[quantityEvaluator derivedUnitFromString:@"millimeter"]];
    
    
    oneKilogram = [[SMQuantity alloc] init];
    [oneKilogram setValue:@1];
    [oneKilogram setUnit:[quantityEvaluator derivedUnitFromString:@"kilogram"]];
    
    oneNewton = [[SMQuantity alloc] init];
    [oneNewton setValue:@1];
    [oneNewton setUnit:[quantityEvaluator derivedUnitFromString:@"newton"]];
}

- (void)testAddNondimensional
{    
    SMQuantity *three = [[SMQuantity alloc] init];
    [three setValue:@3];
    
    SMQuantity *six = [[SMQuantity alloc] init];
    [six setValue:@6];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:three withQuantity:three usingOperator:@"add"];
    
    STAssertTrue([testResult isEqualToQuantity:six], @"should me 6", nil);
    
    
}

- (void)testAddNondimensionalWithDimensional
{
    SMQuantity *two = [[SMQuantity alloc] init];
    [two setValue:@2];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:two withQuantity:threeMeters usingOperator:@"add"];
    
    STAssertNil(testResult, @"should me nil", nil);
}

- (void)testAddDifferentFundamentalUnit
{

    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:oneMeter withQuantity:oneKilogram usingOperator:@"add"];
    
    STAssertNil(testResult, @"should me nil", nil);
}

- (void)testAddFundamentalUnitWithScaledUnit
{
    
    SMQuantity *oneThousandTwoMeters = [[SMQuantity alloc] init];
    [oneThousandTwoMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [oneThousandTwoMeters setValue:@1002];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMeters withQuantity:oneKilometer usingOperator:@"add"];
    
    STAssertTrue([testResult isEqualToQuantity:oneThousandTwoMeters], @"should me 1002m", nil);
    
}

- (void)testAddScaledUnitWithScaledUnit
{
    SMQuantity *oneThousandAndOneThousandthMeter = [[SMQuantity alloc] init];
    [oneThousandAndOneThousandthMeter setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    [oneThousandAndOneThousandthMeter setValue:@1.000001];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:oneKilometer withQuantity:oneMillimeter usingOperator:@"add"];
    
    STAssertTrue([testResult isEqualToQuantity:oneThousandAndOneThousandthMeter], @"should me 1.00001km", nil);
    
}

- (void)testAddFundamentalUnitWithScaledUnitFromOtherSystem
{
    
    SMQuantity *fiveYards = [[SMQuantity alloc] init];

    [fiveYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    [fiveYards setValue:@5];
    
    SMQuantity *fiveAndAHalfishMeters = [[SMQuantity alloc] init];
    [fiveAndAHalfishMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [fiveAndAHalfishMeters setValue:@(5.57200)];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:oneMeter withQuantity:fiveYards usingOperator:@"add"];
    
    STAssertTrue([testResult isEqualToQuantity:fiveAndAHalfishMeters], @"should me 5.4864m^2", nil);
}

- (void)testMultiplyNondimensional
{
    SMQuantity *three = [[SMQuantity alloc] init];
    [three setValue:@3];
    
    SMQuantity *nine = [[SMQuantity alloc] init];
    [nine setValue:@9];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:three withQuantity:three usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:nine], @"should me 9", nil);
}

- (void)testMultiplyNondimensionalWithDimensional
{
    SMQuantity *two = [[SMQuantity alloc] init];
    [two setValue:@2];
    
    SMQuantity *threeMeter = [[SMQuantity alloc] init];
    [threeMeter setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    [threeMeter setValue:@3];
    
    SMQuantity *sixThousandMeters = [[SMQuantity alloc] init];
    [sixThousandMeters setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    [sixThousandMeters setValue:@6];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:two withQuantity:threeMeter usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:sixThousandMeters], @"should me 6m", nil);
    
}

- (void)testMultiplySameUnit
{
    SMQuantity *twoMeter = [[SMQuantity alloc] init];
    [twoMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [twoMeter setValue:@2];
    
    SMQuantity *fourMeterSquared = [[SMQuantity alloc] init];
    SMDerivedUnit *meterSquared = [[SMDerivedUnit alloc] init];
    meterSquared.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"meter"]:@2};
    [fourMeterSquared setUnit:meterSquared];
    [fourMeterSquared setValue:@4];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMeter withQuantity:twoMeter usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:fourMeterSquared], @"should me 4m^2", nil);
}

- (void)testMultiplyDifferentFundamentalUnit
{
    SMQuantity *twoMeter = [[SMQuantity alloc] init];
    [twoMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [twoMeter setValue:@2];
    
    SMQuantity *threeKilogram = [[SMQuantity alloc] init];
    [threeKilogram setUnit:[quantityEvaluator derivedUnitFromString:@"kilogram"]];
    [threeKilogram setValue:@3];
    
    SMQuantity *fourMeterKilograms = [[SMQuantity alloc] init];
    SMDerivedUnit *meterKilograms = [[SMDerivedUnit alloc] init];
    meterKilograms.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"meter"]:@1,[quantityEvaluator baseUnitFromString:@"kilogram"]:@1};
    [fourMeterKilograms setUnit:meterKilograms];
    [fourMeterKilograms setValue:@6];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMeter withQuantity:threeKilogram usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:fourMeterKilograms], @"should me 6m^2", nil);
}



- (void)testMultiplyFundamentalUnitWithScaledUnit
{
    SMQuantity *twoMeter = [[SMQuantity alloc] init];
    [twoMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [twoMeter setValue:@2];
    
    SMQuantity *threeKilometers = [[SMQuantity alloc] init];
    [threeKilometers setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    [threeKilometers setValue:@3];
    
    SMQuantity *sixThousandMetersSquared = [[SMQuantity alloc] init];
    SMDerivedUnit *metersSquared = [[SMDerivedUnit alloc] init];
    metersSquared.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"meter"]:@2};
    [sixThousandMetersSquared setUnit:metersSquared];
    [sixThousandMetersSquared setValue:@6000];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMeter withQuantity:threeKilometers usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:sixThousandMetersSquared], @"should me 6000m^2", nil);
    
}

- (void)testMultiplyScaledUnitWithScaledUnit
{
    SMQuantity *twoMillimeters = [[SMQuantity alloc] init];
    [twoMillimeters setUnit:[quantityEvaluator derivedUnitFromString:@"millimeter"]];
    [twoMillimeters setValue:@2];
    
    SMQuantity *threeKilometers = [[SMQuantity alloc] init];
    [threeKilometers setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    [threeKilometers setValue:@3];
    
    SMQuantity *sixMetersSquared = [[SMQuantity alloc] init];
    SMDerivedUnit *meterSquared = [[SMDerivedUnit alloc] init];
    meterSquared.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"millimeter"]:@2};
    [sixMetersSquared setUnit:meterSquared];
    [sixMetersSquared setValue:@6000000];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMillimeters withQuantity:threeKilometers usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:sixMetersSquared], @"should me 6000mm^2", nil);
    
    
}

- (void)testMultiplyFundamentalUnitWithScaledUnitFromOtherSystem
{
    SMQuantity *twoMeter = [[SMQuantity alloc] init];
    [twoMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [twoMeter setValue:@2];
    
    SMQuantity *threeYards = [[SMQuantity alloc] init];
    [threeYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    [threeYards setValue:@3];
    
    SMQuantity *fiveishMetersSquared = [[SMQuantity alloc] init];
    SMDerivedUnit *meterSquared = [[SMDerivedUnit alloc] init];
    meterSquared.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"meter"]:@2};
    [fiveishMetersSquared setUnit:meterSquared];
    [fiveishMetersSquared setValue:@(5.4864)];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:twoMeter withQuantity:threeYards usingOperator:@"multiply"];
    
    STAssertTrue([testResult isEqualToQuantity:fiveishMetersSquared], @"should me 5.4864m^2", nil);
    
    
}

- (void)testDivideNondimensional
{
    SMQuantity *three = [[SMQuantity alloc] init];
    [three setValue:@3];
    
    SMQuantity *one = [[SMQuantity alloc] init];
    [one setValue:@1];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:three withQuantity:three usingOperator:@"divide"];
    
    STAssertTrue([testResult isEqualToQuantity:one], @"should me 9m", nil);
    
}

- (void)testDivideNondimensionalWithDimensional
{
    SMQuantity *six = [[SMQuantity alloc] init];
    [six setValue:@6];
    
    SMQuantity *threeMeter = [[SMQuantity alloc] init];
    [threeMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [threeMeter setValue:@3];
    
    SMQuantity *twoPerMeter = [[SMQuantity alloc] init];
    SMDerivedUnit *perMeter = [[SMDerivedUnit alloc] init];
    perMeter.baseUnitsWithDimensionExponents = @{[quantityEvaluator baseUnitFromString:@"meter"]:@(-1)};
    [twoPerMeter setUnit:perMeter];
    [twoPerMeter setValue:@2];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:six withQuantity:threeMeter usingOperator:@"divide"];
    
    STAssertTrue([testResult isEqualToQuantity:twoPerMeter], @"should me 2m^-1", nil);
    
    
}

- (void)testDivideDimensionalWithNondimensional
{
    SMQuantity *two = [[SMQuantity alloc] init];
    [two setValue:@3];
    
    SMQuantity *threeMeter = [[SMQuantity alloc] init];
    [threeMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [threeMeter setValue:@6];
    
    SMQuantity *twoMeterSquared = [[SMQuantity alloc] init];
    [twoMeterSquared setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    [twoMeterSquared setValue:@2];
    
    SMQuantity *testResult = [quantityEvaluator evaluateQuantity:threeMeter withQuantity:two usingOperator:@"divide"];
    
    STAssertTrue([testResult isEqualToQuantity:twoMeterSquared], @"should me 2m", nil);
    
}

- (void)testCompareQuantities
{
    NSArray *unSortedQuantites = @[twoMeters,oneMeter,threeMeters];
    NSArray *sortedQuantitesUsingCompare = [unSortedQuantites sortedArrayUsingComparator: ^(SMQuantity *firstQuantity, SMQuantity *secondQuantity) {
        return [firstQuantity compare:secondQuantity];
    }];
    NSArray *sortedQuantities = @[oneMeter,twoMeters,threeMeters];
    
    STAssertTrue([sortedQuantitesUsingCompare isEqualToArray:sortedQuantities], @"should me [1m,2m,3m]", nil);

}

@end
