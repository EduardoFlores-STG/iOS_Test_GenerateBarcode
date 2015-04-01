//
//  BarcodeViewController.h
//  Test_GenerateBarcode
//
//  Created by Eduardo Flores on 4/1/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>   // for types of barcode

@interface BarcodeViewController : UIViewController

@property (nonatomic, copy) NSString *barcodeType;
@property (nonatomic, copy) NSString *barcodeValue;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
