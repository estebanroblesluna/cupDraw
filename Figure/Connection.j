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
@implementation Connection : Polyline 
{ 
	Figure _sourceFigure;
	Figure _targetFigure;
	HandleMagnet _magnet1;
	HandleMagnet _magnet2;
	
	CPPoint _p1Arrow;
	CPPoint _p2Arrow;
} 

+ (Connection) source: (Figure) aSourceFigure target: (Figure) aTargetFigure
{
	return [[self new] initWithSource: aSourceFigure target: aTargetFigure];
}

- (id) initWithSource: (Figure) aSourceFigure target: (Figure) aTargetFigure
{ 
	_sourceFigure = aSourceFigure;
	_targetFigure = aTargetFigure;

	var points = [CPMutableArray array];
	[points addObject: [_sourceFigure center]];
	if (_sourceFigure == _targetFigure) {
		var center = [_sourceFigure center];
		[points addObject: CGPointMake(center.x + 100, center.y)];
		[points addObject: CGPointMake(center.x + 100, center.y - 100)];
		[points addObject: CGPointMake(center.x      , center.y - 100)];
	}
	[points addObject: [_targetFigure center]];
	
	self = [super initWithPoints: points];
	
	if (self) {
		[self recomputeFrame];
		
		_magnet1 = [[HandleMagnet alloc] initWithHandle: [self handleAt: 2] source: _sourceFigure target: _targetFigure];
		_magnet2 = [[HandleMagnet alloc] initWithHandle: [self handleAt: 0] source: _targetFigure target: _sourceFigure];

		[_magnet1 updateHandleLocation: nil];
		[_magnet2 updateHandleLocation: nil];

		[_sourceFigure addOutConnection: self];
		[_targetFigure addInConnection: self];
		return self;
	}
}

- (void) drawRect:(CGRect) rect on: (id) context
{
	[super drawRect: rect on: context];
	
	var point = [_points objectAtIndex: ([_points count] - 1)];
	
	var origin = [self frameOrigin];
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context,    _p1Arrow.x - origin.x, _p1Arrow.y - origin.y);
	CGContextAddLineToPoint(context, _p2Arrow.x - origin.x, _p2Arrow.y - origin.y);
	CGContextAddLineToPoint(context, point.x    - origin.x, point.y    - origin.y);
	CGContextClosePath(context);
	CGContextSetFillColor(context, [self foregroundColor]);
	CGContextFillPath(context);
}

- (void) computeArrowPoints
{
	var antPoint = [_points objectAtIndex: ([_points count] - 2)];
	var point = [_points objectAtIndex: ([_points count] - 1)];
	
	var p1 = nil;
	var p2 = nil;
	
	var xDiff = 5;
	var yDiff = 7;
	
	if (antPoint.x == point.x) {
		//vertical
		if (antPoint.y < point.y) {
			p1 = CPPointMake(point.x - xDiff, point.y - yDiff);
			p2 = CPPointMake(point.x + xDiff, point.y - yDiff);
		} else {
			p1 = CPPointMake(point.x - xDiff, point.y + yDiff);
			p2 = CPPointMake(point.x + xDiff, point.y + yDiff);
		}
	} else {
		if (antPoint.y == point.y) {
			//horizontal
			if (antPoint.x < point.x) {
				p1 = CPPointMake(point.x - yDiff, point.y - xDiff);
				p2 = CPPointMake(point.x - yDiff, point.y + xDiff);
			} else {
				p1 = CPPointMake(point.x + yDiff, point.y - xDiff);
				p2 = CPPointMake(point.x + yDiff, point.y + xDiff);
			}
		} else {
			var lineVector = CPPointMake(point.x - antPoint.x, point.y - antPoint.y);
			var lineLength = SQRT((lineVector.x * lineVector.x) + (lineVector.y * lineVector.y));
			
			var pi = 3.14159265;
			var nWidth = 10;
			var fTheta = pi / 8;
			
			var tPointOnLine = nWidth / (2 * (TAN(fTheta) / 2) * lineLength);
			tPointOnLine = tPointOnLine / 3;
			var pointOnLine = CPPointMake(point.x + -tPointOnLine * lineVector.x, point.y + -tPointOnLine * lineVector.y);

			var normalVector = CPPointMake(-lineVector.y, lineVector.x);
			var tNormal = nWidth / (2 * lineLength);
			var leftPoint = CPPointMake(pointOnLine.x + tNormal * normalVector.x, pointOnLine.y + tNormal * normalVector.y);
			var rightPoint = CPPointMake(pointOnLine.x + -tNormal * normalVector.x, pointOnLine.y + -tNormal * normalVector.y);

			p1 = leftPoint;
			p2 = rightPoint;
		}
	}
	
	_p1Arrow = p1;
	_p2Arrow = p2;
}

- (void) recomputeFrame
{
	[self computeArrowPoints];
	var pointsWithArrow = [CPMutableArray arrayWithArray: _points];
	[pointsWithArrow addObject: _p1Arrow];
	[pointsWithArrow addObject: _p2Arrow];
	var newFrame = [GeometryUtils computeFrameFor: pointsWithArrow];
	[self setFrame: newFrame];
}

@end