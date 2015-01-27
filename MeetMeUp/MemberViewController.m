//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import "MemberViewController.h"

@interface MemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Member *member;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.alpha = 0;

    [Member retrieveMeetUpsWithKeyword:self.memberID andCompletion:^(Member *member) {
        self.member = member;
    }];


//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=3803e4f78691614d7e70111a25e42",self.memberID]];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:[NSOperationQueue mainQueue]
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//
//                             self.member = [[Member alloc]initWithDictionary:dict];
//                           }];


}

- (void)setMember:(Member *)member
{
    _member = member;
    self.nameLabel.text = member.name;
    [self.photoImageView setImage:member.image];
    [UIView animateWithDuration:.3 animations:^{
        self.photoImageView.alpha = 1;
    }];
}

//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:member.photoURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        self.photoImageView.image = [UIImage imageWithData:data];



//    }];





@end
