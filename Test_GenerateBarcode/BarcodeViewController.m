//
//  BarcodeViewController.m
//  Test_GenerateBarcode
//
//  Created by Eduardo Flores on 4/1/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "BarcodeViewController.h"
#import "NKDBarcodeFramework.h"

@interface BarcodeViewController ()

@end

@implementation BarcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id barcode = [self getBarcodeOfSpecificType:self.barcodeType];
    [barcode calculateWidth];
    
    UIImage *imageOfGeneratedBarcode = [UIImage imageFromBarcode:barcode];
    self.imageView.image = [self rotateUIImage:imageOfGeneratedBarcode clockwise:YES];

}

- (id) getBarcodeOfSpecificType:(NSString *)type;
{
    if ([self.barcodeType isEqualToString:AVMetadataObjectTypeUPCECode])
    {
        return [[NKDUPCEBarcode alloc]initWithContent:type printsCaption:NO];
    }
    else if ([self.barcodeType isEqualToString:AVMetadataObjectTypeCode39Code])
    {
        return [[NKDCode39Barcode alloc]initWithContent:type printsCaption:NO];
    }
    else if ([self.barcodeType isEqualToString:AVMetadataObjectTypeCode39Mod43Code])
    {
        return [[NKDExtendedCode39Barcode alloc]initWithContent:type printsCaption:NO];
    }
    else if ([self.barcodeType isEqualToString:AVMetadataObjectTypeEAN13Code])
    {
        return [[NKDEAN13Barcode alloc]initWithContent:type printsCaption:NO];
    }
    else if ([self.barcodeType isEqualToString:AVMetadataObjectTypeEAN8Code])
    {
        return [[NKDEAN8Barcode alloc]initWithContent:type printsCaption:NO];
    }
    else if ([self.barcodeType isEqualToString:AVMetadataObjectTypeCode128Code])
    {
        return [[NKDCode128Barcode alloc]initWithContent:type printsCaption:NO];
    }
    else
        return nil; // not doing QR, PDF or other ones
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
