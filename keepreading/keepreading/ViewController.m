//
//  ViewController.m
//  keepreading
//
//  Created by FanFamily on 15/12/26.
//  Copyright © 2015年 glory. All rights reserved.
//

#import "ViewController.h"
#import "BookCore.h"
#import "RVTask.h"
#import "BookTableViewCell.h"
#import "BookTableView.h"
#import "UIImageView+WebCache.h"

static NSString *cellIdentifier = @"BookTableViewCellIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate>

@property (nonatomic) UIView* menuView;
@property (nonatomic) UIButton* menuButton;
@property (nonatomic, weak) IBOutlet BookTableView* tableView;
@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) UIGravityBehavior* gravityBehaior;
@property (nonatomic) UICollisionBehavior *collision;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushInitBehavior;
@property (nonatomic) UIPushBehavior *pushDownBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehaviour;
@property (nonatomic, assign) BOOL atTop;
@property (nonatomic) NSArray* books;

@end

@implementation ViewController

- (CGFloat)screenWith
{
    return [[UIScreen mainScreen] bounds].size.width;
}

- (CGFloat)screenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)navigationBarHeight
{
    return 64.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navigationBarSetup];
    [self menuViewSetup];
    [self tableViewSetup];
    [self animationBehaiorSetup];
    
    [RVTask mountaintop].thenFinishSetYourself(^(RVTask *preTask, void (^finishBlock)(id result)) {
        [[BookCore sharedInstance] searchBooksWithName:@"面包" completeHandler:^(NSArray *books, NSError *error) {
            finishBlock(books);
        }];
    }).then(^id(RVTask *preTask) {
        self.books = preTask.result;
        return nil;
    }).then(^id(RVTask *preTask) {
        [self.tableView reloadData];
        return nil;
    });
}

- (void)navigationBarSetup
{
    UINavigationBar* navBar = self.navigationController.navigationBar;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setBackgroundImage:[UIImage imageNamed:@"patternNav"] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[[UIImage alloc] init]];
}

- (void)menuViewSetup
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.screenWith, self.screenHeight)];
    self.menuView.backgroundColor = [UIColor colorWithRed:65.0 / 255.0 green:62.f / 255.f blue:79.f / 255.f alpha:1];
    self.menuView.alpha = 0.0;
    [self.view addSubview:self.menuView];
    
    self.menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.menuButton.enabled = NO;
    [self.menuButton addTarget:self action:@selector(switchMenuState) forControlEvents:UIControlEventTouchUpInside];
    [self.menuButton setImage:[UIImage imageNamed:@"menuButton"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButton];
    self.atTop = YES;
}

- (void)tableViewSetup
{
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view sendSubviewToBack:self.tableView];
}

- (void)animationBehaiorSetup
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator.delegate = self;
    
    // - Gravity Behavior
    self.gravityBehaior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView]];
    
    // - Item Behavior
    self.itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.menuView]];
    self.itemBehaviour.elasticity = 0.5;
    self.itemBehaviour.resistance = 1.5;
    self.itemBehaviour.allowsRotation = YES;
    
    // - Collision Behavior
    self.collision = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    self.collision.collisionDelegate = self;
    [self.collision addBoundaryWithIdentifier:@"Collide left" fromPoint:CGPointMake(-2, [self screenHeight]/2) toPoint:CGPointMake(-2, [self screenHeight])];
    [self.collision addBoundaryWithIdentifier:@"Collide top" fromPoint:CGPointMake([self screenHeight]/2, - [self navigationBarHeight] - [self screenWith]) toPoint:CGPointMake([self screenHeight], [self navigationBarHeight] - [self screenWith])];
    [self.animator addBehavior:self.collision];
    
    CGPoint puntoAncoraggio = CGPointMake(([self navigationBarHeight]/2.0),([self navigationBarHeight]/2.0));
    
    // - Attachment Behavior
    UIOffset offset = UIOffsetMake(-self.view.bounds.size.width/2 + puntoAncoraggio.x , -self.view.bounds.size.height/2 + puntoAncoraggio.y);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.menuView offsetFromCenter:offset attachedToAnchor:puntoAncoraggio];
    [self.animator addBehavior:self.attachmentBehavior];
    
    // - Push Init
    self.pushInitBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView] mode:UIPushBehaviorModeContinuous];
    CGVector vector = CGVectorMake(1000, 0);
    self.pushInitBehavior.pushDirection = vector;
    UIOffset offsetPush = UIOffsetMake(0, [self screenWith]/2);
    [self.pushInitBehavior setTargetOffsetFromCenter:offsetPush forItem:self.menuView];
    [self.animator addBehavior:self.pushInitBehavior];
    
    self.pushDownBehavior = [[UIPushBehavior alloc] initWithItems:@[self.menuView] mode:UIPushBehaviorModeContinuous];
    CGVector vectorOpen = CGVectorMake(0, 1500.0);
    self.pushDownBehavior.pushDirection = vectorOpen;
}

-(void)switchMenuState{
    if (self.atTop) {
        [self dropDownMenu];
        self.atTop = NO;
    } else {
        [self pushUpMenu];
        self.atTop = YES;
    }
}

- (void)dropDownMenu
{
    [self.animator removeBehavior:self.pushInitBehavior];
    [self.animator addBehavior:self.itemBehaviour];
    [self.animator addBehavior:self.gravityBehaior];
    [self.animator addBehavior:self.pushDownBehavior];
}

- (void)pushUpMenu
{
    [self.animator removeBehavior:self.itemBehaviour];
    [self.animator removeBehavior:self.gravityBehaior];
    [self.animator removeBehavior:self.pushDownBehavior];
    [self.animator addBehavior:self.pushInitBehavior];
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    
    NSString *identifierString = [NSString stringWithFormat:@"%@", identifier];
    
    if([identifierString isEqualToString:@"Collide top"]){
        self.menuView.alpha = 1.0;
        self.menuButton.enabled = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book* book = [self.books objectAtIndex:indexPath.row];
    BookTableViewCell* cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell.surface sd_setImageWithURL:[NSURL URLWithString:book.imageUrl]];;
    cell.title.text = book.title;
    cell.summary.text = book.summary;
    cell.author.text = book.authors.firstObject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
