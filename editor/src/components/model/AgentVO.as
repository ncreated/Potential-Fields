
package components.model {
    import com.ncreated.ai.potentialfields.PFAgent;

    /**
     *
     * @author maciek grzybowski, 20.04.13 21:37
     *
     */
    public class AgentVO {

        public static var uid:int = 0;

        private var _agent:PFAgent;

        [Bindable]
        public var name:String;

        [Bindable]
        public var description:String;

        [Bindable]
        public var color:uint;

        public function AgentVO(agent:PFAgent) {
            _agent = agent;
            name = "#"+String(uid++);
            description = "Agent (potential="+PFAgent(_agent).potential+", gradation="+PFAgent(_agent).gradation+")";
        }

        public function withName(value:String):AgentVO {
            name = value;
            return this;
        }

        public function withColor(value:uint):AgentVO {
            color = value;
            return this;
        }

        public function get agent():PFAgent {
            return _agent;
        }
    }
}
