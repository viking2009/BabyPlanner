//
//  BPPickerView.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPPickerView.h"
#import "UIImage+Additions.h"
#import "BPUtils.h"
#import "UIView+Sizes.h"
#import <QuartzCore/QuartzCore.h>

@interface BPPickerTableViewCell : UITableViewCell

@property (nonatomic, assign) UIEdgeInsets textInset;

@end

@implementation BPPickerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = RGB(0, 0, 1);
        self.textLabel.highlightedTextColor = RGB(80, 191, 170);
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24.f];
        self.textLabel.shadowColor = RGB(255, 255, 255);
        self.textLabel.shadowOffset = CGSizeMake(0, 0.5f);
        
        // TODO: extend
        self.textInset = UIEdgeInsetsMake(0, 8.f, 0, 8.f);
        
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] init];
    }
    
    return self;
}

- (void)setTextInset:(UIEdgeInsets)textInset
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_textInset, textInset)) {
        _textInset = textInset;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect contentViewFrame = self.contentView.bounds;
    contentViewFrame.origin.x += self.textInset.left;
    contentViewFrame.origin.y += self.textInset.top;
    contentViewFrame.size.width -= self.textInset.left + self.textInset.right;
    contentViewFrame.size.height -= self.textInset.top + self.textInset.bottom;
    
    self.textLabel.frame = contentViewFrame;
}

@end

@interface BPPickerTableView : UITableView

@end

@implementation BPPickerTableView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *tableBackgroundImage = [UIImage resizableImageWithGradient:@[RGBA(0, 0, 0, 0.6), RGBA(0, 0, 0, 0), RGBA(0, 0, 0, 0.6)] size:CGSizeMake(1, self.height) direction:UIImageGradientDirectionVertical];
    [tableBackgroundImage drawInRect:rect];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
    bezierPath.lineWidth = 7.f;
    [RGB(93, 93, 93) setStroke];
    [bezierPath stroke];
    bezierPath.lineWidth = 1.5f;
    [RGB(5, 5, 21) setStroke];
    [bezierPath stroke];
    
}

@end

@interface BPPickerView() <UITableViewDataSource, UITableViewDelegate>
{
    struct {
        unsigned int needsLayout:1;
        unsigned int delegateRespondsToNumberOfComponentsInPickerView:1;
        unsigned int delegateRespondsToNumberOfRowsInComponent:1;
        unsigned int delegateRespondsToDidSelectRow:1;
        unsigned int delegateRespondsToViewForRow:1;
        unsigned int delegateRespondsToTitleForRow:1;
        unsigned int delegateRespondsToAttributedTitleForRow:1;
        unsigned int delegateRespondsToWidthForComponent:1;
        unsigned int delegateRespondsToRowHeightForComponent:1;
        unsigned int delegateRespondsToTextAlignmentForComponent:1;
        unsigned int delegateRespondsToTextInsetForComponent:1;
        unsigned int showsSelectionBar:1;
        //        unsigned int allowsMultipleSelection:1;
        //        unsigned int allowSelectingCells:1;
        //        unsigned int soundsDisabled:1;
        //        unsigned int usesCheckedSelection:1;
        unsigned int skipsBackground:1;
    } _pickerViewFlags;
}

@property(nonatomic, strong) NSMutableArray *tables;
@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, assign) NSInteger numberOfComponents;

@property(nonatomic, strong) UIImageView *topGradient;
@property(nonatomic, strong) UIImageView *bottomGradient;

@property(nonatomic, strong) UIView *foregroundView;
@property(nonatomic, strong) CALayer *maskGradientLayer;
@property(nonatomic, strong) UIView *topLineView;
@property(nonatomic, strong) UIView *bottomLineView;

@property(nonatomic, strong) UIView *selectionIndicator;

- (void)commonInit;

@end

@implementation BPPickerView

- (void)commonInit
{
    // TODO: update
    UIImage *topGradientImage = [UIImage resizableImageWithGradient:@[RGB(226, 226, 226), RGB(205, 205, 205), RGB(137, 137, 137)] size:CGSizeMake(1, 108.f) direction:UIImageGradientDirectionVertical];
    self.topGradient = [[UIImageView alloc] initWithImage:topGradientImage];
    self.topGradient.userInteractionEnabled = NO;
    UIImage *bottomGradientImage = [UIImage resizableImageWithGradient:@[RGB(157, 156, 156), RGB(52, 52, 52)] size:CGSizeMake(1, 108.f) direction:UIImageGradientDirectionVertical];
    self.bottomGradient = [[UIImageView alloc] initWithImage:bottomGradientImage];
    self.bottomGradient.userInteractionEnabled = NO;
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = RGBA(61, 61, 61, 0.6);
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = RGBA(255, 255, 255, 0.4);
    
    self.foregroundView = [[UIView alloc] init];
    self.foregroundView.layer.cornerRadius = 7.f;
    self.foregroundView.layer.borderColor = RGB(75, 75, 75).CGColor;
    self.foregroundView.layer.borderWidth = 0.5f;
    self.foregroundView.layer.masksToBounds = YES;
    
    [self addSubview:self.topGradient];
    [self addSubview:self.bottomGradient];
    [self addSubview:self.foregroundView];
    [self addSubview:self.topLineView];
    [self addSubview:self.bottomLineView];
    
    CGRect selfFrame = self.frame;
    selfFrame.size.height = 216.f;
    selfFrame.size.width = 320.f;
    self.frame = selfFrame;
}

- (BOOL)showsSelectionIndicator
{
    return _pickerViewFlags.showsSelectionBar;
}

- (void)setShowsSelectionIndicator:(BOOL)showsSelectionIndicator
{
    if (_pickerViewFlags.showsSelectionBar != showsSelectionIndicator) {
        _pickerViewFlags.showsSelectionBar = showsSelectionIndicator;
        
        if (_pickerViewFlags.showsSelectionBar) {
            UIImage *selectionIndicatorImage = [UIImage resizableImageWithGradient:@[RGB(255, 255, 255), RGBA(255, 255, 255, 0), RGB(255, 253, 252)] size:CGSizeMake(1, 44.f) direction:UIImageGradientDirectionVertical];
            self.selectionIndicator = [[UIImageView alloc] initWithImage:selectionIndicatorImage];
            self.selectionIndicator.alpha = 0.53;
            self.selectionIndicator.layer.borderWidth = 1.f;
            self.selectionIndicator.layer.borderColor = RGBA(0, 0, 0, 0.53).CGColor;
            //            self.selectionIndicator.layer.shadowColor = RGBA(35, 51, 55, 0.8f).CGColor;
            //            self.selectionIndicator.layer.shadowOpacity = 0.8f;
            //            self.selectionIndicator.layer.shadowRadius = 1.5f;
            //            self.selectionIndicator.layer.shadowOffset = CGSizeMake(0, 3.5f);
            [self addSubview:self.selectionIndicator];
            [self setNeedsLayout];
        } else {
            [self.selectionIndicator removeFromSuperview];
            self.selectionIndicator = nil;
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}


- (void)layoutSubviews {
    
    self.foregroundView.center = CGPointMake(self.width/2, self.height/2);
    
    CGRect rect = self.bounds;
    
    
    rect.size.height /= 2;
    self.topGradient.frame = rect;
    [self sendSubviewToBack:self.topGradient];
    [self sendSubviewToBack:self.bottomGradient];
    
    rect.origin.y = rect.size.height;
    self.bottomGradient.frame = rect;
    
    self.topLineView.frame = CGRectMake(0, 0, self.width, 1.f);
    self.bottomLineView.frame = CGRectMake(0, 1, self.width, 1.f);
    [self bringSubviewToFront:self.topLineView];
    [self bringSubviewToFront:self.bottomLineView];
    
    self.selectionIndicator.frame = CGRectInset(self.bounds, self.foregroundView.left - 1, (self.height - 44.f) / 2);
    self.selectionIndicator.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.selectionIndicator.bounds].CGPath;
    [self bringSubviewToFront:self.selectionIndicator];
    
    NSLog(@"select : %@", self.selectionIndicator);
}

- (void)setDataSource:(id<BPPickerViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        
        for (UITableView *tableView in self.tables) {
            tableView.dataSource = nil;
            tableView.delegate = nil;
            [tableView removeFromSuperview];
        }
        
        self.tables = [[NSMutableArray alloc] init];

        _pickerViewFlags.delegateRespondsToNumberOfComponentsInPickerView = [self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)];
        _pickerViewFlags.delegateRespondsToNumberOfRowsInComponent = [self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)];
        
        self.numberOfComponents = 0;
        if (_pickerViewFlags.delegateRespondsToNumberOfComponentsInPickerView) {
            self.numberOfComponents = [self.dataSource numberOfComponentsInPickerView:self];
            
            for (NSInteger i = 0; i < self.numberOfComponents; i++) {
                BPPickerTableView *table = [[BPPickerTableView alloc] initWithFrame:CGRectMake(.0, -9.f, self.width / self.numberOfComponents, self.frame.size.height)];
                table.showsVerticalScrollIndicator = NO;
                table.separatorStyle = UITableViewCellSeparatorStyleNone;
                table.scrollsToTop = NO;
                table.dataSource = self;
                table.delegate = self;
                table.rowHeight = 44.f;
                table.backgroundView = [[UIView alloc] init];
                [self.foregroundView addSubview:table];
                [self.tables addObject:table];
            }
            
            [self bringSubviewToFront:self.topGradient];
            [self bringSubviewToFront:self.bottomGradient];
        }
    }
}

- (void)setDelegate:(id<BPPickerViewDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _pickerViewFlags.delegateRespondsToDidSelectRow = [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)];
        _pickerViewFlags.delegateRespondsToViewForRow = [self.delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)];
        _pickerViewFlags.delegateRespondsToTitleForRow = [self.delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)];
        _pickerViewFlags.delegateRespondsToAttributedTitleForRow = [self.delegate respondsToSelector:@selector(pickerView:attributedTitleForRow:forComponent:)];
        _pickerViewFlags.delegateRespondsToWidthForComponent = [self.delegate respondsToSelector:@selector(pickerView:widthForComponent:)];
        _pickerViewFlags.delegateRespondsToRowHeightForComponent = [self.delegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)];
        _pickerViewFlags.delegateRespondsToTextAlignmentForComponent = [self.delegate respondsToSelector:@selector(pickerView:textAlignmentForComponent:)];
        _pickerViewFlags.delegateRespondsToTextInsetForComponent = [self.delegate respondsToSelector:@selector(pickerView:textInsetForComponent:)];
        
        // TODO: update
        CGFloat widthSum = .0f;
        CGFloat selfWidth = self.width;
        NSInteger tableCount = self.tables.count;
        for (NSInteger i = 0; i < tableCount; i++) {
            CGFloat width = selfWidth / tableCount;
            if (_pickerViewFlags.delegateRespondsToWidthForComponent)
                width = [self.delegate pickerView:self widthForComponent:i];
            widthSum += width;
            UITableView *table = self.tables[i];
            CGRect frame = table.frame;
            frame.size.width = width;
            table.frame = frame;
            
            CGFloat height = (table.height - [self rowSizeForComponent:i].height) / 2;
            table.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 1.0, height)];
            table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 1.0, height)];
            //        table.contentInset = UIEdgeInsetsMake(height, 0, height, 0);
        }
        CGFloat margin = 0;// (selfWidth - widthSum) / 2;
        for (NSInteger i = 0; i < tableCount; i++) {
            UITableView *table = self.tables[i];
            CGRect frame = table.frame;
            frame.origin.x = margin;
            table.frame = frame;
            margin += frame.size.width;
        }
        self.foregroundView.frame = CGRectMake(0, 0, widthSum, self.height - 18.f);
    }
}


- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return [_tables[component] numberOfRowsInSection:0];
}

- (CGSize)rowSizeForComponent:(NSInteger)component {
    UITableView *table = _tables[component];
    CGSize size = CGSizeMake(table.width, 44.f);
    
    if (_pickerViewFlags.delegateRespondsToRowHeightForComponent)
        size.height = [self.delegate pickerView:self rowHeightForComponent:component];
    
    return size;
}

- (UIView *)viewForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UIView *view = nil;
    if (_pickerViewFlags.delegateRespondsToViewForRow)
        view = [self.delegate pickerView:self viewForRow:row forComponent:component reusingView:nil];
    
    return view;
}

- (void)reloadAllComponents
{
    [_tables makeObjectsPerformSelector:@selector(reloadData)];
}

- (void)reloadComponent:(NSInteger)component
{
    [_tables[component] reloadData];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [_tables[component] selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:animated scrollPosition:UITableViewScrollPositionMiddle];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    //    NSIndexPath *selectedIndexPath = [_tables[component] indexPathForSelectedRow];
    //    if (selectedIndexPath)
    //        return selectedIndexPath.row;
    //    else
    //        return NSNotFound;
    UITableView *table = _tables[component];
    CGFloat rowHeight = table.rowHeight;
    
    return (NSInteger)((table.contentOffset.y + rowHeight * 0.5) / rowHeight);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger component = [self.tables indexOfObject:tableView];
    if (component == NSNotFound)
        return 0;
    
    if (_pickerViewFlags.delegateRespondsToNumberOfRowsInComponent)
        return [self.dataSource pickerView:self numberOfRowsInComponent:component];
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger component = [self.tables indexOfObject:tableView];
    if (component == NSNotFound) return nil;
    
    static NSString *cellIdendifier = @"BPPickerTableViewCell";
    BPPickerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdendifier];
    if (!cell) {
        cell = [[BPPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdendifier];
        if (_pickerViewFlags.delegateRespondsToTextAlignmentForComponent)
            cell.textLabel.textAlignment = [self.delegate pickerView:self textAlignmentForComponent:component];
        
        if (_pickerViewFlags.delegateRespondsToTextInsetForComponent)
            cell.textInset = [self.delegate pickerView:self textInsetForComponent:component];
    }
    
    if (_pickerViewFlags.delegateRespondsToViewForRow) {
        static const NSInteger viewTag = 123;
        
        UIView *reusingView = [cell.contentView viewWithTag:viewTag];
        UIView *view = [self.delegate pickerView:self viewForRow:indexPath.row forComponent:component reusingView:reusingView];
        
        NSLog(@"%@: %@", indexPath, view);
        if (view && view != reusingView) {
            [reusingView removeFromSuperview];
            
            CGRect viewFrame = CGRectZero;
            viewFrame.size = [self rowSizeForComponent:component];
            view.frame = viewFrame;
            view.tag = viewTag;
            [cell.contentView addSubview:view];
        }
        
    } else {
        if (_pickerViewFlags.delegateRespondsToAttributedTitleForRow)
            cell.textLabel.attributedText = [self.delegate pickerView:self attributedTitleForRow:indexPath.row forComponent:component];
        else if (_pickerViewFlags.delegateRespondsToTitleForRow)
            cell.textLabel.text = [self.delegate pickerView:self titleForRow:indexPath.row forComponent:component];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DLog(@"self.delegate = %@", self.delegate);
    
    NSInteger component = [_tables indexOfObject:scrollView];
    
    if (_pickerViewFlags.delegateRespondsToDidSelectRow) {
        NSInteger index = [self selectedRowInComponent:component];
        [self selectRow:index inComponent:component animated:YES];
        NSLog(@"%@%i:%i", NSStringFromSelector(_cmd), component, index);
        [self.delegate pickerView:self didSelectRow:index inComponent:component];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSInteger component = [_tables indexOfObject:scrollView];
    
    if (_pickerViewFlags.delegateRespondsToDidSelectRow) {
        NSInteger index = [self selectedRowInComponent:component];
        [self.delegate pickerView:self didSelectRow:index inComponent:component];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        [self scrollViewDidEndDecelerating:scrollView];
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    UITableView *tableView = (UITableView *)scrollView;
//    CGFloat rowHeight = tableView.rowHeight;
//    
//    targetContentOffset->y = (NSInteger)((targetContentOffset->y + rowHeight / 2) / rowHeight) * rowHeight;
//}

@end