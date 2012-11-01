/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author "Esteban Robles Luna <esteban.roblesluna@gmail.com>"
 */
@implementation PropertiesFigure : Figure 
{ 
	Drawing _drawing;
	Figure _selectedFigure;
	CPTableColumn _nameColumn;
	CPTableColumn _valueColumn;
	CPTableView _tableView;
}

+ (CPRect) defaultFrame
{
	return CGRectMake(10, 450, 700, 100);
}

+ (PropertiesFigure) newAt: (CGPoint) aPoint drawing: (Drawing) aDrawing
{
	var frame = CGRectMake(aPoint.x, aPoint.y, 700, 100);
	var figure = [[self new] initWithFrame: frame drawing: aDrawing];
	return figure;
}

- (id) initWithFrame: (CGRect) aFrame drawing: (Drawing) aDrawing
{ 
	self = [super initWithFrame:aFrame];
	if (self) {
		_drawing = aDrawing;
		_selectedFigure = nil;
		
		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(selectionChanged) 
			name: DrawingSelectionChangedNotification 
			object: _drawing];
			
		var scrollFrame = CGRectMake(5, 0, 695, 100);
		var scrollView = [[CPScrollView alloc] initWithFrame: scrollFrame];
		[scrollView setAutohidesScrollers: YES];
		_tableView = [[CPTableView alloc] initWithFrame: CGRectMakeZero()];
		[_tableView setDoubleAction: @selector(doubleClick:) ]; 
		[_tableView setUsesAlternatingRowBackgroundColors: YES];
		[_tableView setAutoresizingMask: CPViewWidthSizable | CPViewHeightSizable];

		_nameColumn = [[CPTableColumn alloc] initWithIdentifier:@"nameColumn"];
		[[_nameColumn headerView] setStringValue:@"Name"];
		[_nameColumn setMinWidth: 200];
		[_nameColumn setEditable: NO];
		[_tableView addTableColumn: _nameColumn];

		_valueColumn = [[CPTableColumn alloc] initWithIdentifier:@"valueColumn"];
		[[_valueColumn headerView] setStringValue:@"Value"];
		[_valueColumn setMinWidth: 400];
		[_valueColumn setEditable: YES];
		[_tableView addTableColumn: _valueColumn];

	    [scrollView setDocumentView: _tableView];

	    [_tableView setDataSource: self];
	    [_tableView setDelegate: self];

	    [self addSubview: scrollView];
		[scrollView setAutoresizingMask: CPViewWidthSizable];

		_selectable = true;
		_moveable = true;
	
		return self;
	}
}

- (void) doubleClick: (id) anObject
{
	var column = 1;
	var row = [_tableView selectedRow];

	[_tableView 
		editColumn: column
		row: row
		withEvent: nil
		select:YES];
}

- (int) numberOfRowsInTableView: (CPTableView) aTableView 
{
    if (_selectedFigure == nil) {
		return 0;
	} else {
		var model = [_selectedFigure model];
		//CPLog.info(model);
		if (model != nil) {
			var size = [model propertiesSize];
			//CPLog.info(size);
			return size;
		} else {
			return 0;
		}
	}	
}

- (id) tableView: (CPTableView) aTableView objectValueForTableColumn: (CPTableColumn) aTableColumn row: (int) rowIndex 
{
	var model = [_selectedFigure model];
	if (_nameColumn == aTableColumn) {
		return [model propertyNameAt: rowIndex];
	} else {
		return [model propertyValueAt: rowIndex];
	}
}

- (void) tableView: (CPTableView) aTableView setObjectValue: (id) aValue forTableColumn: (CPTableColumn) aTableColumn row: (int) rowIndex 
{
	var model = [_selectedFigure model];
	if (aTableColumn == _valueColumn) {
		return [model propertyValueAt: rowIndex be: aValue];
	}
}

- (void) selectionChanged
{
	if (_selectedFigure != nil) {
		var model = [_selectedFigure model];
		if (model != nil) {
			[[CPNotificationCenter defaultCenter] 
				removeObserver: self 
				name: ModelPropertyChangedNotification 
				object: model];
		}
	}

	_selectedFigure = [_drawing selectedFigure];

	if (_selectedFigure != nil) {
		var model = [_selectedFigure model];
		if (model != nil) {
			[[CPNotificationCenter defaultCenter] 
				addObserver: self 
				selector: @selector(reloadData) 
				name: ModelPropertyChangedNotification 
				object: model];
		}
	}

	[self reloadData];	
}

- (void) reloadData {
	[_tableView reloadData];	
}

- (void)drawRect:(CGRect)rect on: (id)context
{
    CGContextSetFillColor(context, [CPColor lightGrayColor]); 
    CGContextFillRect(context, [self bounds]); 
}
@end