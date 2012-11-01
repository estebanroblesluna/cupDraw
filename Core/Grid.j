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
@implementation Grid : Figure 
{
	bool _showGrid;
	int _gridSize;
	CPColor _gridColor;
} 

+ (Grid) frame: (CGRect) aFrame showGrid: (bool) aShowGrid gridSize: (int) aGridSize
{
	var grid = [[self alloc] initWithFrame: aFrame showGrid: aShowGrid gridSize: aGridSize];
	return grid;
}

- (id) initWithFrame: (CGRect) aFrame showGrid: (bool) aShowGrid gridSize: (int) aGridSize
{
	[super initWithFrame: aFrame];
	_showGrid = aShowGrid;
	_gridSize = aGridSize;
	_gridColor = [CPColor colorWithHexString: @"F7F0F3"];
	return self;
}

- (void) drawRect: (CGRect) rect on: (id)context
{
	CGContextSetFillColor(context, [CPColor colorWithHexString: @"FEFEFE"]);
	CGContextFillRect(context, rect);
	
	
	if (_showGrid) {
		CGContextSetLineWidth(context, 0.25);
		for (var p = 0; p <= rect.size.width ; p = p + _gridSize) {
			[self drawGridLineX: p y: 0 x: p y: rect.size.height context: context];
		} 
		for (var p = 0; p <= rect.size.height ; p = p + _gridSize) {
			[self drawGridLineX: 0 y: p x: rect.size.width y: p context: context];
		} 
	}
}

- (void) drawGridLineX: (int) x1 y: (int) y1 x: (int) x2 y: (int) y2 context: context
{
	CGContextMoveToPoint(context, x1, y1);
	CGContextAddLineToPoint(context, x2, y2);
	CGContextSetStrokeColor(context, _gridColor);
    CGContextStrokePath(context);
}
@end