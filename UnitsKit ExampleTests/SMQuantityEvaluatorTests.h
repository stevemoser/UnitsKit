//
//  SMQuantityEvaluatorTests.h
//  UnitsKit Example
//
//  Created by Steve Moser on 7/21/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

#import "SMQuantityEvaluator.h"

#import "SMDerivedUnit.h"
#import "SMBaseUnit.h"
#import "SMConversionFactor.h"
#import "SMQuantity.h"

@interface SMQuantityEvaluatorTests : SenTestCase {
    SMQuantityEvaluator *quantityEvaluator;
    
    SMQuantity *oneMeter;
    SMQuantity *twoMeters;
    SMQuantity *threeMeters;
    SMQuantity *fourMeters;
    SMQuantity *fiveMeters;
    SMQuantity *sixMeters;

    SMQuantity *oneKilometer;
    SMQuantity *oneMillimeter;
    
    SMQuantity *oneKilogram;

    SMQuantity *oneNewton;
}

@end
