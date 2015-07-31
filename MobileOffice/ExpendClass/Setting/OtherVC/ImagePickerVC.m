//
//  ImagePickerVC.m
//  MobileOffice
//
//  Created by houjing on 15/6/19.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "ImagePickerVC.h"

@interface ImagePickerVC ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIPickerView *imagePicker;
@property (nonatomic, strong) UIImage *imageSelected;

@end

@implementation ImagePickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"请选取图片";
}

- (void)initUI{
    [super initUI];
    
    self.images = @[[UIImage imageNamed:@"h0.jpg"],
                    [UIImage imageNamed:@"h1.jpg"],
                    [UIImage imageNamed:@"h2.jpg"],
                    [UIImage imageNamed:@"h3.jpg"],
                    [UIImage imageNamed:@"h4.jpg"],
                    [UIImage imageNamed:@"h5.jpg"],
                    [UIImage imageNamed:@"h6.jpg"],
                    [UIImage imageNamed:@"h7.jpg"],
                    [UIImage imageNamed:@"h8.jpg"],
                    [UIImage imageNamed:@"h9.jpg"],
                    [UIImage imageNamed:@"h10.jpg"],
                    [UIImage imageNamed:@"h11.jpg"],
                    [UIImage imageNamed:@"h12.jpg"],
                    [UIImage imageNamed:@"h13.jpg"],
                    [UIImage imageNamed:@"h14.jpg"],
                    [UIImage imageNamed:@"h15.jpg"],
                    [UIImage imageNamed:@"h16.jpg"],
                    [UIImage imageNamed:@"h17.jpg"],
                    [UIImage imageNamed:@"h18.jpg"]
                    ];
    
    self.imagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    self.imagePicker.center = self.view.center;
    self.imagePicker.delegate = self;
    self.imagePicker.dataSource = self;
    [self.view addSubview:self.imagePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [self.images count];
}

#pragma mark Picker Delegate Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return 160.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 160.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UIImage *image = self.images[row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.imageSelected = self.images[row];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
