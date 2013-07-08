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

DrawingSelectionChangedNotification = @"DrawingSelectionChangedNotification";

/**
 * @author "Esteban Robles Luna <esteban.roblesluna@gmail.com>"
 */
@implementation Drawing : CompositeFigure 
{
	Tool _currentTool;
	id _selectedFigure;
	Figure _backgroundLayer;
	ToolboxFigure _toolbox;
	PropertiesFigure _properties;
} 

- (id) init
{
	[super init];

	_currentTool = [SelectionTool drawing: self];
	_selectedFigure = nil;
	_selectable = false;
	_moveable = false;
	_editable = false;
	[self model: [DrawingModel new]];
	
	return self;
}

- (id) initWithFrame: (CGRect) aFrame
{
	[super initWithFrame: aFrame];
	_backgroundLayer = [CompositeFigure frame: aFrame];
	[_backgroundLayer selectable: NO];
	[_backgroundLayer moveable: NO];
	[_backgroundLayer setAutoresizingMask: CPViewHeightSizable | CPViewWidthSizable];
	[self addFigure: _backgroundLayer];
	[self computeBackgroundLayer];
	return self;
}

- (void) toolbox: (ToolboxFigure) aToolbox
{
	_toolbox = aToolbox;
	[self addFigure: _toolbox];
}

- (void) properties: (PropertiesFigure) aProperties
{
	_properties = aProperties;
	[self addFigure: _properties];
}

- (void) computeBackgroundLayer
{
	[_backgroundLayer clearFigures];
	
	if ([self showGrid]) {
		var frame = CGRectMake(0, 0, 1600, 1600);
		var grid = [Grid frame: frame showGrid: [self showGrid] gridSize: [self gridSize]];
		[_backgroundLayer addFigure: grid];
	}
}

- (void) select
{
	[super select];
	[[self window] makeFirstResponder: self];
}

- (Drawing) drawing
{ 
	return self;
}

- (bool) showGrid
{
	return [[[self model] propertyValue: @"Show grid?"] boolValue];
}

- (bool) snapToGrid
{
	return [[[self model] propertyValue: @"Snap to grid?"] boolValue];
}

- (bool) floatingToolboxes
{
	return [[[self model] propertyValue: @"Floating toolboxes?"] boolValue];
}

- (int) gridSize
{
	return [[[self model] propertyValue: @"Grid size"] intValue];
}

- (void) mouseDown:(CPEvent) anEvent	 
{
	[_currentTool mouseDown: anEvent];
}

- (void) mouseDragged:(CPEvent) anEvent
{
	[_currentTool mouseDragged: anEvent];
}

- (void) mouseUp:(CPEvent) anEvent
{
	[_currentTool mouseUp: anEvent];
}

- (BOOL) acceptsFirstResponder 
{
    return YES;
}

- (void) keyUp: (CPEvent) anEvent
{
	//CPLog.debug(anEvent);
	[_currentTool keyUp: anEvent];
}

- (void) keyDown: (CPEvent) anEvent
{
	//CPLog.debug(anEvent);
	[_currentTool keyDown: anEvent];
}

- (void) unselectAll
{
	var subviews = [self subviews];
	for (var i = [subviews count] -1; i >= 0 ; i--) { 
	    var figure = [subviews objectAtIndex:i];
		[figure unselect];
	}
}

- (Tool) tool
{
	return _currentTool;
}

- (void) tool: (Tool) aTool
{
	[_currentTool release];
	_currentTool = aTool;
	[_currentTool activate];
}

- (id) selectedFigure
{
	return _selectedFigure;
}

- (void) selectedFigure: (id) aFigure
{
	_selectedFigure = aFigure;
	[[CPNotificationCenter defaultCenter] 
		postNotificationName: DrawingSelectionChangedNotification 
		object: self];
}

- (void) modelChanged
{
	[self computeBackgroundLayer];
	
	var floatingToolboxes = [self floatingToolboxes];
	var drawingFrame = [self frame];

	if (_toolbox != nil) {
		[_toolbox selectable: floatingToolboxes];
		[_toolbox moveable: floatingToolboxes];

		if (!floatingToolboxes) {
			var frame = [_toolbox frame];
			var newFrame = CGRectMake(0, 0, frame.size.width, drawingFrame.size.height);
			[_toolbox setFrame: newFrame];
			[_toolbox setAutoresizingMask: CPViewHeightSizable];
		} else {
			[_toolbox sizeToFit];
		}
	}

	if (_properties != nil) {
		[_properties selectable: floatingToolboxes];
		[_properties moveable: floatingToolboxes];
		
		if (!floatingToolboxes) {
			var leftOffset;
			if (_toolbox != nil) {
				leftOffset = [_toolbox frame].size.width;
			} else {
				leftOffset = 0;
			}
			
			var frame = [_properties frame];
			var newFrame = CGRectMake(leftOffset, drawingFrame.size.height - frame.size.height, drawingFrame.size.width, frame.size.height);
			[_properties setFrame: newFrame];
			[_properties setAutoresizingMask: CPViewMinYMargin | CPViewWidthSizable];
		} else {
			[_properties setFrame: [PropertiesFigure defaultFrame]];
		}
	}
}
@end