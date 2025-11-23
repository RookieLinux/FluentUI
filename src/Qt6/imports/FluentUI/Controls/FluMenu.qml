import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Templates as T
import FluentUI

T.Menu {
    property bool animationEnabled: true
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    margins: 0
    overlap: 1 //与父项水平重叠像素 cascade:true时才有效(级联子菜单)
    spacing: 0
    delegate: FluMenuItem { } //代理
    enter: Transition { //进入动画
        NumberAnimation {
            property: "opacity"
            from:0
            to:1
            duration: FluTheme.animationEnabled && control.animationEnabled ? 83 : 0
        }
    }
    exit:Transition { //退出动画
        NumberAnimation {
            property: "opacity"
            from:1
            to:0
            duration: FluTheme.animationEnabled && control.animationEnabled ? 83 : 0
        }
    }
    contentItem: ListView {
        implicitHeight: contentHeight
        model: control.contentModel //动态模型
        interactive: Window.window
                     ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height
                     : false //是否使用Flickable交互
        clip: true //要不要把超出菜单矩形的内容切掉
        currentIndex: control.currentIndex
        ScrollBar.vertical: FluScrollBar{}
    }
    background: Rectangle {
        implicitWidth: 150
        implicitHeight: 36
        color:FluTheme.dark ? Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(252/255,252/255,252/255,1)
        border.color: FluTheme.dark ? Qt.rgba(26/255,26/255,26/255,1) : Qt.rgba(191/255,191/255,191/255,1)
        border.width: 1
        radius: 5
        FluShadow{}
    }
    T.Overlay.modal: Rectangle {//模态背景遮罩层
        color: FluTools.withOpacity(control.palette.shadow, 0.5)
    }
    T.Overlay.modeless: Rectangle {//非模态背景遮罩层
        color: FluTools.withOpacity(control.palette.shadow, 0.12)
    }
}
