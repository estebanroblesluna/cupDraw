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
@implementation DrawingModel : Model
{
}

- (id) init
{
	[super init];
	
	[self addProperty: @"Name" value: @""];
	[self addProperty: @"Show grid?" value: YES];
	[self addProperty: @"Grid size" value: 20];
	[self addProperty: @"Snap to grid?" value: NO];
	[self addProperty: @"Floating toolboxes?" value: YES];
	
	return self;
}
@end
