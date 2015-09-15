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


@end
NSMutableArray *movies;
NSMutableDictionary *items;
NSXMLParser *RSSParse;
NSString *currentElement;
NSMutableString *movieTitle, *imgUrl;

UIActivityIndicatorView *activity;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

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
