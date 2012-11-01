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
@implementation HandleMagnet : CPObject
{
	Handle _handle;
	Figure _sourceFigure;
	Figure _targetFigure;
}

- (id) initWithHandle: (Handle) aHandle source: aSourceFigure target: aTargetFigure 
{ 
	self = [super init];
	if (self) {
		_handle = aHandle;
		_sourceFigure = aSourceFigure;
		_targetFigure = aTargetFigure;

		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(updateHandleLocation:) 
			name: @"CPViewFrameDidChangeNotification" 
			object: _targetFigure];

		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(updateHandleLocation:) 
			name: @"CPViewFrameDidChangeNotification" 
			object: _handle];

		[[CPNotificationCenter defaultCenter] 
			addObserver: self 
			selector: @selector(updateHandleLocation:) 
			name: @"CPViewFrameDidChangeNotification" 
			object: [_handle targetFigure]];

		return self;
	}
}

- (void) updateHandleLocation: aNotification
{
	var sourceCenter = [_sourceFigure center];

	var p1 = [GeometryUtils 
				intersectionOf: [_targetFigure topLeft] 
				with: [_targetFigure topRight]  
				with: [_targetFigure center] 
				with: sourceCenter];
	
	var p2 = [GeometryUtils 
				intersectionOf: [_targetFigure topRight] 
				with: [_targetFigure bottomRight]  
				with: [_targetFigure center] 
				with: sourceCenter];
							
	var p3 = [GeometryUtils 
				intersectionOf: [_targetFigure bottomRight] 
				with: [_targetFigure bottomLeft]  
				with: [_targetFigure center] 
				with: sourceCenter];
										
	var p4 = [GeometryUtils 
				intersectionOf: [_targetFigure bottomLeft] 
				with: [_targetFigure topLeft]  
				with: [_targetFigure center] 
				with: sourceCenter];

	/*CPLog.debug(sourceCenter.x);
	CPLog.debug(sourceCenter.y);
	CPLog.debug(p1.x);
	CPLog.debug(p1.y);
	CPLog.debug(p2.x);
	CPLog.debug(p2.y);
	CPLog.debug(p3.x);
	CPLog.debug(p3.y);
	CPLog.debug(p4.x);
	CPLog.debug(p4.y);*/
				
	var selected = p1;
	
	if (selected == nil || (p2 != nil && ([GeometryUtils distanceFrom: p2 to: [_handle center]] < [GeometryUtils distanceFrom: selected to: [_handle center]]))) {
		selected = p2;
	}
	if (selected == nil || (p3 != nil && ([GeometryUtils distanceFrom: p3 to: [_handle center]] < [GeometryUtils distanceFrom: selected to: [_handle center]]))) {
		selected = p3;
	}
	if (selected == nil || (p4 != nil && ([GeometryUtils distanceFrom: p4 to: [_handle center]] < [GeometryUtils distanceFrom: selected to: [_handle center]]))) {
		selected = p4;
	}
	
	if (selected != nil) {
		[_handle setFrameOrigin: selected];
		//CPLog.debug(selected.x);
		//CPLog.debug(selected.y);
	} else {
		//CPLog.debug(@"Selected is null");
	}
}
@end
