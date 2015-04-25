<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
	function closeThisPage() {
		window.close();	
	}
</script>
<body>
<div class="userinfo">
	<div class="head-info">
        <div class="name">
        	<h1>操作完成</h1>
			
        	<h1><c:if test="${errorMsg!=null}">但是发生了错误：${errorMsg}</c:if></h1>
            <h5><a href="#" onclick="closeThisPage()">关闭</a></h5>
        </div>
    </div>
</div>
</body>
</html>
    