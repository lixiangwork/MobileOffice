//
//  FileUploadVC.m
//  MobileOffice
//
//  Created by MacAir2 on 15/5/27.
//  Copyright (c) 2015年 lixiang. All rights reserved.
//

#import "FileUploadVC.h"
#import "AppCore.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FileUploadVC ()<UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTF;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;

@property (strong, nonatomic) UIImage *selectImage;

- (IBAction)chooseFileButtonClicked:(id)sender;
- (IBAction)uploadButtonClicked:(id)sender;

@end

@implementation FileUploadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"文件上传";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_fileNameTF isFirstResponder]) {
        [_fileNameTF resignFirstResponder];
    }
}

#pragma mark - IBAction
- (IBAction)chooseFileButtonClicked:(id)sender {
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相机获取",@"从相册获取", nil];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)uploadButtonClicked:(id)sender {
    [_fileNameTF resignFirstResponder];
    
    if (!_selectImage) {
        [UIFactory showAlert:@"请先选择上传文件"];
    }
    else{
        
        NSData* imgData =  [[NSData alloc] initWithData:UIImageJPEGRepresentation(_selectImage, 0.2)];
        //NSData* imgData =  [[NSData alloc] initWithData:UIImagePNGRepresentation(_selectImage)];

        
        NSMutableArray *properties = [[NSMutableArray alloc] init];
        PropertyItem *pItem1 = [[PropertyItem alloc] init];
        pItem1.name = @"zh_wzbt";
        pItem1.type = @"12";
        pItem1.value = _fileNameTF.text;
        [properties addObject:pItem1];
        
        PropertyItem *pItem2 = [[PropertyItem alloc] init];
        pItem2.name = @"comment_num";
        pItem2.type = @"12";
        pItem2.value = @"0";
        [properties addObject:pItem2];
        
//        PropertyItem *pItem3 = [[PropertyItem alloc] init];
//        pItem3.name = @"shares";
//        pItem3.type = @"12";
//        
//        pItem3.value = @"";
//        [properties addObject:pItem3];
        
        PropertyItem *pItem4 = [[PropertyItem alloc] init];
        pItem4.name = @"creater";
        pItem4.type = @"12";
        pItem4.value = [[[User sharedUser] getUserGlobalDic] objectForKey:uUserName];
        [properties addObject:pItem4];

        [self showHudWithMsg:@"上传中..."];
        ////////////
        [[CloudService sharedInstance] insertContentWithPropertyList:properties andContentType:@"test_table_1" andSourceFileName:[NSString stringWithFormat:@"%@.png",_fileNameTF.text] andInputstream:[GTMBase64 encodeData:imgData] withBlock:^(NSString *contentID, NSError *error) {
            [self hideHud];
            if (!error) {
                if (contentID) {
                    
                    [self.selectImageButton setImage:[UIImage imageNamed:@"upload_add.png"] forState:UIControlStateNormal];
                    [self.nameView setHidden:YES];
                    
                    [UIFactory showAlert:@"上传成功"];
                    
                    [kNotificationCenter postNotificationName:NoticeUploadFileSuccess object:nil];
                    
                }
                else {
                    [UIFactory showAlert:@"上传失败"];
                }
            }
            else {
                [UIFactory showAlert:@"网络错误"];
            }
        }];

    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark -
#pragma mark ActinoSheet delegate methods


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"button clicked :%d", buttonIndex);
    if (buttonIndex == 0) {
        
        //检查相机模式是否可用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"sorry, no camera or camera is unavailable.");
        }
        else{
            UIImagePickerController* ImagePicker  = [[UIImagePickerController alloc] init];
            ImagePicker.delegate = self;
            ImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:ImagePicker animated:YES completion:nil];
            
        }
        
    }
    else if(buttonIndex == 1 ){
        UIImagePickerController* ImagePicker  = [[UIImagePickerController alloc] init];
        ImagePicker.delegate = self;
        ImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:ImagePicker animated:YES completion:nil];
    }
    else if (buttonIndex == 2){
        NSLog(@"pdf上传");
    }
}

#pragma mark -
#pragma mark UIImagePicker methods delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    _selectImage = image;
    
    [_selectImageButton setImage:image forState:UIControlStateNormal];
    
    ///
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:imageURL resultBlock:^(ALAsset *asset) {
        _fileNameTF.text = [asset.defaultRepresentation.filename stringByDeletingPathExtension];
        
        if (_fileNameTF.text.length <= 0) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMddHHMMSS"];
            
            _fileNameTF.text = [NSString stringWithFormat:@"IMG_%@",[formatter stringFromDate:[NSDate date]]];
        }
        
    } failureBlock:^(NSError *error) {
        NSLog(@"error:%@",[error description]);
    }];
    _nameView.hidden = NO;
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}




@end



