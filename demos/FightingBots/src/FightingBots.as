package {

    import com.ncreated.ai.potentialfields.PFAgent;
    import com.ncreated.ai.potentialfields.PFDynamicPotentialsMap;
    import com.ncreated.ai.potentialfields.PFPotentialField;
    import com.ncreated.ai.potentialfields.PFRadialPotentialField;
    import com.ncreated.lists.BasicLinkedList;
    import com.ncreated.lists.BasicLinkedListNode;

    import flash.display.Bitmap;
    import flash.display.BitmapData;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.utils.getTimer;

    /**
     * Demo: few bots fight on the stage.
     *
     * @author maciek grzybowski, 24.08.2013 15:23
     *
     */
    [SWF(width='600', height='400', backgroundColor='#eeeeee', frameRate='30')]
    public class FightingBots extends Sprite {

        public static const TILE_SIZE:int = 4;

        /* All bots emit potentials on this map. Thus bots avoid collisions. */
        private var _botsAvoidanceMap:PFDynamicPotentialsMap;

        private var _botsList:BasicLinkedList;
        private var _bulletsList:BasicLinkedList;

        private var _debugBitmap:Bitmap;

        public function FightingBots() {
            addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
        }

        private function get mapWidth():int {return stage.stageWidth / TILE_SIZE;}
        private function get mapHeight():int {return stage.stageHeight/ TILE_SIZE;}

        private function init(event:Event):void {
            stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
            stage.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);

            _botsAvoidanceMap = new PFDynamicPotentialsMap(mapWidth, mapHeight);

            /* Create bots. */
            _botsList = new BasicLinkedList();
            respawnBots();

            /* Create bullets list. */
            _bulletsList = new BasicLinkedList();

            // Just for debug purposes:

            /* Create debug bitmap. */
            _debugBitmap = new Bitmap(new BitmapData(mapWidth, mapHeight));
            _debugBitmap.scaleX = stage.stageWidth / mapWidth;
            _debugBitmap.scaleY = stage.stageHeight/ mapHeight;
            addChildAt(_debugBitmap, 0);
        }

        private function respawnBots():void {
            while (_botsList.length < 10) {
                _botsList.appendNode(createBot(Bot.TEAM_RED, Math.random() * mapWidth, Math.random() * mapHeight));
                _botsList.appendNode(createBot(Bot.TEAM_BLUE, Math.random() * mapWidth, Math.random() * mapHeight));
            }
        }

        private function createBot(team:int, x:int, y:int):Bot {
            var bot:Bot = new Bot();
            bot.team = team;
            bot.isAlive = true;

            /* Create an agent that will controll this bot movement. */
            bot.agent = new PFAgent();
            bot.agent.type = PFPotentialField.PF_TYPE_REPEL;
            bot.agent.potential = 200;
            bot.agent.gradation = 20;
            bot.agent.position.setTo(x, y);

            /* Add this agent to common avoidance map. */
            _botsAvoidanceMap.addPotentialField(bot.agent);

            /* Register avoidance map for this bot. */
            bot.agent.addDynamicPotentialsMap(_botsAvoidanceMap);

            /* Create "follow target" potential field that will attract this bot to enemy bot. */
            bot.followTargetPotential = new PFRadialPotentialField();
            bot.followTargetPotential.type = PFPotentialField.PF_TYPE_ATTRACT;
            bot.followTargetPotential.potential = 1.42 * Math.max(mapWidth, mapHeight);// make sure that potential covers whole map
            bot.followTargetPotential.gradation = 1;
            bot.followTargetPotential.position.setTo(x, y);

            /* Create "keep distance" potential field which will prevent this bot from getting too close to its target (enemy bot). */
            bot.keepDistancePotential = new PFRadialPotentialField();
            bot.keepDistancePotential.type = PFPotentialField.PF_TYPE_REPEL;
            bot.keepDistancePotential.potential = 250
            bot.keepDistancePotential.gradation = 15;
            bot.keepDistancePotential.position.setTo(x, y);

            /* Register commands map for this bot. */
            bot.agent.addDynamicPotentialsMap(new PFDynamicPotentialsMap(mapWidth, mapHeight));

            /* Add "follow target" and "keep distance" potentials to commands map. */
            bot.agent.dynamicPotentialsMaps[1].addPotentialField(bot.followTargetPotential);
            bot.agent.dynamicPotentialsMaps[1].addPotentialField(bot.keepDistancePotential);

            /* Create bot sprite. */
            bot.sprite = new Sprite();
            bot.sprite.graphics.beginFill(team == Bot.TEAM_RED ? 0xFF0000 : 0x0000FF);
            bot.sprite.graphics.drawCircle(0, 0, Bot.RADIUS);
            bot.sprite.graphics.endFill();
            bot.sprite.cacheAsBitmap = true;
            addChild(bot.sprite);
            return bot;
        }

        private function destroyBot(bot:Bot):void {
            removeChild(bot.sprite);
            _botsAvoidanceMap.removePotentialField(bot.agent);
            _botsList.removeNode(bot);
        }

        private function createBullet(start_position:Point, target_position:Point, team:int):Bullet {
            var bullet:Bullet = new Bullet();
            bullet.team = team;
            bullet.isAlive = true;

            /* Set velocity. */
            var dx:Number = (target_position.x - start_position.x) * TILE_SIZE;
            var dy:Number = (target_position.y - start_position.y) * TILE_SIZE;
            var len:Number = Math.sqrt(dx * dx + dy * dy);
            var normalizedDX:Number = dx / len;
            var normalizedDY:Number = dy / len;
            bullet.vx = Bullet.SPEED * normalizedDX;
            bullet.vy = Bullet.SPEED * normalizedDY;

            /* Create sprite. */
            bullet.sprite = new Sprite();
            bullet.sprite.graphics.lineStyle(2, team == Bot.TEAM_RED ? 0xFF0000 : 0x0000FF)
            bullet.sprite.graphics.moveTo(-normalizedDX * 2, -normalizedDY * 2);
            bullet.sprite.graphics.lineTo(normalizedDX * 2, normalizedDY * 2);
            bullet.sprite.cacheAsBitmap = true;
            bullet.sprite.x = start_position.x * TILE_SIZE;
            bullet.sprite.y = start_position.y * TILE_SIZE;
            addChild(bullet.sprite);

            return bullet;
        }

        private function destroyBullet(bullet:Bullet):void {
            removeChild(bullet.sprite);
            _bulletsList.removeNode(bullet);
        }

        private function onEnterFrame(event:Event):void {
            var temp : Number = _previousUpdateTime;
            _previousUpdateTime = getTimer();
            var dt:Number = (_previousUpdateTime - temp) / 1000;

            /* Update bots. */
            var iterator:BasicLinkedListNode = _botsList.head;
            while (iterator) {
                var bot:Bot = iterator as Bot;
                bot.update(dt);

                if (bot.target) {
                    if (bot.canShoot) {
                        // shot
                        _bulletsList.appendNode(createBullet(bot.agent.position, bot.target.agent.position, bot.team));
                        bot.canShoot = false;
                    }
                }
                else {
                    // find target
                    bot.findTarget(_botsList);
                }

                iterator = iterator.next;

                if (!bot.isAlive) destroyBot(bot);
            }

            /* Update bullets. */
            iterator = _bulletsList.head;
            while (iterator) {
                var bullet:Bullet = iterator as Bullet;
                bullet.update(dt);

                iterator = iterator.next;

                // check for bullet-bot collision (please note that this could be optimized for better performance)
                var botIterator:BasicLinkedListNode = _botsList.head;
                while (botIterator) {
                    bot = botIterator as Bot;

                    if (bot.team != bullet.team) {
                        if (distance(bot.sprite.x, bot.sprite.y, bullet.sprite.x, bullet.sprite.y) < Bot.RADIUS) {
                            bullet.isAlive = false;
                            bot.hp--;
                            bot.isAlive = bot.hp > 0;
                            if (!bot.isAlive) destroyBot(bot);
                        }
                    }

                    botIterator = botIterator.next;
                }

                if (!bullet.isAlive) destroyBullet(bullet);
            }


            // Just for debug purposes:

            /* Clear debug drawing. */
//            _debugBitmap.bitmapData.fillRect(_debugBitmap.bitmapData.rect, 0xFFFFFF);

            /* Draw map's potentials. */
//            if (_botsList.head) {
//                bot = _botsList.head as Bot;
//                bot.agent.dynamicPotentialsMaps[1].debugDrawPotentials(_debugBitmap.bitmapData);
//            }
        }

        private function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number {
            return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
        }

        private var _previousUpdateTime:int;

        private function onClick(event:MouseEvent):void {
            while (_botsList.length > 0) destroyBot(_botsList.tail as Bot);
            while (_bulletsList.length > 0) destroyBullet(_bulletsList.tail as Bullet);
            respawnBots();
        }
    }
}
