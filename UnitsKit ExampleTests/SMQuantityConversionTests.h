//
//  SMQuantityConversionTests.h
//  UnitsKit Example
//
//  Created by Steve Moser on 7/18/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

#import "SMQuantity.h"
#import "SMDerivedUnit.h"
#import "SMQuantityFormatter.h"
#import "SMQuantityEvaluator.h"

@interface SMQuantityConversionTests : SenTestCase {
    SMQuantityFormatter *quantityFormatter;
    SMQuantityEvaluator *quantityEvaluator;
    
    SMQuantity *oneMeter;
    SMQuantity *oneKilometer;
    SMQuantity *oneNewton;

}

@end
