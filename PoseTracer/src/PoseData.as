package  
{
	import com.as3nui.nativeExtensions.air.kinect.data.PointCloudRegion;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class PoseData 
	{
		
		public function PoseData() 
		{
			
		}
		
		private var _lhMax:Number = 0;
		private var _rhMax:Number = 0;
		private var _lsMax:Number = 0;
		private var _rsMax:Number = 0;
		private var _bdMax:Number = 0;
		private var _lhMin:Number = 1000;
		private var _rhMin:Number = 1000;
		private var _lsMin:Number = 1000;
		private var _rsMin:Number = 1000;
		private var _bdMin:Number = 1000;
		public function setUsersWithSkeleton(usersWithSkeleton:Vector.<User>):String {
			var count:int = 0;
			var message:String = "";
			var s:String = "";
			var lh:Number = 0;
			var bd:Number = 0;
			var rh:Number = 0;
			var rs:Number = 0;
			var ls:Number = 0;
			
			var n:int = usersWithSkeleton.length;
			
			if (n == 1) {
				// 一体検知した場合、首が画面の右半分にいる場合は1になるようにする。
				if (usersWithSkeleton[0].neck.position.depth.x > 160) {
					//trace("右", usersWithSkeleton[0].neck.position.depth.x);
					count = 1;
				}
			}else if (n > 1) {
				// 二体検知した場合、首の位置を確認し、左側を0に、右側を1になるようにする。
				if (usersWithSkeleton[0].neck.position.depth.x > usersWithSkeleton[1].neck.position.depth.x) {
					count = 1;
				}
			}
			
			
			for (var i:int = 0; i < n; i++) 
			{
				var user:User = usersWithSkeleton[i];
				
				s = String(count % 2);
				
				for each( var joint:SkeletonJoint in user.skeletonJoints) {
					if (joint.name == SkeletonJoint.RIGHT_HAND) {
						rh = joint.position.depth.y;
					}else if (joint.name == SkeletonJoint.NECK) {
						bd = joint.position.depth.y;
					}else if (joint.name == SkeletonJoint.LEFT_HAND) {
						lh = joint.position.depth.y;
					}else if (joint.name == SkeletonJoint.RIGHT_SHOULDER) {
						rs = joint.position.depth.y;
					}else if (joint.name == SkeletonJoint.LEFT_SHOULDER) {
						ls = joint.position.depth.y;
					}
				}
				
				_rhMax = Math.max(rh, _rhMax);
				_lhMax = Math.max(lh, _lhMax);
				_bdMax = Math.max(bd, _bdMax);
				_rhMin = Math.min(rh, _rhMin);
				_lhMin = Math.min(lh, _lhMin);
				_bdMin = Math.min(bd, _bdMin);
				
				if (count % 2 == 0) {
					message += s + "rh:" + (180 - map(rs, rh, _rhMin, _rhMax)) + ",";
					message += s + "bd:" + (180 - map((_bdMax + _bdMin) * 0.5, bd, _bdMin, _bdMax)) + ",";
					message += s + "lh:" + (180 - map(ls, lh, _lhMin, _lhMax)) + ",";
				}else {
					message += s + "rh:" + map(rs, rh, _rhMin, _rhMax) + ",";
					message += s + "bd:" + map((_bdMax + _bdMin) * 0.5, bd, _bdMin, _bdMax) + ",";
					message += s + "lh:" + map(ls, lh, _lhMin, _lhMax) + ",";
				}
				count ++;
			}
			
			if (Math.random() > 0.95) {
				_rhMax = _rhMax * 0.9 + rh * 0.1;
				_lhMax = _lhMax * 0.9 + lh * 0.1;
				_bdMax = _bdMax * 0.9 + bd * 0.1;
				_rhMin = _rhMin * 0.9 + rh * 0.1;
				_lhMin = _lhMin * 0.9 + lh * 0.1;
				_bdMin = _bdMin * 0.9 + bd * 0.1;
			}
			
			message += "\n";
			return message;
		}
		
		private function map(center:Number, value:Number, low:Number, high:Number):Number {
			var num:Number = value-center;
			if (num < 0) {
				num = -(num / (low - center)) * 90 + 90;
			}else {
				num = (num / (high - center)) * 90 + 90;
			}
			return Math.floor(Math.min(180, Math.max(0, num)));
		}
		
		private function minmax(num:Number):int {
			return Math.floor(Math.min(180, Math.max(0, num)));
		}
		
		public function clone():PoseData {
			var result:PoseData = new PoseData();
			
			return result;
		}
		
		public function toString():String {
			var result:String = "PoseData:{";
			
			result += "}";
			return result;
		}
		
	}
	
}