//
//  BTChartVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/11/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTChartVC.h"
#import "BTData.h"

@interface BTChartVC () <NSFetchedResultsControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *graphView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic)     CPTGraph *graph;

@end

@implementation BTChartVC



- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (NSDate *) startDate {
    
    NSString *Jan1ThisYear = @"01-Jan-2014";
    NSDateFormatter *Jan1Formatted = [[NSDateFormatter alloc] init];
    Jan1Formatted.dateFormat = @"dd-MMM-yyyy";
    NSDate *Jan1date = [Jan1Formatted dateFromString:Jan1ThisYear];

    
    return Jan1date;
}

- (NSDate *) toDate {
    NSString *Jun1ThisYear =@"01-Jun-2014";
    NSDateFormatter *Jun1Formatted = [[NSDateFormatter alloc] init];
    Jun1Formatted.dateFormat = @"dd-MMM-yyyy";
    NSDate *Jun1date = [Jun1Formatted dateFromString:Jun1ThisYear];
    return Jun1date;
    
}



- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    
    NSArray *sections = [self.fetchedResultsController sections];
  //  uint len = (uint)[sections count];
  //  NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    id obj = [sections objectAtIndex:0];
    uint c = (uint)[obj numberOfObjects];
    
    return c; //[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] ; //150;
}

- (NSNumber *) numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    
  //  int oneDay = 24*60*60;
  //  int oneWeek = oneDay*7;
  //  int x = oneWeek*25; //idx -4;
    
  //  NSIndexPath *indexNew = [NSIndexPath indexPathWithIndex:idx ];
    
        NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    
    BTData *myObject = fetchedObjects[idx];
    
 //  BTData *item  = [self.fetchedResultsController objectAtIndexPath:idx];
    
    NSDate *responseDate = myObject.responseDate;
    
    NSTimeInterval timeInt = [responseDate timeIntervalSinceDate:[self startDate]];
    //int numDays = idx*oneDay;
    
    NSNumber *responseTime = myObject.responseTime;
    double rt = [responseTime doubleValue] * 1000;
    
    NSNumber *numRT = [NSNumber numberWithInt:(int)rt];
    
    
    
    if(fieldEnum == CPTScatterPlotFieldX){
        return [NSNumber numberWithInt:timeInt];
    } else {
        return numRT; //[NSNumber numberWithInt:(arc4random() % 1000)];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // self.BTResponse = [NSEntityDescription insertNewObjectForEntityForName:@"BTData" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTData"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"responseDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"responseTime" ascending:YES]];
    
    
    //   self.results = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    bool success = [self.fetchedResultsController performFetch:&error];
    
    if (!success) {NSLog(@"no results from Fetch in Chart: %@",error.description);}

    [self.graph reloadData];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
 
    CPTGraphHostingView *hostView = [[CPTGraphHostingView alloc] initWithFrame:self.graphView.frame];
    [self.view addSubview:hostView];
    
    self.graph = [[CPTXYGraph alloc] initWithFrame:hostView.bounds];
    hostView.hostedGraph = self.graph;
    
    CPTColor *backgroundColor = [CPTColor yellowColor];
//    CPTColor *axisLabelColor = [CPTColor redColor];
    self.graph.fill = [CPTFill fillWithColor:backgroundColor];
  //  self.graph.plotAreaFrame.fill = [CPTFill fillWithColor:backgroundColor];
   // self.graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:backgroundColor];
    
    
    
    self.graph.paddingBottom = 0.0;
    
    NSTimeInterval oneDay = 24*60*60;
    NSTimeInterval oneWeek = oneDay * 7;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graph.axisSet;
    
    //axisSet.
    
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(500);
    axisSet.yAxis.minorTicksPerInterval = 10;
    axisSet.yAxis.title = @"msec";
    axisSet.yAxis.titleOffset = 50;
  //  axisSet.xAxis.title = @"date";
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(oneWeek*4);
    axisSet.xAxis.minorTicksPerInterval = 4;
    

    
    NSDate *startDate = [self startDate];
 //   NSDate *endDate = [self toDate];
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterShortStyle;
    CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc]initWithDateFormatter:dateFormatter];
    
    timeFormatter.referenceDate = startDate;
    axisSet.xAxis.labelFormatter = timeFormatter;
    axisSet.xAxis.labelRotation = M_PI /4;
    
    
    
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) self.graph.defaultPlotSpace;
    
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-8*oneWeek) length:CPTDecimalFromFloat(30*oneWeek)]];
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-400) length:CPTDecimalFromFloat(2300)]];
    
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
  //  plot.dataLineStyle = nil;
  //  plot.interpolation = CPTScatterPlotInterpolationStepped;
    plot.dataLineStyle = nil;
    plot.plotSymbol = [CPTPlotSymbol crossPlotSymbol];
    
    
    plot.dataSource = self;
    
    [self.graph addPlot:plot toPlotSpace:self.graph.defaultPlotSpace];
                                                                                                               
                                                                                                               
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)themeTapped:(id)sender {
}

@end
