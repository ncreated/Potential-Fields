package {
    import com.ncreated.ai.potentialfields.PFAgent;
    import com.ncreated.ai.potentialfields.PFRadialPotentialField;
    import com.ncreated.lists.BasicLinkedList;
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.display.Sprite;
    import flash.geom.Point;

    /**
     * Bot class. Updates bot's state.
     *
     * @author maciek grzybowski, 24.08.2013 15:41
     *
     */
    public class Bot extends BasicLinkedListNode {

        public static const TEAM_RED:int = 0;
        public static const TEAM_BLUE:int = 1;
        public static const RADIUS:Number = 10;
        private static const GUN_RELOAD_TIME:Number = 1.5;

        public var team:int;
        public var sprite:Sprite;
        public var hp:int;

        public var target:Bot;
        public var canShoot:Boolean;
        private var _timeToShoot:Number;

        public var agent:PFAgent;
        public var followTargetPotential:PFRadialPotentialField;
        public var keepDistancePotential:PFRadialPotentialField;

        public var isAlive:Boolean;

        public function Bot() {
            _timeToShoot = GUN_RELOAD_TIME * Math.random();
            hp = 5;
        }


        public function update(dt:Number):void {
            /* Reload gun. */
            _timeToShoot -= dt;

            /* Update commands potentials. */
            if (target) {
                if (target.isAlive) {
                    var targetPosition:Point = target.agent.position;

                    // follow the target
                    followTargetPotential.position.setTo(targetPosition.x,  targetPosition.y);
                    keepDistancePotential.position.setTo(targetPosition.x,  targetPosition.y);

                    // check shoot distance
                    var targetDistanceX:Number = (targetPosition.x - agent.position.x) * FightingBots.TILE_SIZE;
                    var targetDistanceY:Number = (targetPosition.y - agent.position.y) * FightingBots.TILE_SIZE;
                    var targetDistance = Math.sqrt(targetDistanceX * targetDistanceX + targetDistanceY * targetDistanceY);
                    canShoot = targetDistance < 100 && _timeToShoot <= 0;

                    if (canShoot) _timeToShoot = GUN_RELOAD_TIME;
                }
                else {
                    target = null;
                }
            }
            else {
                // don't move if there's no target
                canShoot = false;
            }

            /* Move the agent. */
            agent.moveToPositionPoint(agent.nextPosition());

            /* Update sprite position. */
            sprite.x = agent.position.x * FightingBots.TILE_SIZE;
            sprite.y = agent.position.y * FightingBots.TILE_SIZE;
        }

        public function findTarget(bots_list:BasicLinkedList):void {
            var nearestBotDistance:Number;
            var iterator:BasicLinkedListNode = bots_list.head;

            while (iterator) {
                var bot:Bot = iterator as Bot;

                if (bot.team != team) {
                    if (!target) {
                        target = bot;
                        nearestBotDistance = distance(bot.sprite.x, bot.sprite.y, sprite.x, sprite.y);
                    }
                    else {
                        var botDistance:Number = distance(bot.sprite.x, bot.sprite.y, sprite.x, sprite.y);
                        if (nearestBotDistance > botDistance) {
                            nearestBotDistance = botDistance;
                            target = bot;
                        }
                    }
                }

                iterator = iterator.next;
            }
        }

        private function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        }
    }
}
