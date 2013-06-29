//
//  SMDetailViewController.h
//  UnitsKit Example
//
//  Created by Steve Moser on 6/29/13.
//
//

#import <UIKit/UIKit.h>

@interface SMDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
