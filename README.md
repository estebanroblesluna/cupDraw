# Cupdraw 0.1 #

Cupdraw is a Objective-J framework for creating graphical editors that is based on the concepts of the famous Smalltalk Hotdraw.
So far, this version contains the main concepts of that Hotdraw with a few utility classes that can help you build a basic editor.

In the following subsections we will talk about each of the concepts involved in Cupdraw.

#### Figure
A Figure is the main graphical object that can be displayed within any CompositeFigure. A Figure may declare handles that allow the manipulation of graphical features and it may also declare a model. If a model is declared and a properties toolbox is set, then whenever the user selects a figure, the model properties can be edited.

#### Model
A Model of a figure declares properties that can be edited either from the UI of the Figure or from a Properties figure.

#### Drawing 
A Drawing is a Composite figure that has no parent Figure and it is used to place Figure. A drawing may contain a grid that helps moving the figures around.

#### Handle
A Handle is a special kind of figure that satisfies the following conditions:
* Whenever the Figure changes it updates it's own state according to some rules.
* Whenever the Handle changes it updates the Figure which this Handle is observing according to some rules.

#### Connection
A Connection connects 2 Figures, a source and a target figure. The connection may contain multiple points in the middle and can be modified using its Handles.

#### Tool
A Tool helps doing some work in the Drawing (e.g. creating a new figure) that requires multiple internal steps depending on some UI events. For instance, connecting 2 Figures requires detecting a mouse down in a Figure, a mouse move and another mouse up on another Figure. If the last mouse up is in the Drawing then there is no connection. Also, there may be some rules on how to connect Figures, those issues are also considered in Cupdraw.

A Tool has an initial State and then it may transition to a different state according to the events it is receiving. Once its purpose is accomplished, the tool itself may switch to a different one, e.g. after creating the figure, the tool can switch to the selection tool.

#### Command
A Command is similar to a Tool but it doesn't require a sequence of steps. Instead, a Command directly executes over the Drawing producing some changes, e.g. saving the Drawing. Cupdraw provides some out of the box commands for you such as: alignment, grouping, blocking and z-index related commands.

#### Magnet
A Magnet is a special kind of object that forces 2 Figures to stay together. For instance, we can create a Magnet to make sure that a Handle sticks to the topLeft position of a Figure.

#### Toolbox
A Toolbox is a special figure that holds a list of Tool declarations or Command declarations. It can be moved through the Diagram and when the user clicks on a specific declaration, either the Command is executed or the Tool executing is initiated.

#### Properties 
The Properties Figure is a out of the box Figure that listens to the Diagram's selection changes and when only ONE Figure is selected, it prompts for the Model properties to be edited.
