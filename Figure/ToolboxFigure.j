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
@implementation ToolboxFigure : Figure 
{
	Drawing _drawing;
	CPDictionary _buttonsMapping;
	int _currentColumn;
	int _maxColumn;
	int _currentY;
}

+ (ToolboxFigure) initializeWith: (Drawing) aDrawing at: (CPPoint) aPoint
{
	var figure = [[self new] initializeWith: aDrawing at: aPoint];
	return figure;
}

- (id) initializeWith: (Drawing) aDrawing at: (CPPoint) aPoint
{
	var frame = CGRectMake(aPoint.x, aPoint.y, 50, 1);
	self = [super initWithFrame: frame];
	if (self) {
		_drawing = aDrawing;
		_currentColumn = 1;
		_maxColumn = 2;
		_currentY = 15;
		_selectable = true;
		_moveable = true;
		_buttonsMapping = [CPDictionary dictionary];
		return self;
	}
}

- (void) columns: (int) columns
{
	_maxColumn = columns;
}

- (void) addSeparator
{
	_currentY = _currentY + 25;
	_currentColumn = 1;
}

- (void) addTool: (Tool) aTool withTitle: (id) aTitle image: (id) url
{
	var button = [self 
		addButtonWithTitle: aTitle 
		image: url
		action: @selector(selectTool:)];
	[_buttonsMapping setObject: aTool forKey: button];
}

- (void) selectTool: (CPButton) aButton
{
	var tool = [_buttonsMapping objectForKey: aButton];
	[_drawing tool: tool];
}

- (void) addCommand: (Command) aCommand withTitle: (id) aTitle image: (id) url
{
	var button = [self 
		addButtonWithTitle: aTitle 
		image: url 
		action: @selector(selectCommand:)];
	[_buttonsMapping setObject: aCommand forKey: button];
}

- (void) selectCommand: (CPButton) aButton
{
	var commandClass = [_buttonsMapping objectForKey: aButton];
	var command = [commandClass drawing: _drawing];
	[command execute];
}

- (CPButton) addButtonWithTitle: (id) aTitle image: (id) url action: (SEL) aSelector
{
	var buttonWidth = 30;
	var buttonHeight = 25;
	var button = [CPButton buttonWithTitle: @""];

	var y = _currentY;
	var x = (_currentColumn - 1) * buttonWidth;
	var origin = CGPointMake(x, y);
	[button setFrameOrigin: origin];

	var icon = [[CPImage alloc]
	            initWithContentsOfFile: url];
	[button setImage: icon];
	[button setButtonType: CPOnOffButton];
	[button setBordered: YES];
	[button setBezelStyle: CPRegularSquareBezelStyle];
	[button setFrameSize: CGSizeMake(buttonWidth, buttonHeight)];
	[button setTarget: self];
	[button setAction: aSelector];

	[self addSubview: button];

	var newSize = CGSizeMake(buttonWidth * _maxColumn, _currentY + buttonHeight);
	[self setFrameSize: newSize];

	if (_currentColumn == _maxColumn) {
		_currentY = _currentY + buttonHeight;
	}
	
	_currentColumn = _currentColumn + 1;
	if (_currentColumn > _maxColumn) {
		_currentColumn = 1;
	}
	return button;
}

- (void) drawRect:(CGRect)rect on: (id)context
{
    CGContextSetFillColor(context, [CPColor lightGrayColor]); 
    CGContextFillRect(context, [self bounds]); 
}

- (void) sizeToFit
{
	var frame = [GeometryUtils computeFrameForViews: [self subviews]];
	frame.origin.y = frame.origin.y - 15;
	frame.size.height = frame.size.height + 15;
	[self setFrame: frame];
}
@end