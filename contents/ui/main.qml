import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    readonly property string config_fixed_width: Plasmoid.configuration.fixed_width
    readonly property int config_max_width: Plasmoid.configuration.max_width
    readonly property string config_text_color: Plasmoid.configuration.text_color
    readonly property string config_text_font: Plasmoid.configuration.text_font
    readonly property int config_time_offset: Plasmoid.configuration.time_offset
    readonly property string config_translation: Plasmoid.configuration.translation
    readonly property int config_update_time: Plasmoid.configuration.update_time
    readonly property int config_vertical_offset: Plasmoid.configuration.vertical_offset

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    preferredRepresentation: fullRepresentation

    fullRepresentation: ColumnLayout {
        id: fullRep

        property string lyric_first: ""
        property string lyric_secondary: ""
        property int seek: 0
        property bool trans: true
        property int update_time: 100

        function update() {
            let xhr = new XMLHttpRequest();
            xhr.open("GET", "http://localhost:41830/local-asset/player");
            xhr.send();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        //console.log("response:" + xhr.responseText)
                        let res = JSON.parse(xhr.responseText);
                        //res.data.lyric.lrc res.data.lyric.tlyric progress
                        let current_time = res.data.progress;
                        let lyrics = res.data.lyric.lrc.split("\n");
                        let tlyrics = res.data.lyric.tlyric.split("\n");
                        for (var i = 0; i < lyrics.length; i++) {
                            let lrc_min = parseInt(lyrics[i].slice(1, 3));
                            let lrc_sec = parseFloat(lyrics[i].slice(4, 10));
                            if (lrc_min * 60 + lrc_sec > current_time + config_time_offset * 0.001) {
                                break;
                            }
                        }
                        if (i !== 0) {
                            console.log("i:" + i);
                            console.log("lyrics length:" + lyrics.length);
                            lyric_first = lyrics[i - 1].slice(11);
                        }
                        else{
                            lyric_first = lyric_secondary = "";
                            return ;
                        }
                        if (config_translation === "enable" && tlyrics[0] !== '') {
                            for (var j = 0; j < tlyrics.length; j++) {
                                let tlrc_min = parseInt(tlyrics[j].slice(1, 3));
                                let tlrc_sec = parseFloat(tlyrics[j].slice(4, 10));
                                if (tlrc_min * 60 + tlrc_sec > current_time + config_time_offset * 0.001) {
                                    break;
                                }
                            }
                            if (j !== 0) {
                                lyric_secondary = tlyrics[j - 1].slice(11);
                            }
                        }
                        else {
                            lyric_secondary = "";
                        }
                    }
                }
            };
        }

        // Layout.maximumWidth: {
        //     if (config_max_width > 0) {
        //         if (config_fixed_width !== "disable") {
        //             return config_max_width;
        //         }
        //         return Math.min(config_max_width, Math.max(lyric_label_first.implicitWidth, lyric_label_secondary.implicitWidth));
        //     } else {
        //         return -1;
        //     }
        // }
        // Layout.minimumWidth: (config_max_width > 0 && config_fixed_width !== "disable") ? config_max_width : -1
        anchors.fill: parent
        anchors.topMargin: config_vertical_offset
        spacing: 0

        //Layout.
        Label {
            id: lyric_label_first

            Layout.maximumWidth: {
                if (config_max_width > 0) {
                    if (config_fixed_width !== "disable") {
                        return config_max_width;
                    }
                    return Math.min(config_max_width, Math.max(lyric_label_first.implicitWidth, lyric_label_secondary.implicitWidth));
                } else {
                    return -1;
                }
            }
            Layout.minimumWidth: (config_max_width > 0 && config_fixed_width !== "disable") ? config_max_width : -1
            color: config_text_color
            elide: Text.ElideRight
            font: config_text_font || PlasmaCore.Theme.textColor
            horizontalAlignment: Text.AlignHCenter
            text: fullRep.lyric_first
            verticalAlignment: Text.AlignVCenter
        }
        Label {
            id: lyric_label_secondary
            visible: config_translation === "enable" && fullRep.lyric_secondary !== ""
            Layout.maximumWidth: {
                if (config_max_width > 0) {
                    if (config_fixed_width !== "disable") {
                        return config_max_width;
                    }
                    return Math.min(config_max_width, Math.max(lyric_label_first.implicitWidth, lyric_label_secondary.implicitWidth));
                } else {
                    return -1;
                }
            }
            Layout.minimumWidth: (config_max_width > 0 && config_fixed_width !== "disable") ? config_max_width : -1
            color: config_text_color
            elide: Text.ElideRight
            font: config_text_font || PlasmaCore.Theme.textColor
            horizontalAlignment: Text.AlignHCenter
            text: fullRep.lyric_secondary
            verticalAlignment: Text.AlignVCenter
        }
        Timer {
            interval: config_update_time
            repeat: true
            running: true
            triggeredOnStart: true

            onTriggered: {
                update();
            }
        }
    }
}
