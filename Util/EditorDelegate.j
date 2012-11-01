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
@implementation EditorDelegate : CPObject
{
	CPTextField _editableLabel;
	Figure _editableFigure;
	Drawing _drawing;
	id _window;
}

- (id) initWithWidget: (Figure) aFigure label: (CPTextField) aLabel window: (id) aWindow figureContainer: (Figure) aContainer drawing: (Drawing) aDrawing
{ 
	self = [super init];
	if (self) {
		var width = [aLabel frameSize].width + (6 * 2);
		var currentValue = [aLabel objectValue];

		var position = [aDrawing 
			convertPoint: CPPointMake(-5, -5)
			fromView: aFigure];

		var editableLabel = [CPCancelableTextField 
			textFieldWithStringValue: currentValue
			placeholder: @""
			width: width];

		[editableLabel setEditable: YES];
		[editableLabel setBordered: NO];
		[editableLabel sizeToFit];
		[editableLabel setFrameOrigin: position];
		[editableLabel cancelator: self];
		
		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(controlTextDidBlur:) 
			name: CPTextFieldDidBlurNotification 
			object: editableLabel];

		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(controlTextDidEndEditing:) 
			name: CPControlTextDidEndEditingNotification 
			object: editableLabel];

		[[aWindow contentView] addSubview: editableLabel];
		[aWindow makeFirstResponder: editableLabel];

		_editableLabel = editableLabel;
		_editableFigure = aContainer;
		_drawing = aDrawing;
		_window = aWindow;
		
		return self;
	}
}

- (void) controlTextDidChange: (CPNotification) notification
{
	var keyValue = [[notification userInfo] objectForKey: @"CPFieldEditor"];
	CPLog.debug(keyValue);
}

- (void) controlTextDidEndEditing: (CPNotification) notification
{
	[_editableFigure setEditionResult: [_editableLabel objectValue]];
	[self cleanUp];
}

- (void) controlTextDidBlur: (CPNotification) notification
{
	[self controlTextDidEndEditing: notification];
}

- (void) cancelEditing
{
	[self cleanUp];
}

- (void) cleanUp
{
	[[CPNotificationCenter defaultCenter] 
		removeObserver:self
		name: CPControlTextDidEndEditingNotification 
		object: _editableLabel];
		
	[[CPNotificationCenter defaultCenter] 
		removeObserver:self
		name: CPTextFieldDidBlurNotification 
		object: _editableLabel];
		
	[_editableLabel removeFromSuperview];
	[_window makeFirstResponder: _drawing];
}

@end
