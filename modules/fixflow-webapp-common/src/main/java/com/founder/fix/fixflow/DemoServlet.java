/**
 *  Copyright 1996-2013 Founder International Co.,Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * @author shao
 */
package com.founder.fix.fixflow;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.founder.fix.fixflow.core.ConnectionManagement;
import com.founder.fix.fixflow.core.impl.db.SqlCommand;
import com.founder.fix.fixflow.core.impl.util.StringUtil;
import com.founder.fix.fixflow.service.FlowCenterService;
import com.founder.fix.fixflow.shell.FixFlowShellProxy;
import com.founder.fix.fixflow.util.CurrentThread;
import com.founder.fix.fixflow.util.JSONUtil;
import com.founder.fix.fixflow.util.SpringConfigLoadHelper;

/**
 * Servlet implementation class FlowCenter
 */
public class DemoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DemoServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("ISGET", "ISGET");
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String userId = StringUtil.getString(request.getSession().getAttribute(
				FlowCenterService.LOGIN_USER_ID));
		if (StringUtil.isEmpty(userId)) {
			String context = request.getContextPath();
			response.sendRedirect(context + "/");
			return;
		}
		//在开始时调用此方法，会声明本次线程里所有的数据库操作都会线程池化。
		CurrentThread.init();
		ServletOutputStream out = null;
		String action = StringUtil.getString(request.getParameter("action"));
		if (StringUtil.isEmpty(action)) {
			action = StringUtil.getString(request.getAttribute("action"));
		}

		RequestDispatcher rd = null;
		try {
			Map<String, Object> filter = new HashMap<String, Object>();


			Enumeration enu = request.getParameterNames();
			while (enu.hasMoreElements()) {
				Object tmp = enu.nextElement();
				Object obj = request
						.getParameter(StringUtil.getString(tmp));

				// if (request.getAttribute("ISGET") != null)
				obj = new String(obj.toString().getBytes("ISO8859-1"),
						"utf-8");

				filter.put(StringUtil.getString(tmp), obj);
			}


			Enumeration attenums = request.getAttributeNames();
			while (attenums.hasMoreElements()) {
				String paramName = (String) attenums.nextElement();

				Object paramValue = request.getAttribute(paramName);

				// 形成键值对应的map
				filter.put(paramName, paramValue);

			}

			filter.put("userId", userId);
			request.setAttribute("nowAction", action);
			if (action.equals("startOneTask")) { // 仅实现获取按钮功能 add by Rex
				rd = request.getRequestDispatcher("/fixflow/demo/startOneTask.jsp");
				
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));

				Map<String, Object> list = getFlowCenter().GetFlowRefInfo(
						filter);
				Object key = filter.get("bizKey");
				Connection connection = null;
				try {
					if(key!=null){
						rd = request.getRequestDispatcher("/fixflow/demo/doTask.jsp");
						connection = FixFlowShellProxy
								.getConnection(ConnectionManagement.defaultDataBaseId);
					
						SqlCommand sc = new SqlCommand(connection);
						List params = new ArrayList();
						params.add(key);
						List<Map<String, Object>> res = sc.queryForList(
								"select * from DEMOTABLE where COL1=?", params);
						if(res!=null && res.size()>0)
							filter.put("demoObject", res.get(0));
						request.setAttribute("result", filter);
					}
					filter.putAll(list);
					request.setAttribute("result", filter);
				}finally{
					if(connection!=null)
						connection.close();					
				}
			} else if (action.equals("doTask")) {// 演示如何进入一个已发起的流程处理页面
				filter.put("path", request.getSession().getServletContext()
						.getRealPath("/"));

				Connection connection = FixFlowShellProxy
						.getConnection(ConnectionManagement.defaultDataBaseId);

				try {
					SqlCommand sc = new SqlCommand(connection);
					List params = new ArrayList();
					params.add(filter.get("bizKey"));
					List<Map<String, Object>> res = sc.queryForList(
							"select * from DEMOTABLE where COL1=?", params);
					
					if(res!=null && res.size()>0)
						filter.put("demoObject", res.get(0));

					FlowCenterService fcs = getFlowCenter();
					Map<String, Object> list = fcs.GetFlowRefInfo(filter);
					filter.putAll(list);
					request.setAttribute("result", filter);
					rd = request.getRequestDispatcher("/fixflow/demo/doTask.jsp");
				}finally{
					connection.close();					
				}
			} else if (action.equals("demoCompleteTask")) {// 演示如何完成下一步
				//这里直接打开了DB_FIX_BIZ_BASE库
				Connection connection = FixFlowShellProxy
						.getConnection(ConnectionManagement.defaultDataBaseId);
				PreparedStatement ps = null;

				try {
					//设置这里开始jdbc级别事务
					connection.setAutoCommit(false);
					ps = connection
							.prepareStatement("insert into DEMOTABLE(COL1,COL2) values(?,?)");
					ps.setObject(1, filter.get("businessKey"));
					ps.setObject(2, filter.get("COL2"));
					ps.execute();
					FlowCenterService fcs = getFlowCenter();
					fcs.setConnection(connection);
					fcs.completeTask(filter);

					//事务提交
					connection.commit();
				} catch(Exception e){
					//事务回滚
					connection.rollback();
					throw e;
				}finally {
					rd = request
							.getRequestDispatcher("/fixflow/common/result.jsp");
					if (ps != null)
						ps.close();
					connection.close();
				}
			} else if (action.equals("demoDoNext")) {// 演示如何在流程已经发起后继续往下运行
				//这里直接打开了DB_FIX_BIZ_BASE库
				Connection connection = FixFlowShellProxy
						.getConnection(ConnectionManagement.defaultDataBaseId);
				try{
					//设置这里开始jdbc级别事务
					connection.setAutoCommit(false);
					String taskParams = StringUtil.getString(filter
							.get("taskParams"));
					Map<String, Object> flowMaps = JSONUtil
							.parseJSON2Map(taskParams);
					filter.put("taskParams", flowMaps);
					FlowCenterService fcs = getFlowCenter();
					fcs.setConnection(connection);
					fcs.completeTask(filter);
					//事务提交
					connection.commit();
				}catch(Exception e){
					connection.rollback();
					throw e;
				}finally{
					rd = request
							.getRequestDispatcher("/fixflow/common/result.jsp");
				}
		}
		if (rd != null)
			rd.forward(request, response);
		} catch (Exception e) {
			try {
				CurrentThread.rollBack();
			} catch (SQLException e1) {
				// TODO 自动生成的 catch 块
				e1.printStackTrace();
			}
			e.printStackTrace();
			request.setAttribute("errorMsg", e.getMessage());
		} finally {
			//在最终结果里进行结果清空
			if (out != null) {
				out.flush();
				out.close();
			}
			//调用这个方法会清空本次线程里所有用到的连接等资源，确保不会有泄漏
			try {
				CurrentThread.clear();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public FlowCenterService getFlowCenter() {
		return (FlowCenterService) SpringConfigLoadHelper
				.getBean("flowCenterServiceImpl");
	}

}
