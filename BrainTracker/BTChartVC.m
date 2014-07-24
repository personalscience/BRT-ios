//
//  BTChartVC.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/11/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTChartVC.h"
#import "BTDataSession.h"

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
    
    NSString *Apr1ThisYear = @"01-Apr-2014";
    NSDateFormatter *Apr1Formatted = [[NSDateFormatter alloc] init];
    Apr1Formatted.dateFormat = @"dd-MMM-yyyy";
    NSDate *Mar1date = [Apr1Formatted dateFromString:Apr1ThisYear];

    
    return Mar1date;
}

// this method is not currently used. to increase the length of the y-axis, adjust the number of weeks in the calculation in plotSpace under ViewDidLoad() below
- (NSDate *) toDate {
    NSString *Aug1ThisYear =@"01-Aug-2014";
    NSDateFormatter *Aug1Formatted = [[NSDateFormatter alloc] init];
    Aug1Formatted.dateFormat = @"dd-MMM-yyyy";
    NSDate *Aug1date = [Aug1Formatted dateFromString:Aug1ThisYear];
    return Aug1date;
    
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
    
    BTDataSession *myObject = fetchedObjects[idx];
    
 //  BTData *item  = [self.fetchedResultsController objectAtIndexPath:idx];
    
    NSDate *sessionDate = myObject.sessionDate;
    
    NSTimeInterval timeInt = [sessionDate timeIntervalSinceDate:[self startDate]];
    //int numDays = idx*oneDay;
    
    NSNumber *sessionScore = myObject.sessionScore;
    double rt = [sessionScore doubleValue] * 100;
    
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"BTDataSession"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sessionDate" ascending:NO],
                                     [NSSortDescriptor sortDescriptorWithKey: @"sessionScore" ascending:YES]];
    
    
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
    
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(100);
    axisSet.yAxis.minorTicksPerInterval = 10;
    axisSet.yAxis.title = @"Percentile";
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
    
    [plotSpace setXRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-2*oneWeek) length:CPTDecimalFromFloat(25*oneWeek)]];
    [plotSpace setYRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-20) length:CPTDecimalFromFloat(120)]];
    
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
