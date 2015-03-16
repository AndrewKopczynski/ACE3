/*
 * Author: commy2
 *
 * Drag an object. Called from ace_dragging_fnc_startDrag
 *
 * Argument:
 * 0: Unit that should do the dragging (Object)
 * 1: Object to drag (Object)
 *
 * Return value:
 * NONE.
 */
#include "script_component.hpp"

private ["_unit", "_target"];

_unit = _this select 0;
_target = _this select 1;

// get attachTo offset and direction.
private ["_position", "_direction"];

_position = _target getVariable [QGVAR(dragPosition), [0, 0, 0]];
_direction = _target getVariable [QGVAR(dragDirection), 0];

// add height offset of model
private "_offset";
_offset = (_target modelToWorld [0, 0, 0] select 2) - (_unit modelToWorld [0, 0, 0] select 2);

_position = _position vectorAdd [0, 0, _offset];

// attach object
_target attachTo [_unit, _position];
_target setDir _direction;

_unit setVariable [QGVAR(isDragging), true, true];
_unit setVariable [QGVAR(draggedObject), _target, true];

// add scrollwheel action to release object
private "_actionID";
_actionID = _unit getVariable [QGVAR(ReleaseActionID), -1];

if (_actionID != -1) then {
    _unit removeAction _actionID;
};

_actionID = _unit addAction [
    format ["<t color='#FF0000'>%1</t>", "STR_AGM_Drag_EndDrag"],
    QUOTE([ARR_2(_this select 0, (_this select 0) getVariable [ARR_2(QUOTE(QGVAR(draggedObject)),objNull)])] call FUNC(dropObject)),
    nil,
    20,
    false,
    true,
    "",
    QUOTE(!isNull (_this getVariable [ARR_2(QUOTE(QGVAR(draggedObject)),objNull)]))
];

_unit setVariable [QGVAR(ReleaseActionID), _actionID];

// check everything
[FUNC(dragObjectPFH), 0, [_unit, _target]] call CBA_fnc_addPerFrameHandler;

// reset current dragging height.
GVAR(currentHeightChange) = 0;
