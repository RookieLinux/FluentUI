import QtQuick
import QtQuick.Controls
import FluentUI

FluStatusLayout {
    property url source: ""
    property bool lazy: false
    color:"transparent"
    id:control
    onErrorClicked: {
        reload()
    }
    Component.onCompleted: {
        if(!lazy){
            loader.source = control.source
        }
    }
    FluLoader{
        id:loader
        anchors.fill: parent
        asynchronous: true
        onStatusChanged: {
            if(status === Loader.Error){
                control.statusMode = FluStatusLayoutType.Error
            }else if(status === Loader.Loading){
                control.statusMode = FluStatusLayoutType.Loading
            }else{
                control.statusMode = FluStatusLayoutType.Success
            }
        }
    }
    function reload(){
        var timestamp = Date.now();
        loader.source = control.source+"?"+timestamp
        //"?" - URL查询参数的分隔符  通过在URL后添加唯一的时间戳参数，
        // 确保每次重新加载时都获取最新的资源
    }
    function itemLodaer(){
        return loader
    }
}
