//
//  CustomTableViewCell.h
//  LetoApp
//
//  Created by Jake Holdom on 15/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UIImageView *movieImage;

@end
