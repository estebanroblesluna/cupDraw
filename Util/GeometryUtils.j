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
@implementation GeometryUtils : CPObject
{
}

+ (CGRect) computeFrameFor: (CPArray) points
{
	var firstPoint = [points objectAtIndex: 0];

	var minX = firstPoint.x;
	var maxX = minX;
	var minY = firstPoint.y;
	var maxY = minY;
	
	for (var i = 1; i < [points count]; i++) { 
	    var point = [points objectAtIndex:i];
	
		minX = MIN(minX, point.x);
		maxX = MAX(maxX, point.x);
		minY = MIN(minY, point.y);
		maxY = MAX(maxY, point.y);
	}
	
	var width = ABS(maxX - minX);
	var height = ABS(maxY - minY);
	
	width = MAX(width, 1);
	height = MAX(height, 1);
	
	return CGRectMake(minX, minY, width, height);
}

+ (CGRect) computeFrameForViews: (CPArray) views
{
	var firstPoint = [[views objectAtIndex: 0] frame].origin;

	var minX = firstPoint.x;
	var maxX = minX;
	var minY = firstPoint.y;
	var maxY = minY;
	
	for (var i = 1; i < [views count]; i++) { 
	    var point = [[views objectAtIndex: i] frame].origin;
	
		minX = MIN(minX, point.x);
		maxX = MAX(maxX, point.x);
		minY = MIN(minY, point.y);
		maxY = MAX(maxY, point.y);

		var size = [[views objectAtIndex: i] frame].size;
	    var point2 = CGPointMake(point.x + size.width, point.y + size.height);
	
		minX = MIN(minX, point2.x);
		maxX = MAX(maxX, point2.x);
		minY = MIN(minY, point2.y);
		maxY = MAX(maxY, point2.y);
	}
	
	var width = ABS(maxX - minX);
	var height = ABS(maxY - minY);
	
	width = MAX(width, 1);
	height = MAX(height, 1);
	
	return CGRectMake(minX, minY, width, height);
}

+ (CGPoint) intersectionOf: (CGPoint) p1 with: (CGPoint) p2 with: (CGPoint) p3 with: (CGPoint) p4
{
	var Ax = p1.x;
	var Ay = p1.y;
	var Bx = p2.x;
	var By = p2.y;
	var Cx = p3.x;
	var Cy = p3.y;
	var Dx = p4.x;
	var Dy = p4.y;

	/*CPLog.debug(Ax);
	CPLog.debug(Ay);
	CPLog.debug(Bx);
	CPLog.debug(By);
	CPLog.debug(Cx);
	CPLog.debug(Cy);
	CPLog.debug(Dx);
	CPLog.debug(Dy);*/

	var distAB, theCos, theSin, newX, ABpos;
	
	//  Fail if either line segment is zero-length.
	if (Ax==Bx && Ay==By || Cx==Dx && Cy==Dy) return nil;

	//  Fail if the segments share an end-point.
	if (Ax==Cx && Ay==Cy || Bx==Cx && By==Cy
	  ||  Ax==Dx && Ay==Dy || Bx==Dx && By==Dy) {
	    return nil; 
	}

	//  (1) Translate the system so that point A is on the origin.
	Bx-=Ax; By-=Ay;
	Cx-=Ax; Cy-=Ay;
	Dx-=Ax; Dy-=Ay;

	//  Discover the length of segment A-B.
	distAB= [CPPredicateUtilities sqrt: (Bx*Bx+By*By)];

	//  (2) Rotate the system so that point B is on the positive X axis.
	theCos=Bx/distAB;
	theSin=By/distAB;
	newX=Cx*theCos+Cy*theSin;
	Cy  =Cy*theCos-Cx*theSin; Cx=newX;
	newX=Dx*theCos+Dy*theSin;
	Dy  =Dy*theCos-Dx*theSin; Dx=newX;

	//  Fail if segment C-D doesn't cross line A-B.
	if (Cy<0. && Dy<0. || Cy>=0. && Dy>=0.) return nil;

	//  (3) Discover the position of the intersection point along line A-B.
	ABpos=Dx+(Cx-Dx)*Dy/(Dy-Cy);

	//  Fail if segment C-D crosses line A-B outside of segment A-B.
	if (ABpos<0. || ABpos>distAB) return nil;

	var point = CGPointMake(ROUND(Ax+ABpos*theCos), ROUND(Ay+ABpos*theSin));
	return point;
}

+ (CGPoint) distanceFrom: (CGPoint) p1 to: (CGPoint) p2
{
	var xOff = (p1.x - p2.x);
	var yOff = (p1.y - p2.y);
	return [CPPredicateUtilities sqrt: (xOff * xOff + yOff * yOff)]
}

+ (id) distanceFrom: (CGPoint) a and: (CGPoint) b to: (CGPoint) p
{
	// if start==end, then use pt distance
	if (a == b) {
		return [self distanceFrom: a to: p];
	}

	    // otherwise use comp.graphics.algorithms Frequently asked Questions method
	    /*(1)     	      aC dot ab
	                   r = ---------
	                         ||ab||^2
			r has the following meaning:
			r=0 P = a
			r=1 P = b
			r<0 P is on the backward extension of ab
			r>1 P is on the forward extension of ab
			0<r<1 P is interior to ab
		*/

	var r = ( (p.x - a.x) * (b.x - a.x) + (p.y - a.y) * (b.y - a.y) ) / ( (b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y) );
	if (r <= 0.0) {
		return [self distanceFrom: a to: p];
	}
	
	if (r >= 1.0) {
		return [self distanceFrom: b to: p];
	}


	    /*(2)
			     (ay-Cy)(bx-ax)-(ax-Cx)(by-ay)
			s = -----------------------------
			             	L^2

			Then the distance from C to P = |s|*L.
		*/

	var s = ((a.y - p.y) *(b.x - a.x) - (a.x - p.x)*(b.y - a.y) ) / ((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y) );

	return ABS(s) * SQRT(((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y)));
}
@end
