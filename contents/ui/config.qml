import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts as QtLayouts
import QtQuick.Dialogs
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: config_page

    property alias cfg_flush_time: config_flush_time.value
    property alias cfg_max_width: config_max_width.value
    property alias cfg_text_color: text_color.selectedColor
    property alias cfg_text_font: text_font.selectedFont
    property alias cfg_time_offset: config_time_offset.value
    property alias cfg_translation: translation_text.text
    property alias cfg_fixed_width: fixed_width_label.text

    height: childrenRect.height
    width: childrenRect.width

    QtLayouts.GridLayout {
        anchors.fill: parent
        columns: 2

        /* row 1 */
        QtControls.Label {
            anchors.right: parent.center
            text: i18n("flush time: ")
        }
        QtLayouts.RowLayout {
            QtControls.SpinBox {
                id: config_flush_time

                from: 10
                stepSize: 10
                to: 2000
                value: cfg_flush_time
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

                from: -2000
                stepSize: 500
                to: 2000
                value: cfg_time_offset
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
                border.color: "black"
                color: text_color.selectedColor
                height: 20
                radius: 5
                width: 20

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
                    font_button.text = text_font.selectedFont;
                    cfg_text_font = text_font.selectedFont;
                    text_font.close();
                }
                onRejected: {
                    text_font.close();
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
                    checked: (translation_text.text === text) || (translation_text.text === "")
                    text: "disable"

                    onClicked: translation_text.text = "disable"
                }
                QtControls.RadioButton {
                    checked: translation_text.text === text
                    text: "enable"

                    onClicked: translation_text.text = "enable"
                }
            }
        }
        /* row 6 */
        QtControls.Label {
            anchors.right: parent.center
            text: i18n("max width: ")
        }
        QtLayouts.RowLayout {
            QtControls.SpinBox {
                id: config_max_width
                from : 0
                stepSize: 10
                to: 10000
                value: cfg_max_width
            }
            QtControls.Label {
                text: i18n("set 0 as unlimited")
            }
        }
        /* row 7 */
        QtControls.Label {
            anchors.right: parent.center
            text: i18n("set max_width as fixed width: ")
        }
        QtLayouts.RowLayout {
            QtControls.Label {
                id: fixed_width_label

                visible: false
            }
            Column {
                id: fixed_witdh_column

                QtControls.RadioButton {
                    checked: (fixed_width_label.text === text) || (fixed_width_label.text === "")
                    text: "disable"

                    onClicked: fixed_width_label.text = "disable"
                }
                QtControls.RadioButton {
                    checked: fixed_width_label.text === text
                    text: "enable"

                    onClicked: fixed_width_label.text = "enable"
                }
            }
        }
    }
}