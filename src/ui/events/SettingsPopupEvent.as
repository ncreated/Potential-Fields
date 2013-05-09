package ui.events {
    import flash.events.Event;

    /**
     *
     * @author maciek grzybowski, 28.04.2013 17:01
     *
     */
    public class SettingsPopupEvent extends Event {

        public static const ACCEPTED:String = "settingsAccepted";

        private var _mapWidth:int;
        private var _mapHeight:int;

        public function SettingsPopupEvent(type:String) {
            super(type);
        }

        public function get mapWidth():int {
            return _mapWidth;
        }

        public function get mapHeight():int {
            return _mapHeight;
        }

        public function set mapWidth(value:int):void {
            _mapWidth = value;
        }

        public function set mapHeight(value:int):void {
            _mapHeight = value;
        }
    }
}
