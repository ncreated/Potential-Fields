package com.ncreated.lists {
	/***
	 * Klasa bazowa dla elementow BasicLinkedList.
	 * 
	 * @author Maciek 
	 * Sandcastle_ST 
	 * Created Sep 7, 2011
	 * 
	 */
	public class BasicLinkedListNode {

		public var next:BasicLinkedListNode;
		public var prev:BasicLinkedListNode;

		public function BasicLinkedListNode() {
			next = prev = null;
		}
	}
}