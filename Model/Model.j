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

ModelPropertyChangedNotification = @"ModelPropertyChangedNotification";

/**
 * @author "Esteban Robles Luna <esteban.roblesluna@gmail.com>"
 */
@implementation Model : CPObject
{
	CPMutableArray _properties;
	CPDictionary _propertiesByName;
	boolean _fireNotifications;
}

- (id) init
{
	_properties = [CPMutableArray array];
	_propertiesByName = [CPDictionary dictionary];
	_fireNotifications = YES;
	return self;
}

- (void) addProperty: (id) aPropertyName
{
	CPLog.info(aPropertyName);
	[self addProperty: aPropertyName value: nil];
}

- (void) addProperty: (id) aPropertyName value: (id) aValue
{
	[self addProperty: aPropertyName value: aValue editable: YES];
}

- (void) addProperty: (id) aPropertyName value: (id) aValue editable: (boolean) anEditableValue
{
	var property = [Property name: aPropertyName value: aValue];
	[property editable: anEditableValue];
	[_properties addObject: property];
	[_propertiesByName setObject: property forKey: aPropertyName];
}

- (id) propertiesSize
{
	return [_properties count];
}

- (id) propertyNameAt: (id) anIndex
{
	var property = [_properties objectAtIndex: anIndex];
	return [property name];
}

- (id) propertyValueAt: (id) anIndex
{
	var property = [_properties objectAtIndex: anIndex];
	return [property value];	
}

- (id) propertyValue: (id) aName
{
	var property = [_propertiesByName objectForKey: aName];
	return [property value];	
}

- (void) propertyValue: (id) aName be: (id) aValue
{
	var property = [_propertiesByName objectForKey: aName];
	[property value: aValue];
	//CPLog.info([property name]);
	//CPLog.info(aValue);
	if (_fireNotifications) {
		[self changed];
	}
}

- (void) propertyValueAt: (id) anIndex be: (id) aValue
{
	var property = [_properties objectAtIndex: anIndex];
	[property value: aValue];
	//CPLog.info([property name]);
	//CPLog.info(aValue);
	if (_fireNotifications) {
		[self changed];
	}
}

- (void) changed
{
	[[CPNotificationCenter defaultCenter] 
		postNotificationName: ModelPropertyChangedNotification 
		object: self];
}

- (void) fireNotifications: (bool) aValue
{
	_fireNotifications = aValue;
}
@end
