#import "CameraViewController.h"

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self setupCamera];
    // [self setupTimer];
}


- (void)setupCamera
{
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *device in devices)
    {
        if([device position] == AVCaptureDevicePositionFront)
            self.device = device;
    }
    
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc] init];
    output.alwaysDiscardsLateVideoFrames = YES;
    
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    NSString* key = (NSString *) kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [output setVideoSettings:videoSettings];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    [self.captureSession addOutput:output];
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // CHECK FOR YOUR APP
    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSLog(@"preview frame:\n\nx:%f.2, y:%f.2, w:%f.2, h%f.2\n\n\n\n", self.previewLayer.frame.origin.x, self.previewLayer.frame.origin.y, self.previewLayer.frame.size.width, self.previewLayer.frame.size.height);
    // self.previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
    // CHECK FOR YOUR APP
    
    // [self.view.layer insertSublayer:self.previewLayer atIndex:0];   // Comment-out to hide preview layer
    
    [self.captureSession startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
    CGContextRelease(newContext);
    CGColorSpaceRelease(colorSpace);
    
    self.cameraImage = [UIImage imageWithCGImage:newImage scale:1.0f orientation:UIImageOrientationDownMirrored];
    
    CGImageRelease(newImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
}

- (void)setupTimer
{
    NSTimer* cameraTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(snapshot) userInfo:nil repeats:YES];
}

- (void)snapshot
{
    NSLog(@"SNAPSHOT");
    self.cameraImageView.image = self.cameraImage;  // Comment-out to hide snapshot
}

@end