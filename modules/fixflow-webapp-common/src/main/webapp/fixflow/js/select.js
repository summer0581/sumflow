/**
 * 所有HTML选人界面的控制层
 * @param type 选择界面类型
 * @param isMulti 是否多选
 * @returns 选择的List<Map>
 */
function FixSelect(obj,fn,params){
	//var that = arguments[arguments.length-1];
	window.rv = null;
	var rv = null;
	var w = obj.width||"800px";
	var h = obj.height||"600px";
	var isMulti = obj.isMulti||"false";
	var passObj = {
		fn:fn,
		params:params,
		opener:window
	};
	switch(obj.type){
		case "user":
			rv = window.open("FlowCenter?action=selectUserList&isMulti="+isMulti);
			break;
		case "node":
			rv = window.open("FlowCenter?action=selectNodeList&taskId="+obj.taskId,passObj);
			break;
		case "step":
			rv = window.open("FlowCenter?action=selectStepList&taskId="+obj.taskId,passObj);
			break;
		default:
			break;
			
	}
	if(rv){
		return rv;
	}else{
		return window.rv;
	}
};