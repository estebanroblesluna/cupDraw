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
@implementation AbstractCreateConnectionTool : Tool
{
	Connection _connection;
	Figure _initialFigure;
	id _figureClass;
	
	id _validStartingConnection;
}

+ (id) drawing: (Drawing) aDrawing
{
	return [self drawing: aDrawing figure: [Connection class]];
}

+ (id) drawing: (Drawing) aDrawing figure: (id) aFigureClass
{
	var tool = [super drawing: aDrawing];
	[tool figureClass: aFigureClass];
	return tool;
}

- (void) figureClass: (id) aFigureClass
{
	_figureClass = aFigureClass;
}

- (void) mouseDown: (CPEvent) anEvent
{
	var point = [anEvent locationInWindow];
	var figure = [_drawing figureAt: point];

	var figureAcceptsNewConnection = [self acceptsNewStartingConnection: figure];
	_validStartingConnection = figureAcceptsNewConnection;
	
	var points = [CPMutableArray array];
	[points addObject: [figure center]];
	[points addObject: [figure center]];

	var connection = [[Connection alloc] initWithPoints: points];
	[connection recomputeFrame];
	[_drawing addFigure: connection];

	_connection = connection;
	_initialFigure = figure;
	
	if (!_validStartingConnection) {
		[_connection foregroundColor: [CPColor colorWithHexString: @"CC0000"]];
		[_connection lineWidth: 2];
	}
}

- (void) mouseDragged:(CPEvent) anEvent
{
	if (_connection != nil) {
		var point = [anEvent locationInWindow];
		point = CGPointMake(point.x - 6, point.y - 6);
		[_connection pointAt: 1 put: point];
	}
}

- (void) mouseUp:(CPEvent) anEvent
{
	CPLog.debug("[CreateConnectionTool] Mouse up");

	if (_validStartingConnection) {
		var point = [anEvent locationInWindow];
		var figure = [_drawing figureAt: point];

		CPLog.debug("[CreateConnectionTool] Mouse up figure: " + figure);

		var acceptsNewEndingConnection = [self acceptsNewEndingConnection: figure];

		if (acceptsNewEndingConnection) {
			[self createFigureFrom: _initialFigure target: figure points: nil];
		} else {
			[_connection foregroundColor: [CPColor colorWithHexString: @"CC0000"]];
			[_connection lineWidth: 2];
			[_connection invalidate];
		}
	} else {
		CPLog.debug("[CreateConnectionTool] Connection is nil");
	}

			
	if (_connection != nil && ([_connection superview] != nil)) {
		[_connection removeFromSuperview];
	}
	_connection = nil;
	_initialFigure = nil;
	[self activateSelectionTool];
}

- (void) createFigureFrom: (id) source target: (id) target points: (id) points
{
	var connectionFigure = [_figureClass source: source target: target points: points];
	[_drawing addFigure: connectionFigure];
	[self postConnectionCreated: connectionFigure];
}

- (void) postConnectionCreated: (Connection) aConnectionFigure
{
}

@end