import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        property string lyric: ""
        property bool trans: true
        property int update_time : 100
        property int seek: 0
        Layout.preferredWidth: lyric_label.implicitWidth
        Layout.preferredHeight: lyric_label.implicitHeight
        //Layout.
        Label {
            id: lyric_label
            text: parent.lyric
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            color:  PlasmaCore.Theme.textColor
        }

        Timer {
            interval: update_time
            onTriggered: {
                update()
            }
            repeat: true
            running: true
            triggeredOnStart: true
        }
        function update() {
            let xhr = new XMLHttpRequest()
            xhr.open("GET", "http://localhost:41830/local-asset/player")
            xhr.send()
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 )  {
                    if (xhr.status === 200) {
                        //console.log("response:" + xhr.responseText)
                        let res = JSON.parse(xhr.responseText)
                        //res.data.lyric.lrc res.data.lyric.tlyric progress
                        let current_time=res.data.progress
                        let lyrics=res.data.lyric.lrc.split("\n")
                        let tlyrics=res.data.lyric.tlyric.split("\n")
                        for(var i in lyrics){
                            let lrc_min=parseInt(lyrics[i].slice(1,3))
                            let lrc_sec=parseFloat(lyrics[i].slice(4,10))
                            if(lrc_min*60+lrc_sec>current_time+seek){
                                break
                            }
                        }

                        lyric = lyrics[i-1].slice(11)
                        if(trans===true &&  tlyrics[0]!==''){
                            for(var j in tlyrics){
                                let tlrc_min=parseInt(tlyrics[j].slice(1,3))
                                let tlrc_sec=parseFloat(tlyrics[j].slice(4,10))
                                if(tlrc_min*60+tlrc_sec>current_time+seek){
                                    break
                                }
                            }
                            if(j!=0){
                                lyric += "\n"+tlyrics[j-1].slice(11)
                            }

                        }
                    }
                }
            }
        }
    }
}
