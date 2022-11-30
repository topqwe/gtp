

#import "ZCSlotMachine.h"
#import <QuartzCore/QuartzCore.h>

#define SHOW_BORDER 0
static BOOL isSliding = 0;
static const NSUInteger kMinTurn = 3;
@implementation ZCSlotMachine{
    
    // UI
    UIView *_contentView;
    UIImageView *_lineImageView;
    NSMutableArray *_slotScrollLayerArray;
    
    // Data
    NSArray *_slotResults;
    NSArray *_currentSlotResults;
    
    __weak id<ZCSlotMachineDataSource> _dataSource;
}

#pragma mark -View LifeCycle
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _contentView = [[UIView alloc] initWithFrame:frame];
    
        [self addSubview:_contentView];
        
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 0, 30, 160)];
        _lineImageView.center = CGPointMake(_contentView.frame.size.width / 2, _contentView.frame.origin.y + _contentView.frame.size.height / 2);
        _lineImageView.image = [UIImage imageNamed:@"verticalLine"];
        [self addSubview:_lineImageView];
        [self bringSubviewToFront:_lineImageView];
        
        self.singleUnitDuration = 0.14f;

    }
    return self;
}

- (id<ZCSlotMachineDataSource>)dataSource{
    
    return _dataSource;
}

#pragma mark - Properties Methods
- (NSArray *)slotResults {
    return _slotResults;
}

- (void)setSlotResults:(NSArray *)slotResults{
    if (!isSliding) {
        _slotResults = slotResults;
        if (!_currentSlotResults) {
            NSMutableArray *currentSlotResults = [NSMutableArray array];
            for (int i = 0; i < [slotResults count]; i++) {
                [currentSlotResults addObject:[NSNumber numberWithUnsignedInteger:0]];
            }
            _currentSlotResults = [NSArray arrayWithArray:currentSlotResults];
        }
        
        
    }
}

- (void)setDataSource:(id<ZCSlotMachineDataSource>)dataSource{
    _dataSource = dataSource;
    
    [self reloadData];
}

- (void)reloadData{
    
    if (self.dataSource) {
        
        for (CALayer *containerLayer in _contentView.layer.sublayers) {
            [containerLayer removeFromSuperlayer];
        }
        
        _slotScrollLayerArray = [NSMutableArray array];
        
        NSInteger numberOfSlots = [self.dataSource numberOfSlotsInSlotMachine:self];
        
        CGFloat slotSpacing = 0;
        if ([self.dataSource respondsToSelector:@selector(slotSpacingInSlotMachine::)]) {
            slotSpacing = [self.dataSource slotSpacingInSlotMachine:self];
        }
        
//        CGFloat slotWidth = _contentView.frame.size.width / numberOfSlots;
        CGFloat slotWidth = _contentView.frame.size.width / 3;
        for (int i = 0; i<numberOfSlots; i++) {
            // 单列layer
            CALayer *slotContainerLayer = [[CALayer alloc] init];
            slotContainerLayer.frame = CGRectMake(i * (slotWidth + slotSpacing), 0, _contentView.frame.size.width, _contentView.frame.size.height);
            slotContainerLayer.masksToBounds = YES;
            
            // 滚动layer
            CALayer *slotScrollLayer = [[CALayer alloc] init];
            slotScrollLayer.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
            
            [slotContainerLayer addSublayer:slotScrollLayer];
            
            [_contentView.layer addSublayer:slotContainerLayer];
            
            [_slotScrollLayerArray addObject:slotScrollLayer];
        }
        
        CGFloat singleUnitHeight = _contentView.frame.size.height;
        
        NSArray *slotIcons = [self.dataSource iconsForSlotsInSlotMachine:self];
        NSInteger iconCount = [slotIcons count];
        
        for (int i = 0; i<numberOfSlots; i++) {
            
            CALayer *slotScrollLayer = [_slotScrollLayerArray objectAtIndex:i];
            
            NSInteger scrollLayerTopIndex = - (i + kMinTurn + 3) * iconCount;
            
            for (int j = 0; j > scrollLayerTopIndex; j--) {
                UIImage *iconImage = [slotIcons objectAtIndex:abs(j) % iconCount];
                
                CALayer *iconImageLayer = [[CALayer alloc] init];
                
                NSInteger offsetYUnit = j + 1 + iconCount;

                iconImageLayer.frame = CGRectMake(offsetYUnit * _contentView.frame.size.width / 3, 0, _contentView.frame.size.width / 3, singleUnitHeight);
                iconImageLayer.contents = (__bridge id _Nullable)(iconImage.CGImage);
                
                CGFloat fixelW = CGImageGetWidth(iconImage.CGImage);
                
//                float image_scale = fixelW / (fixelW/2);
                float image_scale = 2;
                int image_scaleResult = ceilf(image_scale);
            
                iconImageLayer.contentsScale = image_scaleResult;

                iconImageLayer.contentsGravity = kCAGravityResizeAspect;
                [slotScrollLayer addSublayer:iconImageLayer];
            }
        }
    }
}

#pragma mark - Public Methods
- (void)startSliding{
    
    if (isSliding) {
        return;
    }
    else{
        isSliding = YES;
        
        if ([self.delegate respondsToSelector:@selector(slotMachineWillStartSliding:)]) {
            [self.delegate slotMachineWillStartSliding:self];
        }
        
        NSArray *slotIcons = [self.dataSource iconsForSlotsInSlotMachine:self];
        
        NSUInteger slotIconsCount = [slotIcons count];
        
        __block NSMutableArray *completePositionArray = [NSMutableArray array];
        
        [CATransaction begin];
        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            
            NSLog(@"结束");
            isSliding = NO;
            if ([self.delegate respondsToSelector:@selector(slotMachineDidEndSliding:)]) {
                [self.delegate slotMachineDidEndSliding:self];
            }
        }];
        
        NSLog(@"开始");
        static NSString *const keyPath = @"position.x";
        
        for (int i = 0; i<[_slotScrollLayerArray count]; i++) {
            
            CALayer *slotScrolllayer = [_slotScrollLayerArray objectAtIndex:i];
            
            NSUInteger resultIndex = [[self.slotResults objectAtIndex:i] unsignedIntegerValue];
            
            NSUInteger currentIndex = [[_currentSlotResults objectAtIndex:i] unsignedIntegerValue];
            
            NSUInteger howManyUnit = (i + kMinTurn) * slotIconsCount + resultIndex - currentIndex;
            
            CGFloat slideY = howManyUnit * (_contentView.frame.size.width / 3);
            
            CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:keyPath];
            slideAnimation.fillMode = kCAFillModeForwards;
            slideAnimation.duration = howManyUnit * self.singleUnitDuration;

            slideAnimation.toValue = [NSNumber numberWithFloat:slotScrolllayer.position.x + slideY];
            
            slideAnimation.removedOnCompletion = NO;
            
            [slotScrolllayer addAnimation:slideAnimation forKey:@"slideAnimation"];
            
            [completePositionArray addObject:slideAnimation.toValue];
        }
        
        [CATransaction commit];
    }
}


@end
