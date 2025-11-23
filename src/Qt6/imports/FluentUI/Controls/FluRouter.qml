pragma Singleton //这是一个QML编译指令，用于声明当前的QML文件为单例模式

import QtQuick
import FluentUI

QtObject {
    property var routes : ({}) //js对象
    property var windows: []   //js数组
    function addWindow(window){
        if(!window.transientParent){ //属性 是否是独立窗口
            windows.push(window)  //js数组方法 向数组末尾添加一个或多个元素
        }
    }
    function removeWindow(win) {
        if(!win.transientParent){ //属性 是否是独立窗口
            var index = windows.indexOf(win)
            if (index !== -1) {
                windows.splice(index, 1) //js数组方法 删除/替换/插入数组元素
                win.deleteLater()
            }
        }
    }
    function exit(retCode){
        for(var i =0 ;i< windows.length; i++){
            var win = windows[i]
            win.deleteLater()
        }
        windows = []
        Qt.exit(retCode)
    }
    function navigate(route,argument={},windowRegister = undefined){
        if(!routes.hasOwnProperty(route)){ //js对象方法 检查对象是否具有指定的自有属性（不包括继承属性）
            console.error("Not Found Route",route)
            return
        }
        var windowComponent = Qt.createComponent(routes[route]) //动态创建qml组件 只创建组件定义，不立即创建实例对象
        if (windowComponent.status !== Component.Ready) {
            console.error(windowComponent.errorString())
            return
        }
        var properties = {}
        properties._route = route
        if(windowRegister){
            properties._windowRegister = windowRegister
        }
        properties.argument = argument
        var win = undefined
        for(var i =0 ;i< windows.length; i++){
            var item = windows[i]
            if(route === item._route){
                win = item
                break
            }
        }
        if(win){
            var launchMode = win.launchMode
            if(launchMode === 1){
                win.argument = argument
                win.show()
                win.raise()
                win.requestActivate() //请求激活 使其成为当前活跃窗口
                return
            }else if(launchMode === 2){
                win.close()
            }
        }
        win  = windowComponent.createObject(null,properties) //创建qml组件实例
        if(windowRegister){
            windowRegister._to = win
        }
    }
}
