//
//  ViewController.swift
//  ---- obviously renamed to Main-Shit-Goes-Here.swift
//  Face2Face
//
//  Created by Rory McMeekin on 21/04/2015.
//  Copyright (c) 2015 Rory McMeekin. All rights reserved.
//



/*

    Hello!

    If you're reading this then you should know that I have no time to start this project.

    Nevertheless, let's *finally* make a social app like I've always wanted.

    It's going to be a meet-and-greet via a random photo feed a la Snapchat.

    Right now I imagine that there will be three central views:
        - LEFT:     'Friends' / Inbox
        - CENTRE:   Feed
        - RIGHT:    Leaderboard — but is there even a point in a points system?
                                - probably, because it gameifies the concept



*/

import UIKit
import AVFoundation // --> what we need to access the camera
import CoreVideo
import CoreMedia

var Myself = Person()


extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)
        self.init(timeInterval:0, sinceDate:d!)
    }
}

enum PersonalRelationship: Int {
    
    case Stranger, Friend, Myself
    
}

enum Gender: Int {
    
    case Female, Male
    
}

class Person {

    var relationship: PersonalRelationship!
    
    var name: String!
    var gender: Gender!
    var points: Int!
    
    var correspondence: [Message]?
    
    var numberOfMessages: Int {
        get {
            //
            return correspondence?.count ?? 0
      
        }
    }
    
    func sendFriendRequest() -> Bool {
      
        if (relationship == .Stranger && points < Myself.points) {
            return true
        }
        
        return false
        
    }
}

class Message {
    
    var sender: Person!
    var timestamp: NSDate!
    
    var picture: UIImage!
    var text: String!
    
    // Initialise with a PFObject or something...
    
}

class Profile: Person { // May not be necessary
    
    func updateProfilePicture(newPicture: UIImage) {
        // Will be a 'save eventually' operation so no need to return a value
        
        
    }
    /*
    init asProfile() {
    
    }
*/
    
}




// The main (and probably only?) View Controller

class FeedViewController: CameraViewController {

    //
    // Properties
    //
    

    var navScroller: UIScrollView! // The core horiztonal view controller to switch between views
    
    var feedView: UIView!
    
    /*
    let captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice?
*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navScroller = UIScrollView(frame: self.view.frame)
        
        navScroller.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height)
        navScroller.pagingEnabled = true
        

        
        
        // The INTRO
        
        //
        
        self.setupCamera()
        
        
        //
        
        feedView = UIView(frame: CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height))
        let ff = feedView.frame
        navScroller.contentOffset = CGPointMake(ff.size.width, 0)
        
        
        
        feedView.layer.addSublayer(self.previewLayer)
        navScroller.addSubview(feedView)
        
        self.view.addSubview(navScroller)
        
        
        
        
    }
        //
        /*
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDevice != nil {
            
            captureDevice!.lockForConfiguration(nil)
            captureDevice!.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
            captureDevice!.unlockForConfiguration()
            
            beginSession()
        }
        
    }
    
    func beginSession() {
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        
        captureSession.startRunning()
    }
*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    func setupCamera() {
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer);
        let width: size_t = CVPixelBufferGetWidth(imageBuffer);
        let height: size_t = CVPixelBufferGetHeight(imageBuffer);
        
        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, CGBitmapInfo.ByteOrder32Little | CGImageAlphaInfo.PremultipliedFirst);
        let newImage = CGBitmapContextCreateImage(newContext);
    
        CGContextRelease(newContext);
        
        self.cameraImage = UIImage(CGImage: newImage, scale: CGFloat(1), orientation: .DownMirrored)
        
        CGImageRelease(newImage);
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);

        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        
        
        
        self.cameraImage = [UIImage imageWithCGImage:newImage scale:1.0f orientation:UIImageOrientationDownMirrored];
        
        CGImageRelease(newImage);
        
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);

        
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
    self.previewLayer.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    self.previewLayer.orientation = AVCaptureVideoOrientationLandscapeRight;
    // CHECK FOR YOUR APP
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];   // Comment-out to hide preview layer
    
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
*/

    

}

