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
@implementation SelectedState : ToolState
{
	CPPoint _initialDragPoint;
}

+ (id) tool: (StateMachineTool) aTool initialDragPoint: (CPPoint) anInitialDragPoint
{
	var state = [self tool: aTool];
	[state initWithInitialDragPoint: anInitialDragPoint];
	return state;
}

- (id) initWithInitialDragPoint: (CPPoint) anInitialDragPoint
{
	_initialDragPoint = anInitialDragPoint;
	return self;
}

- (void) mouseDown: (CPEvent) anEvent	 
{
	var point = [anEvent locationInWindow];
	var drawing = [_tool drawing];
	var figureUnderPoint = [drawing figureAt: point];
	figureUnderPoint = [_tool selectableFigure: figureUnderPoint];
	_initialDragPoint = point;

	if (figureUnderPoint == nil || figureUnderPoint == drawing) {
		[_tool clearSelection];
		[self transitionToInitialState];
	} else {
		if (![figureUnderPoint isHandle]) {
			var selectedFigures = [_tool selectedFigures];
			var wasSelected = [selectedFigures containsObject: figureUnderPoint];
			var notAddOperation = ([anEvent modifierFlags] & (CPControlKeyMask | CPCommandKeyMask)) == 0;
			
			if (!wasSelected && notAddOperation) {
				[_tool clearSelection];
			}
		}
		[_tool select: figureUnderPoint];
		[_tool updateInitialPoints];
	}
}

- (void) mouseDragged:(CPEvent) anEvent
{
	var point = [anEvent locationInWindow];
	var figureUnderPoint = [[_tool drawing] figureAt: point];
	
	if ([figureUnderPoint isHandle]) {
		[self transitionTo: [MoveHandleState tool: _tool initialDragPoint: _initialDragPoint handle: figureUnderPoint]];
	} else {
		[self transitionTo: [MoveFiguresState tool: _tool initialDragPoint: _initialDragPoint]];
	}
}

- (void) mouseUp:(CPEvent) anEvent
{
	//stay here as we are selecting figures
}
@end