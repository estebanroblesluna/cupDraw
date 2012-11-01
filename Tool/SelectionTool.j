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
@implementation SelectionTool : StateMachineTool
{
	CPMutableArray _selectedFigures;
	CPDictionary _initialPositions;
	CGPoint _initialDragPoint;
}

- (id) init
{ 
	[super init];

	_selectedFigures = [CPMutableArray array];
	_initialPositions = [CPDictionary dictionary];
	//[self setState: [SelectionToolInitialState tool: self]];

	return self;
}

- (id) initialState
{
	return [SelectionToolInitialState tool: self];
}

- (CPMutableArray) selectedFigures
{
	return _selectedFigures;
}

- (void) select: (Figure) aFigure
{
	if (![_selectedFigures containsObjectIdenticalTo: aFigure]) {
		[_selectedFigures addObject: aFigure];
		[aFigure select];
		[_drawing selectedFigure: aFigure];
		[_initialPositions setObject: [aFigure frameOrigin] forKey: aFigure];
	}
}

- (void) unselect: (Figure) aFigure
{
	[_selectedFigures removeObject: aFigure];
	[aFigure unselect];
	[_drawing selectedFigure: nil];
	[_initialPositions removeObjectForKey: aFigure];
}

- (CPPoint) initialPositionOf: (Figure) aFigure
{
	return [_initialPositions objectForKey: aFigure];
}

- (void) updateInitialPoints
{
	for (var i = 0; i < [_selectedFigures count]; i++) { 
	    var selectedFigure = [_selectedFigures objectAtIndex:i];
		[_initialPositions setObject: [selectedFigure frameOrigin] forKey: selectedFigure];
	}
}

- (void) clearSelection
{
	for (var i = 0; i < [_selectedFigures count]; i++) { 
	    var selectedFigure = [_selectedFigures objectAtIndex:i];
		[selectedFigure unselect];
	}
	[_selectedFigures removeAllObjects];
	[_initialPositions removeAllObjects];
	[_drawing selectedFigure: nil];
}

- (void) release
{
	[self clearSelection];
}

- (Figure) selectableFigure: (Figure) aFigure
{
	while (aFigure != _drawing && ![aFigure isSelectable]) {
		aFigure = [aFigure superview];
	}
	
	return aFigure;
}

- (void) keyDown: (CPEvent) anEvent
{
}

- (void) keyUp: (CPEvent) anEvent
{
	//CPLog.debug("Selection tool");
	//CPLog.debug([_selectedFigures count]);
	
	if (([anEvent keyCode] == CPKeyCodes.F2) && ([_selectedFigures count] == 1)) {
		var currentFigure = [_selectedFigures objectAtIndex: 0];
		if ([currentFigure isEditable]) {
			[currentFigure switchToEditMode];
		}
	}
	
	if ([anEvent keyCode] == CPKeyCodes.DELETE || [anEvent keyCode] == CPKeyCodes.BACKSPACE) {
		for (var i = 0; i < [_selectedFigures count]; i++) { 
		    var selectedFigure = [_selectedFigures objectAtIndex:i];
			[selectedFigure removeFromSuperview];
		}
		
		[self clearSelection];
	}
}
@end
