//
//  SMUnitConverterViewController.m
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

#import "SMUnitConverterViewController.h"

#import "SMQuantity.h"
#import "SMDerivedUnit.h"
#import "SMQuantityFormatter.h"
#import "SMQuantityEvaluator.h"

@interface SMUnitConverterViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *firstLengthTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondLengthTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdLengthTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstMassTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondMassTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdMassTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstTimeTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondTimeTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdTimeTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstForceTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondForceTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdForceTableViewCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *firstVolumeTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondVolumeTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdVolumeTableViewCell;

@end

@implementation SMUnitConverterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SMQuantityFormatter *quantityFormatter = [[SMQuantityFormatter alloc] init];
    SMQuantityEvaluator *quantityEvaluator = [SMQuantityEvaluator sharedQuantityEvaluator];
    
    //Length
    SMQuantity *oneMeter = [[SMQuantity alloc] init];
    [oneMeter setValue:@1];
    [oneMeter setUnit:[quantityEvaluator derivedUnitFromString:@"meter"]];
    
    [self.firstLengthTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:oneMeter]];
    SMQuantity *inYards = [quantityEvaluator convertQuantity:oneMeter usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"yard"]];
    [self.secondLengthTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inYards]];
    SMQuantity *inFeet = [quantityEvaluator convertQuantity:oneMeter usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"foot"]];
    [self.thirdLengthTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inFeet]];
                                        
    
    SMQuantity *oneKilogram = [[SMQuantity alloc] init];
    [oneKilogram setValue:@1];
    [oneKilogram setUnit:[quantityEvaluator derivedUnitFromString:@"kilogram"]];
    
    [self.firstMassTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:oneKilogram]];
    SMQuantity *inMilligrams = [quantityEvaluator convertQuantity:oneKilogram usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"milligram"]];
    [self.secondMassTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inMilligrams]];
    SMQuantity *inPounds = [quantityEvaluator convertQuantity:oneKilogram usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"pound"]];
    [self.thirdMassTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inPounds]];
    
    
    SMQuantity *oneMinute = [[SMQuantity alloc] init];
    [oneMinute setValue:@1];
    [oneMinute setUnit:[quantityEvaluator derivedUnitFromString:@"minute"]];
    
    [self.firstTimeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:oneMinute]];
    SMQuantity *inSeconds = [quantityEvaluator convertQuantity:oneMinute usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"second"]];
    [self.secondTimeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inSeconds]];
    SMQuantity *inHours = [quantityEvaluator convertQuantity:oneMinute usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"hour"]];
    [self.thirdTimeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inHours]];
    
    SMQuantity *threeNewtons = [[SMQuantity alloc] init];
    [threeNewtons setValue:@3];
    [threeNewtons setUnit:[quantityEvaluator derivedUnitFromString:@"newton"]];
    
    [self.firstForceTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeNewtons]];
    SMQuantity *inPoundals = [quantityEvaluator convertQuantity:threeNewtons usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"poundal"]];
    [self.secondForceTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inPoundals]];
    SMQuantity *inPoundsFource = [quantityEvaluator convertQuantity:threeNewtons usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"pound force"]];
    [self.thirdForceTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inPoundsFource]];
    
    SMQuantity *threeLiters = [[SMQuantity alloc] init];
    [threeLiters setValue:@3];
    [threeLiters setUnit:[quantityEvaluator derivedUnitFromString:@"liter"]];
    
    [self.firstVolumeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:threeLiters]];
    SMQuantity *inPints = [quantityEvaluator convertQuantity:threeLiters usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"pint"]];
    [self.secondVolumeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inPints]];
    SMQuantity *inQuarts = [quantityEvaluator convertQuantity:threeLiters usingDerivedUnit:[quantityEvaluator derivedUnitFromString:@"quart"]];
    [self.thirdVolumeTableViewCell.textLabel setText:[quantityFormatter stringFromQuantity:inQuarts]];
    


}

@end
