//
//  ViewController.m
//  TestRequestAPP
//
//  Created by Alexander on 17.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "SomeObj.h"

@interface ViewController ()
{
    __block BOOL stop;
}
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    
    
    
    dispatch_queue_t queue = dispatch_queue_create("some name", DISPATCH_QUEUE_CONCURRENT);
    [self exampleGroupUsage];
    
    stop = NO;
    __block UIImage *img = nil;
    dispatch_async(queue, ^{
        if(stop) return;
        NSURL *url = [NSURL URLWithString:@"http://jeffreysambells.com/img/avatar-300.png"];

        [NSThread sleepForTimeInterval:1.0];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if(stop) return;
        [NSThread sleepForTimeInterval:1.0];
        img = [UIImage imageWithData:data];
        if(stop) return;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgView.image = img;
        });
    });
}

- (void)alertViewExample
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"123" message:@"1231" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
//    [self after2Second:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [alert dismissWithClickedButtonIndex:0 animated:YES];
//        });
//    }];
}

- (IBAction)stopLoadImg:(id)sender
{
    stop = YES;
}

- (void)after1Second:(void(^)())block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1.0];
        block();
    });
}

- (void)after2Second:(void(^)())block
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2.0];
        block();
    });
}

- (void)exampleGroupUsage
{
    // пример использования группы для ожидания события
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        __block int k;
        [self after2Second:^{
            dispatch_group_leave(group);
            k = 10;
            NSLog(@"%@", @"123");
        }];
        
        NSLog(@"K %d", k);
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        NSLog(@"K %d", k);
        
        [self after1Second:^{
            NSLog(@"%@", @"321");
        }];
    });
}

#pragma mark - thread safe singleton
- (void)example2
{
    [self sharedInstance1];
    [self sharedInstance1];
    [self sharedInstance1];
    
    [self sharedInstance2];
    [self sharedInstance2];
    [self sharedInstance2];
}

- (void)sharedInstance1
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SomeObj sharedInstance];
    });
}

- (void)sharedInstance2
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SomeObj sharedInstance2];
    });
}
@end
