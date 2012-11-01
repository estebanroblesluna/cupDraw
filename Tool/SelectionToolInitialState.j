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
@implementation SelectionToolInitialState : ToolState
{
}

+ (id) tool: (StateMachineTool) aTool
{
	return [[self new] initWithTool: aTool];
}

- (id) initWithTool: (StateMachineTool) aTool
{ 
	[super initWithTool: aTool];
	return self;
}

- (void) mouseDown: (CPEvent) anEvent	 
{
	var point = [anEvent locationInWindow];
	var figureUnderPoint = [[_tool drawing] figureAt: point];
	figureUnderPoint = [_tool selectableFigure: figureUnderPoint];

	if (figureUnderPoint != nil && (figureUnderPoint != [_tool drawing])) {
		[_tool select: figureUnderPoint];
		[self transitionTo: [SelectedState tool: _tool initialDragPoint: point]];
	} else {
		[_tool clearSelection];
		[self transitionTo: [MarqueeSelectionState tool: _tool initialDragPoint: point]];
	}
}
@end
