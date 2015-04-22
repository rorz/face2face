// Frameworks
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

// Camera
@property (weak, nonatomic) IBOutlet UIImageView* cameraImageView;
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureSession* captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (strong, nonatomic) UIImage* cameraImage;

-(void)setupCamera;

@end