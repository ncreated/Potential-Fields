package com.ncreated.lists {

	/***
	 * Basic doubly linked list.
	 *
	 * @author Maciek
	 *
	 * Created Sep 7, 2011
	 * 
	 */
	public class BasicLinkedList {

		private var _length:int;
		public var head:BasicLinkedListNode;
		public var tail:BasicLinkedListNode;

		public function BasicLinkedList() {
			head = tail = null;
			_length = 0;
		}

		public function get length():int {
			return _length;
		}

		/**
		 * Dodaje element do listy (na koniec).
		 */
		public function appendNode(node:BasicLinkedListNode):void {
			if (head == null) {
				head = tail = node;
			} else  {
				tail.next = node;
				node.prev = tail;
				tail = node;
			}
			++_length;
		}

		/**
		 * Dodaje element do listy, umieszczajac go przed wskazanym elementem.
		 * @param before_node
		 * @param new_node
		 */
		public function insertBeforeNode(before_node:BasicLinkedListNode, new_node:BasicLinkedListNode):void {
			if (before_node == head) {
				new_node.next = head;
				head.prev = new_node;
				new_node.prev = null;
				head = new_node;

			} else {
				before_node.prev.next = new_node;
				new_node.prev = before_node.prev;

				before_node.prev = new_node;
				new_node.next = before_node;
			}

			//if (tail == null) throw new Error("tail = null!!!");

			++_length;
		}
		
		/**
		 * Usuwa element z listy.
		 */
		public function removeNode(node:BasicLinkedListNode):void {
			if (node == head){
				head = node.next;
				if (head != null) head.prev	= null ;
			} else {
				node.prev.next = node.next;
			}

			if (node == tail){
				tail = node.prev;
				if (tail != null) tail.next = null;
			} else {
				node.next.prev = node.prev;
			}

			node.prev = null;
			node.next = null;

			--_length;
		}
		
		/**
		 * Usuwa i zwraca pierwszy element na liscie. 
		 * @return 
		 * 
		 */
		public function fetchHead():BasicLinkedListNode {
			if (_length > 0) {
				var node:BasicLinkedListNode = head;
				head = node.next;
				if (head != null) head.prev	= null ;
				
				node.prev = null;
				node.next = null;
				--_length;
				return node;
			}
			return null;
		}
		
		/**
		 * Usuwa i zwraca losowy element z listy liscie. 
		 * @return 
		 * 
		 */
		public function fetchRandom():BasicLinkedListNode {
			if (_length > 0) {
				var node:BasicLinkedListNode = head;
				var shifts:int = Math.round((_length-1) * Math.random());
				while (shifts > 0) {
					node = node.next;
					shifts--;
				}
				this.removeNode(node);
				return node;
			}
			return null;
		}
		
		public function removeAllNodes():void {
			while (_length > 0) removeNode(head);
		}

		public function contains(node:BasicLinkedListNode):Boolean {
			var it:BasicLinkedListNode = head;
			while (it) {
				if (it == node) return true;
				else it = it.next;
			}
			return false;
		}
	}
}