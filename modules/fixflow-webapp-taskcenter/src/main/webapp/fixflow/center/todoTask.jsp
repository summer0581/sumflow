<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${applicationScope.appInfo["product.title"]}</title>
<jsp:include page="head.jsp" flush="true" />
<script type="text/javascript">
/*  
 * "userId" 用户编号
 * "pdkey" 流程编号
 * "pageIndex" 第几页
 * "rowNum" 有几行
 * "agentUserId" 有几行
 * "agentType" 0我代理别人，1别人委托给我
 * "title" 查询主题
 * "processVeriy" 查询变量
 * "arrivalTimeS" 到达时间开始
 * "arrivalTimeE" 到达时间结束
 * "initor" 发起人
 * @param @return
 * "dataList" 数据列表
 * "pageNumber" 总行数
 * "agentUsers" 代理用户
 * "agentToUsers" 委托用户
 * "pageIndex" 第几页
 * "rowNum" 有几行
 */
$(function(){
  var agentType = $("input[name=agentType]").val();
  var userId = $("input[name=userId]").val();
  $("a[name=myTask]").click(function(){
    $("#agentUserId").val('');
    $("#agentType").val('');
    $("#subForm").submit();
  });
  $("a[name=agentUsers]").click(function(){
    var userId = $(this).attr("userId");
    $("#agentUserId").val(userId);
    $("#agentType").val('1');
    $("#subForm").submit();
  });
  $("a[name=agentToUsers]").click(function(){
    var userId = $(this).attr("userId");
    $("#agentUserId").val(userId);
    $("#agentType").val('0');
    $("#subForm").submit();
  });
  $("a[name=flowGraph]").click(function(){
    var pdk = $(this).attr("pdk");
    var pii = $(this).attr("pii");
    var obj = {};
    window.open("FlowCenter?action=getTaskDetailInfo&processDefinitionKey="+pdk+"&processInstanceId="+pii);
  });
  $("a[name=doTask]").click(function(){
    var tii = $(this).attr("tii");
    var pdk = $(this).attr("pdk");
    var pii = $(this).attr("pii");
    var bizKey = $(this).attr("bk");
    
    var obj = {};
    var formUrl = $(this).attr("formUri");//"FlowCenter?action=startOneTask";
    var url = formUrl;
    if(formUrl.indexOf("?")!=-1){
   	 url+="&";
   	
    }else{
   	 url+="?";
    }
    url+="taskId="+tii+"&processInstanceId="+pii+"&bizKey="+bizKey+"&processDefinitionKey="+pdk,obj,"dialogWidth=800px;dialogHeight=600px";
   	window.open(url);
  });
	$("#selectUser").click(function(){
		var obj = {
		  type:"user"
		};
		var d = FixSelect(obj);
		var userId = d[0].USERID;
		var userName = d[0].USERNAME;
		$("#initor").val(userId);
		$("#initorName").val(userName);
	});
	$("#agent_"+$("#agentUserId").val()).css("background-color","#ffffff");
});

function clearInfo(){
		$("#title").val("");
		$("#processDefinitionKey").val("");
		$("#processDefinitionName").val("");
		$("#bizKey").val("");
		$("#initor").val("");
		$("#initorName").val("");
		$("#arrivalTimeS").val("");
		$("#arrivalTimeE").val("");
	}
</script>
</head>

<body>
	<div class="main-panel">
		<jsp:include page="top.jsp" flush="true" />

		<div class="center-panel">
			<form id="subForm" method="post" action="FlowCenter">
				<!-- 左 -->
				<div class="left">
					<div class="left-nav-box">
						<div class="left-nav">
							<a name="myTask" href="#">${applicationScope.appInfo["task.myTask"]}</a>
						</div>
						<div class="left-nav-orange-line">&nbsp;</div>



						<div class="left-nav m-top">
							<h1>${applicationScope.appInfo["task.agent"]}</h1>
						</div>
						<c:if
							test="${result.agentUsers!= null && fn:length(result.agentUsers) != 0}">
							<c:forEach items="${result.agentUsers}" var="agentUsers"
								varStatus="index">
								<div class="left-nav">
									<a name="agentUsers" userId="${agentUsers.userid}" href="#"><img
										src="${agentUsers.userid}" height="30" width="30" alt="头像"
										onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />${agentUsers.username}</a>
								</div>
							</c:forEach>
						</c:if>

						<div class="left-nav m-top">
							<h1>${applicationScope.appInfo["task.toAgent"]}</h1>
						</div>
						<c:if
							test="${result.agentToUsers!= null && fn:length(result.agentToUsers) != 0}">
							<c:forEach items="${result.agentToUsers}" var="agentToUsers"
								varStatus="index">
								<div class="left-nav" id="agent_${agentToUsers.userid}">
									<a name="agentToUsers" userId="${agentToUsers.userid}" href="#"><img
										src="icon/${agentToUsers.userid}_small.png" height="30"
										width="30" alt="头像"
										onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />${agentToUsers.username}</a>
								</div>
							</c:forEach>
						</c:if>
					</div>
					<div class="message" style="display:none">
						<div class="title">
							<a href="#"><em class="icon-message"></em>消息中心</a>
						</div>
						<div class="message-content">
							<div class="msg">
								<img src="images/temp/user01.jpg"
									onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />张飞：今天还没吃午饭！
								<div class="time">一小时前</div>
							</div>
							<div class="msg">
								<img src="images/temp/user01.jpg"
									onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />曹操：煮酒论英雄！谁一起吃饭啊
								<div class="time">一小时前</div>
							</div>
							<div class="msg">
								<img src="images/temp/user01.jpg"
									onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />张飞：今天还没吃午饭！
								<div class="time">一小时前</div>
							</div>
							<div class="msg">
								<img src="images/temp/user01.jpg"
									onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />张飞：今天还没吃午饭！
								<div class="time">一小时前</div>
							</div>
							<div class="msg">
								<img src="images/temp/user01.jpg"
									onerror="miniImgNotFound('${pageContext.request.contextPath}',this);" />张飞：今天还没吃午饭！
								<div class="time">一小时前</div>
							</div>
						</div>
					</div>
				</div>
				<div class="right">
					<!-- 隐藏参数部分 -->
					<input type="hidden" id="agentUserId" name="agentUserId"
						value="<c:out value="${result.agentUserId}"/>"><input
						type="hidden" id="agentType" name="agentType"
						value="<c:out value="${result.agentType}"/>"><input
						type="hidden" name="action" value="getMyTask" />
					<div class="search">
						<table>
							<tr>
								<td class="title-r">${applicationScope.appInfo["task.description"]}：</td>
								<td><input type="text" id="title"
									name="title" class="fix-input"
									value="${result.title}" /></td>
								<td class="title-r">${applicationScope.appInfo["task.processDefinitionName"]}：</td>
								<td><input type="text" id="processDefinitionName"
									name="processDefinitionName" class="fix-input"  value="${result.processDefinitionName}" /></td>
								<td class="title-r">${applicationScope.appInfo["task.bizKey"]}：</td>
								<td><input type="text" id="bizKey"
									name="bizKey" class="fix-input"
									value="${result.bizKey}" /></td>
								<td>
					                <table style="margin:0">
					                <tr>
					                <td>
					                <div class="btn-normal"><a href="#" onclick="$('#subForm').submit();">${applicationScope.appInfo["common.search"]}</a></div>
					                </td>
					                <td>
					                <div class="btn-normal"><a href="#" onclick="clearInfo();">${applicationScope.appInfo["common.clear"]}</a></div>
									</td>                
					                </tr>
					                </table>
									</td>
							</tr>
							<tr>
								<td class="title-r">${applicationScope.appInfo["task.initor"]}：</td>
								<td>
					                <table style="margin:0">
					                <tr>
					                <td>
					                <input type="hidden" id="initor" name="initor" class="fix-input" value="${result.initor}"/>
					                <input type="text" id="initorName" readonly="true" name="initorName" class="fix-input" style="width:94px;" value="${result.initorName}"/>
					                </td>
					                <td>
					                <div class="btn-normal">
															<a href="#" onclick="" id="selectUser">${applicationScope.appInfo["common.select"]}<em
																class="arrow-small"></em></a>
									</div>
									</td>
									</tr>
									</table>
								</td>
								<td class="title-r">${applicationScope.appInfo["task.createTime"]}：</td>
								<td><input type="text" id="arrivalTimeS" name="arrivalTimeS"
									class="fix-input" style="width: 69px;"
									value="${result.arrivalTimeS}" onClick="WdatePicker()" /> - <input
									type="text" id="arrivalTimeE" name="arrivalTimeE" class="fix-input"
									style="width: 69px;" value="${result.arrivalTimeE}"
									onClick="WdatePicker()" /></td>
								<td></td>
								<td></td>
								<td></td>
							</tr>
						</table>
					</div>
					<div class="content">
						<table width="100%" class="fix-table">
							<thead>
								<th width="30">${applicationScope.appInfo["common.no"]}</th>
								<th width="30"></th>
								<th>${applicationScope.appInfo["task.processDefinitionName"]}</th>
								<th>${applicationScope.appInfo["task.bizKey"]}</th>
								<th>${applicationScope.appInfo["task.description"]}</th>
								<th>${applicationScope.appInfo["task.initor"]}</th>
								<th>${applicationScope.appInfo["task.startTime"]}</th>
								<th>${applicationScope.appInfo["task.nodeName"]}</th>
								<th width="160">${applicationScope.appInfo["task.createTime"]}</th>
								<th width="60">${applicationScope.appInfo["task.status"]}</th>
							</thead>
							<c:forEach items="${result.dataList}" var="dataList"
								varStatus="index">
								<tr>
									<td style="text-align:center;">${(index.index+1)+pageInfo.pageSize*(pageInfo.pageIndex-1)}</td>

									<td><img src="icon/${dataList.PI_START_AUTHOR}_small.png"
										height="30" width="30" alt="头像"
										onerror="miniImgNotFound('${pageContext.request.contextPath}',this);"></td>
									<td>${dataList.processDefinitionName}</td>
									<td>${dataList.bizKey}</td>
									<td><a name="doTask" href="#"
										formUri="${dataList.formUri}" tii="${dataList.taskInstanceId}"
										pii="${dataList.processInstanceId}" bk="${dataList.bizKey}"
										pdk="${dataList.processDefinitionKey}">${dataList.description}</a>
									</td>
									<td>${dataList.userName}</td>
									<td><fmt:formatDate value="${dataList.PI_START_TIME}"
											type="both" /></td>
									<td>${dataList.nodeName}</td>
									<td><fmt:formatDate value="${dataList.createTime}"
											type="both" />
									</td>
									<td><a name="flowGraph" href="#"
										pii="${dataList.processInstanceId}"
										pdk="${dataList.processDefinitionKey}">${applicationScope.appInfo["common.check"]}</a></td>
								</tr>
							</c:forEach>
						</table>

					</div>
				</div>
				<!-- 分页 -->
				<div id="page">
					<jsp:include page="../common/page.jsp" flush="true" />
				</div>

			</form>
		</div>
	</div>

</body>
</html>
