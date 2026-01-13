pragma Singleton
import QtQuick 2.15

QtObject {
    property color backgroundColor: "#FFFFFF"
    property color surfaceColor: "#F5F5F5"
    property color accentColor: "#3B82F6" // Blue-500
    property color textColor: "#1F2937"   // Gray-800
    property color secondaryTextColor: "#6B7280" // Gray-500
    property color borderColor: "#E5E7EB" // Gray-200
    property color hoverColor: "#F3F4F6"
    property color pressedColor: "#E5E7EB"
    
    // Font setup
    property string fontFamily: "Segoe UI" 
    property int headerFontSize: 24
    property int titleFontSize: 18
    property int bodyFontSize: 14
    property int smallFontSize: 12
}
