//
//  ViewController.h
//  Test_GenerateBarcode
//
//  Created by Eduardo Flores on 4/1/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *prevLayer;
    
    NSString *barcodeType;
    NSString *barcodeValue;
}

@property (weak, nonatomic) IBOutlet UILabel *label_barcodeType;
@property (weak, nonatomic) IBOutlet UILabel *label_barcodeValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet_generateNewBarcode;


- (IBAction)button_readBarcode:(id)sender;
- (IBAction)button_generateNewBarcode:(id)sender;

@end

