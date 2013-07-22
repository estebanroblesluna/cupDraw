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
@implementation CPCustomRowTableColumn : CPTableColumn
{
	id _model;
}

- (id) dataViewForRow: (int) aRowIndex
{
	if (aRowIndex < 0 || _model == nil) {
		return  [self dataView];
	} else {
		var propertyType = [_model propertyTypeAt: aRowIndex];
		if ([propertyType isEqual: PropertyTypeBoolean]) {
			var editableView = [CPCheckBox checkBoxWithTitle:@""];
        	[editableView sizeToFit];
        	return editableView;		
		} else if ([propertyType isEqual: PropertyTypeInteger]) {
			return  [self dataView];
		} else if ([propertyType isEqual: PropertyTypeFloat]) {
			return  [self dataView];
		} else if ([propertyType isEqual: PropertyTypeString]) {
			return  [self dataView];
		} else {
			return  [self dataView];
		}
	}
}


- (void) model: (id) aModel
{
	_model = aModel;
}
@end
