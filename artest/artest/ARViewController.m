//
//  ARViewController.m
//  artest
//
//  Created by LLZ on 2017/10/31.
//  Copyright © 2017年 LLZ. All rights reserved.
//

#import "ARViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

@interface ARViewController ()<ARSCNViewDelegate, ARSessionDelegate>

@property (nonatomic, strong) ARSCNView *arSceneView;
@property (nonatomic, strong) ARWorldTrackingConfiguration *config;
@property (nonatomic, strong) ARSession *arSession;

@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(navBack)];
    self.navigationItem.leftBarButtonItem = item;
    
    [self.view addSubview:self.arSceneView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.arSceneView.session runWithConfiguration:self.config];
    //    [self.arSession runWithConfiguration:self.config];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.arSceneView.session pause];
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (ARSCNView *)arSceneView
{
    if (!_arSceneView) {
        _arSceneView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
        _arSceneView.session = self.arSession;
        _arSceneView.delegate = self;
    }
    return _arSceneView;
}

- (ARWorldTrackingConfiguration *)config
{
    if (!_config) {
        _config = [ARWorldTrackingConfiguration new];
        _config.planeDetection = ARPlaneDetectionHorizontal;//plant检测（当开启平地捕捉模式之后，如果捕捉到平地，ARKit会自动在当前的ARSCNViewAR添加一个平地节点）
        _config.lightEstimationEnabled = YES;//自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    }
    return _config;
}

- (ARSession *)arSession
{
    if (!_arSession) {
        _arSession = [ARSession new];
        _arSession.delegate = self;
    }
    return _arSession;
}

#pragma mark - ARSCNViewDelegate
//根据ARSCNView返回的anchor，返回自定义将要添加的一个SCNNode
//- (nullable SCNNode *)renderer:(id <SCNSceneRenderer>)renderer nodeForAnchor:(ARAnchor *)anchor
//{
//    NSLog(@"%@", anchor);
//    return nil;
//}
- (void)renderer:(id <SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    if ([anchor isKindOfClass:[ARPlaneAnchor class]]) {
        //1.获取捕捉到的平地锚点
        ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
        //2.创建一个3D物体模型    （系统捕捉到的平地是一个不规则大小的长方形，这里笔者将其变成一个长方形，并且是否对平地做了一个缩放效果）
        //参数分别是长宽高和圆角
        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x height:planeAnchor.extent.y length:planeAnchor.extent.z chamferRadius:0];
//        SCNBox *plane = [SCNBox boxWithWidth:planeAnchor.extent.x*0.3 height:0 length:planeAnchor.extent.x*0.3 chamferRadius:0];
        //3.使用Material渲染3D模型（默认模型是白色的，这里笔者改成红色）
        plane.firstMaterial.diffuse.contents = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        
        //4.创建一个基于3D物体模型的节点
        SCNNode *planeNode = [SCNNode nodeWithGeometry:plane];
        //5.设置节点的位置为捕捉到的平地的锚点的中心位置  SceneKit框架中节点的位置position是一个基于3D坐标系的矢量坐标SCNVector3Make
        planeNode.position =SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
        
        //self.planeNode = planeNode;
        [node addChildNode:planeNode];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //1.创建一个场景
            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/Medieval_building.scn"];
            //2.获取节点
            SCNNode *houseNode = scene.rootNode;
            
            //4.位置为捕捉到的平地的位置，如果不设置，则默认为原点位置，也就是相机位置
            houseNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
            houseNode.eulerAngles = SCNVector3Make(-M_PI/2, 0, 0);
            houseNode.scale = SCNVector3Make(0.2, 0.2, 0.2);
            //5.将花瓶节点添加到当前屏幕中
            //!!!此处一定要注意：house节点是添加到代理捕捉到的节点中，而不是AR视图的根节点。因为捕捉到的平地锚点是一个本地坐标系，而不是世界坐标系
            [node addChildNode:houseNode];
        });
    }
}
- (void)renderer:(id <SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}
- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    
}

#pragma mark - ARSessionDelegate
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    
}
- (void)session:(ARSession *)session didAddAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}
- (void)session:(ARSession *)session didUpdateAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}
- (void)session:(ARSession *)session didRemoveAnchors:(NSArray<ARAnchor*>*)anchors
{
    
}
@end
