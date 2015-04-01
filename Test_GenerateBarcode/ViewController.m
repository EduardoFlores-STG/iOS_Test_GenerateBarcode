//
//  ViewController.m
//  Test_GenerateBarcode
//
//  Created by Eduardo Flores on 4/1/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "ViewController.h"
#import "BarcodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.label_barcodeType.text = @"";
    self.label_barcodeValue.text = @"";
    
    self.buttonOutlet_generateNewBarcode.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)button_generateNewBarcode:(id)sender
{
    [self performSegueWithIdentifier:@"segueGenerateNewBarcode" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BarcodeViewController *bcvc = [segue destinationViewController];
    bcvc.barcodeValue = barcodeValue;
    bcvc.barcodeType = barcodeType;
}

- (IBAction)button_readBarcode:(id)sender
{
//    highlightView = [[UIView alloc] init];
//    highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
//    highlightView.layer.borderColor = [UIColor greenColor].CGColor;
//    highlightView.layer.borderWidth = 3;
//    [self.view addSubview:highlightView];
    
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input)
    {
        [session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.view.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    [session startRunning];
    
    //[self.view bringSubviewToFront:highlightView];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects)
    {
        for (NSString *type in barCodeTypes)
        {
            if ([metadata.type isEqualToString:type])
            {
                //NSLog(@"barcode type = %@", type);
                barcodeType = type;
                self.label_barcodeType.text = barcodeType;
                
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            barcodeValue = detectionString;
            self.label_barcodeValue.text = barcodeValue;
            [session stopRunning];
            self.buttonOutlet_generateNewBarcode.enabled = YES;
            
            // remove video layer
            NSMutableArray *subLayers = [NSMutableArray arrayWithArray:[self.view.layer sublayers]];
            for (id eachLayer in subLayers)
            {
                if ([eachLayer isKindOfClass:[AVCaptureVideoPreviewLayer class]])
                    [subLayers removeObject:eachLayer];
            }
            self.view.layer.sublayers = subLayers;
            break;
        }
        else
            NSLog(@"no text read!");
    }
    
    //highlightView.frame = highlightViewRect;
}
@end
