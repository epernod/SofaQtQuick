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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2
import SofaBasics 1.0
import SceneComponent 1.0
import DataListModel 1.0

CollapsibleGroupBox {
    id: root
    implicitWidth: 0

    title: "Data"
    property int priority: 80
    contentMargin: 0

    property var scene: null
    property var sceneComponent: scene ? scene.selectedComponent : null

    enabled: scene ? scene.ready : false

    GridLayout {
        id: layout
        anchors.fill: parent
        columns: 1

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.preferredHeight: contentHeight
            clip: true
            focus: true

            property int nameLabelImplicitWidth : 16

            model: DataListModel {
                id: dataListModel
                sceneComponent: root.sceneComponent

                onSceneComponentChanged: listView.nameLabelImplicitWidth = 16;
            }

            section.property: "group"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle {
                width: parent.width
                height: childrenRect.height
                color: "darkgrey"
                radius: 10

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: section
                    color: "darkblue"
                    font.bold: true
                    font.pixelSize: 14
                }
            }

            delegate: Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                height: dataItem.height
                color: index % 2 ? Qt.rgba(0.85, 0.85, 0.85, 1.0) : Qt.rgba(0.9, 0.9, 0.9, 1.0)

                Rectangle {
                    visible: dataItem.modified
                    anchors.fill: dataItem
                    color: "lightsteelblue"
                    radius: 5
                }

                DataItem {
                    id: dataItem
                    anchors.left: parent.left
                    anchors.right: parent.right

                    scene: root.scene
                    sceneData: dataListModel.getDataById(index)

                    nameLabelWidth: listView.nameLabelImplicitWidth
                    Component.onCompleted: updateNameLabelWidth();
                    onNameLabelImplicitWidthChanged: updateNameLabelWidth();

                    function updateNameLabelWidth() {
                        listView.nameLabelImplicitWidth = Math.max(listView.nameLabelImplicitWidth, nameLabelImplicitWidth);
                    }
                }
            }
        }
    }
}
