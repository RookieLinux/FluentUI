import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

FluWindow {
    id:control
    property Component contentDelegate
    autoVisible: false //关闭自动可见
    autoCenter: false
    autoDestroy: true //不可见时自动释放资源
    fixSize: true
    Loader{
        anchors.fill: parent
        sourceComponent: {
            if(control.autoDestroy){
                return control.visible ? control.contentDelegate : undefined
            }
            return control.contentDelegate
        }
    }
    closeListener: function(event){ //拦截窗口关闭事件
        control.visibility = Window.Hidden
        event.accepted = false //不继续默认关闭行为
    }
    Connections{
        target: control.transientParent //拥有者或父窗口
        function onVisibilityChanged(){
            if(control.transientParent.visibility === Window.Hidden){
                control.visibility = Window.Hidden
            }
        }
    }
    function showDialog(offsetX=0,offsetY=0){
        var x = transientParent.x + (transientParent.width - width)/2 + offsetX
        var y = transientParent.y + (transientParent.height - height)/2 + offsetY
        control.stayTop = Qt.binding(function(){return transientParent.stayTop})//与父窗口置顶行为保持一致
        control.setGeometry(x,y,width,height)
        control.visibility = Window.Windowed
    }
}
