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
	id _currentTextFieldEdition;
	id _currentRowIndex;
	id _checkboxMapping;
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
		_checkboxMapping = [CPDictionary dictionary];
		
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

		_valueColumn = [[CPCustomRowTableColumn alloc] initWithIdentifier:@"valueColumn"];
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
	[self cleanUpCurrentTextFieldEdition];
	
	var columnIndex = 1;
	var rowIndex = [_tableView selectedRow];

	var identifier = [_valueColumn UID],
            textField = _tableView._dataViewsForTableColumns[identifier][rowIndex];
            
    [textField setEditable:YES];
	[[self window] makeFirstResponder: textField];
	
	[[CPNotificationCenter defaultCenter] 
		addObserver: self 
		selector: @selector(controlTextDidBlur:) 
		name: CPTextFieldDidBlurNotification 
		object: textField];

	[[CPNotificationCenter defaultCenter] 
		addObserver: self 
		selector: @selector(controlTextDidEndEditing:) 
		name: CPControlTextDidEndEditingNotification 
		object: textField];
			
	_currentTextFieldEdition = textField;
	_currentRowIndex = rowIndex;
}

- (void) controlTextDidEndEditing: (CPNotification) notification
{
	var value = [_currentTextFieldEdition objectValue];
	var model = [_selectedFigure model];

	[model propertyValueAt: _currentRowIndex be: value];
	[self cleanUpCurrentTextFieldEdition];
	[[self window] makeFirstResponder: [self drawing]];
}

- (void) controlTextDidBlur: (CPNotification) notification
{
	[self controlTextDidEndEditing: notification];
}

- (void) cleanUpCurrentTextFieldEdition
{
	if (_currentTextFieldEdition != nil) {
		[[CPNotificationCenter defaultCenter] 
			removeObserver:self
			name: CPControlTextDidEndEditingNotification 
			object: _currentTextFieldEdition];
			
		[[CPNotificationCenter defaultCenter] 
			removeObserver:self
			name: CPTextFieldDidBlurNotification 
			object: _currentTextFieldEdition];
			
	    [_currentTextFieldEdition setSelectable: NO];
	    [_currentTextFieldEdition setEditable: NO];
	}
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

- (void) tableView: (CPTableView) aTableView setObjectValue: (id) aValue forTableColumn: (CPTableColumn) aTableColumn row: (int) rowIndex 
{
	var model = [_selectedFigure model];
	if (aTableColumn == _valueColumn) {
		return [model propertyValueAt: rowIndex be: aValue];
	}
}

- (id) tableView: (CPTableView) aTableView dataViewForTableColumn: (CPTableColumn) aTableColumn row: (CPInteger) aRowIndex
{
	var _model = [_selectedFigure model];
	var tableColumnId = [aTableColumn identifier];
	var propertyName = [_model propertyDisplayNameAt: aRowIndex];
	var viewKind = "view_kind_" + _model + "_" + propertyName + "_" + tableColumnId;
	var view = [aTableView makeViewWithIdentifier: viewKind owner: self];

	if (view == null) {
		if (aRowIndex < 0 || _model == nil) {
			view = [[CPTableCellView alloc] initWithFrame:CGRectMakeZero()];
		} else {
			if (aTableColumn == _valueColumn) {
				var propertyType = [_model propertyTypeAt: aRowIndex];
				if ([propertyType isEqual: PropertyTypeBoolean]) {
					var editableView = [CPCheckBox checkBoxWithTitle:@""];
		        	[editableView sizeToFit];
		        	[editableView setTarget: self];
		        	[editableView setSendsActionOnEndEditing: YES];
		        	[editableView setAction: @selector(toggleCheckbox:)];
		        	[_checkboxMapping setObject: aRowIndex forKey: editableView];
		        	
		        	view = editableView;		
				} else {
					view = [aTableColumn _newDataView];
				}
			} else {
				view = [aTableColumn _newDataView];
			}
		}
		
		[view setIdentifier: viewKind];
	}
	
	var value = @"Undefined"
	if (aTableColumn == _valueColumn) {
		value = [_model propertyValueAt: aRowIndex];
	} else {
		value = [_model propertyDisplayNameAt: aRowIndex];
	}
	
	[view setObjectValue: value];
	
	return view;
}

- (void) toggleCheckbox: (id) aSender
{
	var rowIndex = [_checkboxMapping objectForKey: aSender];
	var model = [_selectedFigure model];
	var value = [aSender objectValue];

	[model propertyValueAt: rowIndex be: value];
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
			[_valueColumn model: model];
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