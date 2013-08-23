package ui.events {
    import com.ncreated.ai.potentialfields.PFAgent;

    import components.model.AgentVO;

    import flash.events.Event;

    /**
     *
     * @author maciek grzybowski, 20.04.13 20:44
     *
     */
    public class AgentCreatorEvent extends Event {

        public static var uid:int = 0;

        public static const AGENT_CREATED:String = "agentCreated"
        public static const AGENT_UPDATED:String = "agentUpdated"

        private var _vo:AgentVO;
        private var _storeOnList:Boolean;

        public function AgentCreatorEvent(type:String) {
            super(type);
        }

        public function get agentVO():AgentVO {
            return _vo;
        }

        public function withAgentVO(vo:AgentVO):AgentCreatorEvent {
            _vo = vo;
            return this;
        }

        public function get storeOnList():Boolean {
            return _storeOnList;
        }

        public function withStoreOnList(value:Boolean):AgentCreatorEvent {
            _storeOnList = value;
            return this;
        }
    }
}
