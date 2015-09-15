//
//  ViewController.m
//  LetoApp
//
//  Created by Jake Holdom on 15/09/2015.
//  Copyright (c) 2015 Jake Holdom. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableViewCell.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *orderMovies;
@property (strong, nonatomic) UIPickerView *orderByPicker;
@property (strong, nonatomic) UITextField *pickerTextField;



@end
NSMutableArray *movies;
NSMutableDictionary *items;
NSXMLParser *RSSParse;
NSString *currentElement;
NSMutableString *movieTitle, *imgUrl;

UIActivityIndicatorView *activity;
NSArray *orderByArray;
NSInteger selectedRow;

BOOL ascending = YES;



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    
    [self initialisePickerView];
    
    


    
}

- (void)initialisePickerView{
    
    
    self.pickerTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerTextField];
    
    self.orderByPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [self.orderByPicker setDataSource: self];
    [self.orderByPicker setDelegate: self];
    self.orderByPicker.showsSelectionIndicator = YES;
    self.pickerTextField.inputView = self.orderByPicker;
    orderByArray = [NSArray arrayWithObjects:@"Ascending",@"Descending",nil];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerTextField.inputAccessoryView = toolBar;
    
}
- (IBAction)doneTouched:(id)sender{
    
    
    



    
    if (selectedRow == 0) {
        
        
            NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            [movies sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            
            
            [self.tableView reloadData];
        
        self.orderMovies.titleLabel.text = @"Order Movies by: Asc";

    
        
    }
    if (selectedRow == 1) {
        
        
        NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO];
        [movies sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        
        
        [self.tableView reloadData];
        
        self.orderMovies.titleLabel.text = @"Order Movies by: Desc";
        
    }

  
    [self.pickerTextField resignFirstResponder];

    
    
}


- (IBAction)cancelTouched:(id)sender{
    
    
    
    [self.pickerTextField resignFirstResponder];
    
    
}

- (IBAction)orderMovies:(id)sender {
    
    
    [self.pickerTextField becomeFirstResponder];
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [orderByArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *orderString = [orderByArray objectAtIndex:row];
    
    return orderString;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    

    selectedRow = row;


}
    
   
    
  //  self.NoBedrooms.text = [bedroomPicker objectAtIndex:row];

    
    // perform some action


-(void)viewDidAppear:(BOOL)animated{
    
    
    if (movies.count == 0) {
        
        NSString * path = @"http://www.fandango.com/rss/newmovies.rss";
        [self parseXMLFileAtURL:path];
    }
    

    
    
}



- (void)parseXMLFileAtURL:(NSString *)URL {
    movies = [[NSMutableArray alloc] init];
    
    NSURL *xmlURL = [NSURL URLWithString:URL];
    
    RSSParse = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    

    [RSSParse setDelegate:self];
    [RSSParse setShouldReportNamespacePrefixes:NO];
    [RSSParse setShouldResolveExternalEntities:NO];
    [RSSParse setShouldProcessNamespaces:NO];
    [RSSParse parse];
    
    
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString * errorString = [NSString stringWithFormat:@"Error (Error code %li )", (long)[parseError code]];
    NSLog(@"error: %@", errorString);
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Unable to load content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    
    if ([elementName isEqualToString:@"item"]) {

        items = [[NSMutableDictionary alloc] init];
        movieTitle = [[NSMutableString alloc] init];
        
    }
    if ([elementName isEqualToString:@"enclosure"]) {
        imgUrl = [attributeDict objectForKey:@"url"];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"item"]) {
        [items setObject:movieTitle forKey:@"title"];
        [items setObject:imgUrl forKey:@"url"];
        
        [movies addObject:[items copy]];
        NSLog(@"adding title: %@", movieTitle);
        NSLog(@"adding image: %@", imgUrl);
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([currentElement isEqualToString:@"title"]) {
        [movieTitle appendString:string];
    }
    else if ([currentElement isEqualToString:@"enclosure"]) {
        [imgUrl appendString:string];
    }


}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [activity stopAnimating];
    [activity removeFromSuperview];
    
    
    
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [movies sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    ascending = YES;
    
    [self.tableView reloadData];
    
    
  //  NSLog(@"%@", movies);
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return movies.count;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    CustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    cell.movieTitle.text = [[movies objectAtIndex:indexPath.row] objectForKey: @"title"];

   cell.movieImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[movies objectAtIndex:indexPath.row] objectForKey:@"url"]]]];
    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
