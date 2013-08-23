package ui.events {
    import components.model.MarkerVO;

    import flash.events.Event;

    /**
     *
     * @author maciek grzybowski, 27.04.2013 13:56
     *
     */
    public class MarkerCreatorEvent extends Event {

        public static var uid:int = 0;

        public static const MARKER_CREATED:String = "markerCreated"
        public static const MARKER_UPDATED:String = "markerUpdated"

        private var _vo:MarkerVO;
        private var _storeOnList:Boolean;

        public function MarkerCreatorEvent(type:String) {
            super(type);
        }

        public function get markerVO():MarkerVO {
            return _vo;
        }

        public function withMarkerVO(vo:MarkerVO):MarkerCreatorEvent {
            _vo = vo;
            return this;
        }

        public function get storeOnList():Boolean {
            return _storeOnList;
        }

        public function withStoreOnList(value:Boolean):MarkerCreatorEvent {
            _storeOnList = value;
            return this;
        }
    }
}
