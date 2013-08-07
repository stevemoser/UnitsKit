//
//  SMQuantityFormatterTests.h
//  UnitsKit Example
//
//  Created by Steve Moser on 7/14/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

#import "SMQuantity.h"
#import "SMDerivedUnit.h"
#import "SMQuantityFormatter.h"
#import "SMQuantityEvaluator.h"

@interface SMQuantityFormatterTests : SenTestCase{
    SMQuantityFormatter *quantityFormatter;
    SMQuantityEvaluator *quantityEvaluator;
    
    SMQuantity *oneMeter;
    SMQuantity *twoMeters;
    SMQuantity *threeMetersSquared;
    SMQuantity *fourPerMetersCubed;
    SMQuantity *sixMetersSquaredPerKilogramCubed;
    SMQuantity *sevenMeterCubedKilogramsToTheFourth;
    SMQuantity *eightPerMeterCubedKilogramToTheFourth;
    SMQuantity *nineKilogramsToTheFifthPerMeterToTheSixthSecondsToTheSeventh;


    SMQuantity *threeNewtons;
    
}

@end
