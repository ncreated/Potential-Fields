package ui.events {
    import components.model.PotentialFieldVO;

    import flash.events.Event;

    /**
     *
     * @author maciek grzybowski, 13.04.2013 18:33
     *
     */
    public class FieldCreatorEvent extends Event {

        public static var uid:int = 0;

        public static const FIELD_CREATED:String = "fieldCreated"
        public static const FIELD_CHANGED:String = "fieldChanged"

        private var _vo:PotentialFieldVO;
        private var _storeOnList:Boolean;

        private var _userData:Object;

        public function FieldCreatorEvent(type:String) {
            super(type);
        }

        public function get fieldVO():PotentialFieldVO {
            return _vo;
        }

        public function withFieldVO(vo:PotentialFieldVO):FieldCreatorEvent {
            _vo = vo;
            return this;
        }

        public function get userData():Object {
            return _userData;
        }

        public function withUserData(ud:Object):FieldCreatorEvent {
            _userData = ud;
            return this;
        }

        public function get storeOnList():Boolean {
            return _storeOnList;
        }

        public function withStoreOnList(value:Boolean):FieldCreatorEvent {
            _storeOnList = value;
            return this;
        }
    }
}
