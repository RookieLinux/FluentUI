import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Page {
    property int launchMode: FluPageType.SingleTop
    property bool animationEnabled: FluTheme.animationEnabled
    property string url : ""
    id: control
    StackView.onRemoved: destroy() //StackView的附加信号
    padding: 5
    visible: false
    opacity: visible //属性绑定
    transform: Translate { //位移动画
        y: control.visible ? 0 : 80
        Behavior on y{
            enabled: control.animationEnabled && FluTheme.animationEnabled
            NumberAnimation{
                duration: 167
                easing.type: Easing.OutCubic//缓动类型
            }
        }
    }
    Behavior on opacity { //透明度动画
        enabled: control.animationEnabled && FluTheme.animationEnabled
        NumberAnimation{
            duration: 83
        }
    }
    background: Item{}
    header: FluLoader{
        sourceComponent: control.title === "" ? undefined : com_header //sourceComponent属性用于加载内联组件
    }
    Component{
        id: com_header
        Item{
            implicitHeight: 40
            FluText{
                id:text_title
                text: control.title
                font: FluTextStyle.Title
                anchors{
                    left: parent.left
                    leftMargin: 5
                }
            }
        }
    }
    Component.onCompleted: {
        control.visible = true
    }
}
