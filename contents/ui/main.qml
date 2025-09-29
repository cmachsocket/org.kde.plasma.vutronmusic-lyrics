import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    readonly property int config_update_time: Plasmoid.configuration.update_time
    readonly property int config_time_offset: Plasmoid.configuration.time_offset
    readonly property string config_text_color: Plasmoid.configuration.text_color
    readonly property string config_text_font: Plasmoid.configuration.text_font
    readonly property string cfg_translation: Plasmoid.configuration.translation
    preferredRepresentation: fullRepresentation
    fullRepresentation: Item {
        property string lyric: ""
        property bool trans: true
        property int update_time: 100
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
            color: config_text_color
            font: config_text_font || PlasmaCore.Theme.textColor
        }

        Timer {
            interval: config_update_time
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
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        //console.log("response:" + xhr.responseText)
                        let res = JSON.parse(xhr.responseText)
                        //res.data.lyric.lrc res.data.lyric.tlyric progress
                        let current_time = res.data.progress
                        let lyrics = res.data.lyric.lrc.split("\n")
                        let tlyrics = res.data.lyric.tlyric.split("\n")
                        for (var i in lyrics) {
                            let lrc_min = parseInt(lyrics[i].slice(1, 3))
                            let lrc_sec = parseFloat(lyrics[i].slice(4, 10))
                            if (lrc_min * 60 + lrc_sec > current_time + config_time_offset) {
                                break
                            }
                        }

                        if (i !== 0) {
                            lyric = lyrics[i - 1].slice(11)
                        }
                        if (cfg_translation === "enable"  && tlyrics[0] !== '') {
                            for (var j in tlyrics) {
                                let tlrc_min = parseInt(tlyrics[j].slice(1, 3))
                                let tlrc_sec = parseFloat(tlyrics[j].slice(4, 10))
                                if (tlrc_min * 60 + tlrc_sec > current_time + config_time_offset) {
                                    break
                                }
                            }
                            if (j !== 0) {
                                lyric += "\n" + tlyrics[j - 1].slice(11)
                            }

                        }
                    }
                }
            }
        }
    }
}
