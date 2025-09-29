import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts as QtLayouts
import QtQuick.Dialogs
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM
KCM.SimpleKCM {
    id: config_page
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_flush_time: config_flush_time.value
    property alias cfg_time_offset: config_time_offset.value
    property alias cfg_text_color: text_color.selectedColor
    property alias cfg_text_font: text_font.selectedFont
    property alias cfg_translation: translation_text.text

    QtLayouts.GridLayout {
        anchors.fill: parent
        columns: 2

        /* row 1 */
        QtControls.Label {
            text: i18n("flush time: ")
            anchors.right: parent.center
        }
        QtLayouts.RowLayout {
            QtControls.SpinBox {
                id: config_flush_time
                from: 10;
                to: 2000;
                value: cfg_flush_time
                stepSize: 10
            }

            QtControls.Label {
                text: i18n("ms (0~2000ms)")
            }
        }

        /* row 2 */
        QtControls.Label {
            text: i18n("time offset: ")
        }
        QtLayouts.RowLayout {
            QtControls.SpinBox {
                id: config_time_offset
                from: -2000;
                to: 2000;
                value: cfg_time_offset
                stepSize: 500
            }

            QtControls.Label {
                text: i18n("ms (-2000~2000ms)")
            }
        }

        /* row 3 */
        QtControls.Label {
            text: i18n("color: ")
        }
        QtLayouts.RowLayout {
            Rectangle {
                height: 20
                width: 20
                border.color: "black"
                color: text_color.selectedColor
                radius: 5
                MouseArea {
                    anchors.fill: parent
                    onClicked: text_color.open()
                }
            }

            ColorDialog {
                id: text_color
                title: "set text color"
            }
        }


        /* row 4 */
        QtControls.Label {
            id: font_layout
            text: i18n("font: ")
        }
        QtLayouts.RowLayout {
            QtControls.Button {
                id: font_button
                text: cfg_text_font || i18n("default")
                onClicked: text_font.open()
            }

            FontDialog {
                id: text_font
                selectedFont: cfg_text_font
                onAccepted: {
                    font_button.text = text_font.selectedFont
                    cfg_text_font = text_font.selectedFont
                    text_font.close()
                }
                onRejected: {
                    text_font.close()
                }
            }
        }
        /* row 5 */
        QtControls.Label {
            id: second_language_layout
            text: i18n("translation: ")
        }
        QtLayouts.RowLayout {
            QtControls.Label {
                id: translation_text
                visible: false
            }

            Column {
                id: second_language_column
                QtControls.RadioButton {
                    text: "disable"
                    checked: (translation_text.text === text) || (translation_text.text === "")
                    onClicked: translation_text.text = "disable"
                }
                QtControls.RadioButton {
                    text: "enable"
                    checked: translation_text.text === text
                    onClicked: translation_text.text = "enable"
                }
            }
        }
    }
}