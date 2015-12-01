/*
Copyright 2015, Anatoscope

This file is part of sofaqtquick.

sofaqtquick is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sofaqtquick is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sofaqtquick. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Manipulator2D_Rotation 1.0

Manipulator2D_Rotation {
    id: root

    property real startAngle: 0.0
    property var  startOrientation

    function mousePressed(mouse, viewer) {
        // project on a specific plane parallel to our view plane
        var z = viewer.computeDepth(root.position);
        var position = viewer.mapToWorld(Qt.point(mouse.x + 0.5, mouse.y + 0.5), z);

        var direction = position.minus(root.position).normalized();
        startAngle = Math.acos(viewer.camera.up().dotProduct(direction));
        if(viewer.camera.right().dotProduct(direction) < 0.0)
            startAngle = -startAngle;

        startOrientation = Qt.quaternion(root.orientation.scalar, root.orientation.x, root.orientation.y, root.orientation.z);
    }

    function mouseMoved(mouse, viewer) {
        // project on a specific plane parallel to our view plane
        var z = viewer.computeDepth(root.position);
        var position = viewer.mapToWorld(Qt.point(mouse.x + 0.5, mouse.y + 0.5), z);

        var direction = position.minus(root.position).normalized();
        var angle = Math.acos(viewer.camera.up().dotProduct(direction));
        if(viewer.camera.right().dotProduct(direction) < 0.0)
            angle = -angle;

        setMark(startAngle, angle);

        var orientation = quaternionFromAxisAngle(viewer.camera.direction().normalized(), (angle - startAngle) / Math.PI * 180.0);
        root.orientation = quaternionMultiply(orientation, startOrientation);
    }

    function mouseReleased(mouse, viewer) {
        unsetMark();
    }
}
