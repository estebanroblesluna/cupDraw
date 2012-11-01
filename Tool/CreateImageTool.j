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
@implementation CreateImageTool : AbstractCreateFigureTool
{
	CPCancelableTextField _editableLabel;
	CPPoint _point;	
}

- (void) createFigureAt: (id) aPoint on: (id) aDrawing
{
	_editableLabel = [CPCancelableTextField 
		textFieldWithStringValue: @""
		placeholder: @"Insert url"
		width: 100];

	_point = aPoint;

	[_editableLabel setEditable: YES];
	[_editableLabel setBordered: YES];
	[_editableLabel setFrameOrigin: aPoint];
	[_editableLabel cancelator: self];
	
	[[CPNotificationCenter defaultCenter] 
		addObserver: self 
		selector: @selector(controlTextDidEndEditing:) 
		name: CPControlTextDidEndEditingNotification 
		object: _editableLabel];
		
	[aDrawing addFigure: _editableLabel];
	[[aDrawing window] makeFirstResponder: _editableLabel];
}

- (void) cancelEditing
{
	if (_editableLabel != nil) {
		[[CPNotificationCenter defaultCenter] 
			removeObserver:self
			name: CPControlTextDidEndEditingNotification 
			object: _editableLabel];

		[_editableLabel removeFromSuperview];
		var drawing = [self drawing];
		[[drawing window] makeFirstResponder: drawing];
	}
}

- (void) controlTextDidEndEditing: (CPNotification) notification
{
	var url = [_editableLabel objectValue];
	var image = [ImageFigure initializeWithImage: url x: _point.x y: _point.y offset: 3];
	[[self drawing] addFigure: image];
	[self cancelEditing];
	[self activateSelectionTool];
}
@end