package com.youbt.utils
{
	
	public class MathUtils
	{
		public static function random(start:Number,end:Number):Number{
			return Math.round(Math.random()*(end-start)+start)
		}
	}
}