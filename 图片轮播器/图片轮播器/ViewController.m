//
//  ViewController.m
//  图片轮播器
//
//  Created by 章芝源 on 16/1/13.
//  Copyright © 2016年 ZZY. All rights reserved.
//

///图片轮播器
#import "ViewController.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import <Masonry.h>
#define ZYIMAGECOUNT 5
@interface ViewController ()<UIScrollViewDelegate>
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
}

- (void)setupUI
{
    //scrollView创建
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    CGFloat scrollViewH = 130;
    CGFloat scrollViewW = 300;
    CGFloat scrollViewX = ([UIScreen mainScreen].bounds.size.width - scrollViewW) / 2;
    scrollView.frame = CGRectMake(scrollViewX, 50, scrollViewW, scrollViewH);
    [self.view addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.scrollView = scrollView;
    //添加定时器
    [self addTimer];

    //pageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    [pageControl makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView).multipliedBy(0.5);
        make.width.equalTo(self.scrollView).multipliedBy(0.5);
        make.bottom.equalTo(self.scrollView.bottom).offset(20);
    }];

    CGFloat imageH = 130;
    CGFloat imageW = 300;
    CGFloat imageY = 0;
    
    //动态创建UIImageView
    for (int i = 0; i < 5 ; i++ ) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *imageString = [NSString stringWithFormat:@"img_0%d", i];
        imageView.image = [UIImage imageNamed:imageString];
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.scrollView addSubview:imageView];
    }
    
    self.scrollView.contentSize = CGSizeMake(ZYIMAGECOUNT * imageW, imageH);
    
    //测试多线程:  创建textView
    UITextView *textView = [[UITextView alloc]init];
    [self.view addSubview:textView];
    textView.font = [UIFont systemFontOfSize:40];
    textView.text = @"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxx";
    [textView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.view).multipliedBy(0.3);
        make.right.equalTo(self.scrollView);
        make.topMargin.equalTo(self.scrollView.bottom).offset(30);
    }];
}

#pragma mark - scrollView代理方法
//判断是不是被翻到了下一页    判断依据:偏移范围是不是超出 0.5的页面比例
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获取当前scrollView的偏移量
    CGPoint point = self.scrollView.contentOffset;
    CGFloat width = self.scrollView.bounds.size.width;
    
    NSInteger page = ( point.x + width * 0.5 ) / width;
    self.pageControl.currentPage = page;
}

///当用户手指在scrollView上开始拖拽的时候, 移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

///当用户手指结束scrollView拖拽的时候, 添加定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];  
}

///添加定时器
- (void)addTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

///移除定时器
- (void)removeTimer
{
    //是定时器无效化
    [self.timer invalidate];
    //防止野指针
    self.timer = nil;
}

///下一张图片
- (void)nextImage
{
    NSInteger page = self.pageControl.currentPage;
    //判断有没有到尾页
    if (page == self.pageControl.numberOfPages - 1) {
        page = 0;
    }else{
        //没到尾页 图片索引加一
        page++;
    }
    
    //计算偏移距离
    CGFloat offsex = self.scrollView.bounds.size.width * page;
    //进行偏移
    [self.scrollView setContentOffset:CGPointMake(offsex, 0) animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
