//
//  SMDimensionalViewController.m
//  UnitsKit Example
//
//  Created by Steve Moser on 7/13/13.
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

#import "SMDimensionalViewController.h"

#import "SMQuantityEvaluator.h"
#import "SMQuantityFormatter.h"

#import "SMDerivedUnit.h"
#import "SMBaseUnit.h"
#import "SMConversionFactor.h"
#import "SMQuantity.h"

@interface SMDimensionalViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *firstAdditionTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondAdditionTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdAdditionTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstMultiplicationTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondMultiplicationTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdMultiplicationTableViewCell;

@end

@implementation SMDimensionalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SMQuantityFormatter *quantityFormatter = [[SMQuantityFormatter alloc] init];
    SMQuantityEvaluator *quantityEvaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    SMQuantity *oneMeter = [[SMQuantity alloc] init];
    [oneMeter setValue:@1];
    [oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *twoMeters = [[SMQuantity alloc] init];
    [twoMeters setValue:@2];
    [twoMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *threeMeters = [[SMQuantity alloc] init];
    [threeMeters setValue:@3];
    [threeMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *fourMeters = [[SMQuantity alloc] init];
    [fourMeters setValue:@1];
    [fourMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *fiveMeters = [[SMQuantity alloc] init];
    [fiveMeters setValue:@1];
    [fiveMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *sixMeters = [[SMQuantity alloc] init];
    [sixMeters setValue:@1];
    [sixMeters setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    SMQuantity *oneKilometer = [[SMQuantity alloc] init];
    [oneKilometer setValue:@1];
    [oneKilometer setUnit:[quantityEvaluator derivedUnitFromString:@"kilometer"]];
    
    SMQuantity *oneMillimeter = [[SMQuantity alloc] init];
    [oneMillimeter setValue:@1];
    [oneMillimeter setUnit:[quantityEvaluator derivedUnitFromString:@"millimeter"]];
    
    
    SMQuantity *oneKilogram = [[SMQuantity alloc] init];
    [oneKilogram setValue:@1];
    [oneKilogram setUnit:[quantityEvaluator derivedUnitFromString:@"kilogram"]];
    
    SMQuantity *oneNewton = [[SMQuantity alloc] init];
    [oneNewton setValue:@3];
    [oneNewton setUnit:[quantityEvaluator derivedUnitFromString:@"newton"]];
    
    
    SMQuantity *fiveYards = [[SMQuantity alloc] init];
    
    [fiveYards setUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    [fiveYards setValue:@5];
    
    //add
    [self.firstAdditionTableViewCell.textLabel setText:[NSString stringWithFormat:@"%@ and %@",[quantityFormatter stringFromQuantity:oneMeter],[quantityFormatter stringFromQuantity:fiveYards]]];
        
    [self.secondAdditionTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:[quantityEvaluator evaluateQuantity:oneMeter withQuanity:fiveYards usingOperator:@"add"]]];
    [self.secondAdditionTableViewCell.detailTextLabel setText:@"Addition"];
    
    [self.thirdAdditionTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:[quantityEvaluator evaluateQuantity:oneMeter withQuanity:fiveYards usingOperator:@"subtract"]]];
    [self.thirdAdditionTableViewCell.detailTextLabel setText:@"Subtraction"];
    
    //multiply
    [self.firstMultiplicationTableViewCell.textLabel setText:[NSString stringWithFormat:@"%@ and %@",[quantityFormatter stringFromQuantity:oneMeter],[quantityFormatter stringFromQuantity:oneNewton]]];
    
    [self.secondMultiplicationTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:[quantityEvaluator evaluateQuantity:oneMeter withQuanity:oneNewton usingOperator:@"multiply"]]];
    [self.secondMultiplicationTableViewCell.detailTextLabel setText:@"Multiplication"];
    
    [self.thirdMultiplicationTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:[quantityEvaluator evaluateQuantity:oneMeter withQuanity:oneNewton usingOperator:@"divide"]]];
    [self.thirdMultiplicationTableViewCell.detailTextLabel setText:@"Division"];
    
    //compard

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
