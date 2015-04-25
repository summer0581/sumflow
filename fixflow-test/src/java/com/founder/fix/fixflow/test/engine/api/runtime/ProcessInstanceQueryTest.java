/**
 * Copyright 1996-2013 Founder International Co.,Ltd.
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
 * @author yangchenhui
 */
package com.founder.fix.fixflow.test.engine.api.runtime;

import java.util.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.founder.fix.fixflow.core.impl.command.ExpandTaskCommand;
import com.founder.fix.fixflow.core.impl.task.QueryExpandTo;
import com.founder.fix.fixflow.core.impl.util.QueryTableUtil;
import com.founder.fix.fixflow.core.runtime.ProcessInstance;
import com.founder.fix.fixflow.core.runtime.ProcessInstanceQuery;
import com.founder.fix.fixflow.core.runtime.ProcessInstanceType;
import com.founder.fix.fixflow.core.task.TaskInstance;
import com.founder.fix.fixflow.core.task.TaskQuery;
import com.founder.fix.fixflow.test.AbstractFixFlowTestCase;
import com.founder.fix.fixflow.test.Deployment;
/**
 * ProcessInstanceQuery的测试类
 */
public class ProcessInstanceQueryTest extends AbstractFixFlowTestCase {

	/**
	 * 测试流程实例查询
	 * @throws InterruptedException 
	 */
	@Deployment(resources = { "com/founder/fix/fixflow/test/engine/api/task/TaskServiceTest.bpmn"})
	public void testProcessInstanceQuery() throws InterruptedException{
		
		Date date = null;
		for(int i = 0;i<10;i++){
			//创建一个通用命令
			ExpandTaskCommand expandTaskCommand = new ExpandTaskCommand();
			//设置流程名
			expandTaskCommand.setProcessDefinitionKey("Process_TaskServiceTest");
			//设置流程的业务关联键
			expandTaskCommand.setBusinessKey("BK_testStartProcessInstanceByKey");
			//命令类型，可以从流程引擎配置中查询   启动并提交为startandsubmit
			expandTaskCommand.setCommandType("startandsubmit");
			//设置提交人
			expandTaskCommand.setInitiator("1200119390");
			//设置命令的id,需和节点上配置的按钮编号对应，会执行按钮中的脚本。
			expandTaskCommand.setUserCommandId("HandleCommand_2");
			
			
			Map<String, Object> mapVariables = new HashMap<String, Object>();
			//设置变量，流程线条上用到，amount<300时走独占任务，否则都共享任务
			int amount = 280+i;
			mapVariables.put("amount", amount);
			expandTaskCommand.setTransientVariables(mapVariables);
			//执行这个启动并提交的命令，返回启动的流程实例
			ProcessInstance processInstance = (ProcessInstance)taskService.expandTaskComplete(expandTaskCommand, null);
			String processInstanceId = processInstance.getId();
			//取得第六个流程启动时的时间，用来验证大于或小于开始时间的查询
			if(i == 6){
				date = processInstance.getStartTime();
			}
			//验证是否成功启动
			assertNotNull(processInstanceId);
			//暂停1000毫秒，用来验证order by 
			Thread.sleep(1000);
		}
		//流程实例查询
		ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//根据流程定义key查询
		List<ProcessInstance> processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").list();
		//验证是10条流程实例
		assertEquals(10, processInstances.size());
		
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//流程实例key的集合
		List<String> definitionKeys = new ArrayList<String>();
		definitionKeys.add("Process_TaskServiceTest");
		//根据key的集合查询实例
		processInstances = processInstanceQuery.processDefinitionKey(definitionKeys).list();
		//验证10条查询结果
		assertEquals(10, processInstances.size());
		
		//根据开始时间降序查询
		processInstanceQuery.orderByStartTime().desc();
		//获取第一页的0-5条结果
		processInstances = processInstanceQuery.listPage(1, 5);
		//获取第二页5-10条结果
		List<ProcessInstance> tmpProcessInstances = processInstanceQuery.listPage(6, 10);
		//取得第一条结果
		Date firstStartTime = processInstances.get(0).getStartTime();
		//验证比本页所有的时间都大，表示降序排序正确
		for(int i = 1;i < processInstances.size();i++){
			Date tmpStartTime = processInstances.get(i).getStartTime();
			assertTrue(firstStartTime.after(tmpStartTime));
		}
		//验证比第二页所有的时间都大，表示降序排序正确
		for(int i = 0;i<tmpProcessInstances.size();i++){
			Date tmpStartTime = tmpProcessInstances.get(i).getStartTime();
			assertTrue(firstStartTime.after(tmpStartTime));
		}
		
		//需要重置查询，因为order by 有叠加效果
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		processInstanceQuery.processDefinitionKey(definitionKeys);
		//根据开始时间升序排序
		processInstanceQuery.orderByStartTime().asc();
		//获取第一页的0-5条结果
		processInstances = processInstanceQuery.listPage(1, 5);
		//获取第二页5-10条结果
		tmpProcessInstances = processInstanceQuery.listPage(6, 10);
		//取得第一条结果
		firstStartTime = processInstances.get(0).getStartTime();
		//验证比本页所有的时间都小，表示升序正确
		for(int i = 1;i < processInstances.size();i++){
			Date tmpStartTime = processInstances.get(i).getStartTime();
			assertTrue(firstStartTime.before(tmpStartTime));
		}
		//验证比第二页所有的时间都小，表示升序正确
		for(int i = 0;i<tmpProcessInstances.size();i++){
			Date tmpStartTime = tmpProcessInstances.get(i).getStartTime();
			assertTrue(firstStartTime.before(tmpStartTime));
		}
		
		
		//需要重置查询，因为order by 有叠加效果
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		processInstanceQuery.processDefinitionKey(definitionKeys);
		//根据更新时间升序排序
		processInstanceQuery.orderByUpdateTime().asc();
		//获取第一页的0-5条结果
		processInstances = processInstanceQuery.listPage(1, 5);
		//获取第二页5-10条结果
		tmpProcessInstances = processInstanceQuery.listPage(6, 10);
		//取得第一条结果
		firstStartTime = processInstances.get(0).getUpdateTime();
		//验证比本页所有的时间都小，表示升序正确
		for(int i = 1;i < processInstances.size();i++){
			Date tmpStartTime = processInstances.get(i).getUpdateTime();
			assertTrue(firstStartTime.before(tmpStartTime));
		}
		//验证比第二页所有的时间都小，表示升序正确
		for(int i = 0;i<tmpProcessInstances.size();i++){
			Date tmpStartTime = tmpProcessInstances.get(i).getUpdateTime();
			assertTrue(firstStartTime.before(tmpStartTime));
		}
		
		
		
		//需要重置查询，因为order by 有叠加效果
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		processInstanceQuery.processDefinitionKey(definitionKeys);
		//根据更新时间降序序排序
		processInstanceQuery.orderByUpdateTime().desc();
		//获取第一页的0-5条结果
		processInstances = processInstanceQuery.listPage(1, 5);
		//获取第二页5-10条结果
		tmpProcessInstances = processInstanceQuery.listPage(6, 10);
		//取得第一条结果
		firstStartTime = processInstances.get(0).getUpdateTime();
		//验证比本页所有的时间都小，表示降序正确
		for(int i = 1;i < processInstances.size();i++){
			Date tmpStartTime = processInstances.get(i).getUpdateTime();
			assertTrue(firstStartTime.after(tmpStartTime));
		}
		//验证比第二页所有的时间都小，表示降序正确
		for(int i = 0;i<tmpProcessInstances.size();i++){
			Date tmpStartTime = tmpProcessInstances.get(i).getUpdateTime();
			assertTrue(firstStartTime.after(tmpStartTime));
		}
		
		
		//验证小于开始时间的查询
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询开始时间小于某个时间的流程实例（时间在方法开始时定义）
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").startTimeBefore(date).list();
		//验证是否有4个
		assertEquals(4, processInstances.size());
		
		//验证大于开始时间的查询
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询开始时间大于某个时间的流程实例（时间在方法开始时定义）
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").startTimeAfter(date).list();
		//验证是否有6个
		assertEquals(7, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询未结束的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").notEnd().list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询已结束的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").isEnd().list();
		//验证是否有0个
		assertEquals(0, processInstances.size());
		
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询对应bizKey的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").processInstanceBusinessKey("BK_testStartProcessInstanceByKey").list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询对应bizKey的流程实例
		long count = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").processInstanceStatus(ProcessInstanceType.RUNNING).count();
		//验证是否有10个
		assertEquals(10, count);
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询对应bizKey的流程实例(方法2)
		processInstances = processInstanceQuery.processInstanceBusinessKey("BK_testStartProcessInstanceByKey","Process_TaskServiceTest").list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询某人发起的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("Process_TaskServiceTest").initiator("1200119390").list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称like“TaskServiceTes”的流程实例
		processInstances = processInstanceQuery.processDefinitionNameLike("TaskServiceTes").list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").list();
		//验证是否有10个
		assertEquals(10, processInstances.size());
		
		
		String processInstanceId = processInstances.get(0).getId();
		TaskQuery taskQuery = taskService.createTaskQuery();
		taskQuery.processInstanceId(processInstanceId).taskNotEnd();
		TaskInstance taskInstance = taskQuery.list().get(0);
		
		Date begin = new Date();
		//创建通用命令
		ExpandTaskCommand expandTaskCommandGeneral=new ExpandTaskCommand();
		//设置命令为处理
		expandTaskCommandGeneral.setCommandType("general");
		//设置命令的ID，需和节点上配置的按钮编号对应，会执行其中脚本
		expandTaskCommandGeneral.setUserCommandId("Normal_1");
		//设置命令的处理任务号
		expandTaskCommandGeneral.setTaskId(taskInstance.getId());
		//领取任务
		taskService.expandTaskComplete(expandTaskCommandGeneral, null);
		Date end = new Date();
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processInstanceId(processInstanceId).list();
		//验证是否有10个
		assertTrue(processInstances.get(0).hasEnded());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").endTimeAfter(end).list();
		
		assertEquals(1, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").endTimeAfter(begin).list();
		
		assertEquals(0, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").endTimeBefore(begin).list();
		
		assertEquals(1, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").endTimeBefore(end).list();
		
		assertEquals(0, processInstances.size());
		
		//重置查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询流程定义名称等于“TaskServiceTest”的流程实例
		processInstances = processInstanceQuery.processDefinitionName("TaskServiceTest").endTimeOn(end).list();
		
		assertEquals(0, processInstances.size());
		
		
	}
	
	/**
	 * 测试流程实例扩展查询
	 * @throws InterruptedException 
	 */
	@Deployment(resources = { "com/founder/fix/fixflow/test/engine/api/task/TaskServiceNewTest.bpmn"})
	public void testProcessInstanceQueryExpandQuery(){
		
		for(int i = 0;i<2;i++){
			//创建一个通用命令
			ExpandTaskCommand expandTaskCommand = new ExpandTaskCommand();
			//设置流程名
			expandTaskCommand.setProcessDefinitionKey("TaskServiceNewTest");
			//设置流程的业务关联键
			expandTaskCommand.setBusinessKey("BK_testStartProcessInstanceByKey");
			//命令类型，可以从流程引擎配置中查询   启动并提交为startandsubmit
			expandTaskCommand.setCommandType("startandsubmit");
			//设置提交人
			expandTaskCommand.setInitiator("1200119390");
			//设置命令的id,需和节点上配置的按钮编号对应，会执行按钮中的脚本。
			expandTaskCommand.setUserCommandId("HandleCommand_2");
			//执行这个启动并提交的命令，返回启动的流程实例
			ProcessInstance processInstance = (ProcessInstance)taskService.expandTaskComplete(expandTaskCommand, null);
			String processInstanceId = processInstance.getId();
			//验证是否成功启动
			assertNotNull(processInstanceId);
		}
		
		TaskQuery taskQuery = taskService.createTaskQuery();
		// 查找 1200119390 的这个流程实例的当前独占任务
		TaskInstance taskInstance = taskQuery.taskAssignee("1200119390").processDefinitionKey("TaskServiceNewTest").taskNotEnd().list().get(0);
		//创建通用命令
		ExpandTaskCommand expandTaskCommandSuspendProcessInstance=new ExpandTaskCommand();
		//设置命令为暂停实例
		expandTaskCommandSuspendProcessInstance.setCommandType("general");
		//设置命令按钮的iD,与节点上处理命令设置一致
		expandTaskCommandSuspendProcessInstance.setUserCommandId("HandleCommand_2");
		//设置命令的处理任务号
		expandTaskCommandSuspendProcessInstance.setTaskId(taskInstance.getId());
		//执行这个暂停实例的命令
		taskService.expandTaskComplete(expandTaskCommandSuspendProcessInstance, null);
		//创建流程实例查询
		ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//获取TaskServiceNewTest的流程实例
		List<ProcessInstance> list = processInstanceQuery.processDefinitionKey("TaskServiceNewTest").list();
		//验证是否为2
		assertEquals(2, list.size());
		
		/**********************本例子通过扩展查询的方法获取TaskServiceNewTest流程的INSTANCE_STATUS = RUNNING的流程实例***************************/
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//创建扩展查询
		QueryExpandTo queryExpandTo = new QueryExpandTo();
		//常见扩展查询的参数列表
		List<Object> whereSqlObj = new ArrayList<Object>();
		//添加扩展wheresql语句    (本例子扩展方法查询正在运行的流程实例)
		queryExpandTo.setWhereSql("INSTANCE_STATUS = ?");
		//增加扩展wheresql的参数
		whereSqlObj.add("RUNNING");
		queryExpandTo.setWhereSqlObj(whereSqlObj);
		//增加扩展查询
		processInstanceQuery.queryExpandTo(queryExpandTo);
		//查询TaskServiceNewTest经过扩展查询后的结果
		processInstanceQuery.processDefinitionKey("TaskServiceNewTest");
		list = processInstanceQuery.list();
		//验证是否为1个
		assertEquals(1, list.size());
		
		/**********************本例子通过扩展查询的方法获取流程定义表中的procecss_name和resource_name字段***************************/
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//创建扩展查询
		queryExpandTo = new QueryExpandTo();
		//添加扩展的字段
		queryExpandTo.setFieldSql("fixflow_def_processdefinition.PROCESS_NAME,fixflow_def_processdefinition.RESOURCE_NAME");
		//增加扩展查询的left join语句
		queryExpandTo.setLeftJoinSql("left join fixflow_def_processdefinition on processdefinition_id = fixflow_def_processdefinition.process_id");
		//增加扩展查询
		processInstanceQuery.queryExpandTo(queryExpandTo);
		//查询TaskServiceNewTest经过扩展查询后的结果
		processInstanceQuery.processDefinitionKey("TaskServiceNewTest");
		list = processInstanceQuery.list();
		//获取第一个流程实例结果
		ProcessInstance  processInstance = list.get(0);
		//获取扩展查询的字段
		String process_name = (String)processInstance.getExtensionField("PROCESS_NAME");
		String RESOURCE_NAME = (String)processInstance.getExtensionField("RESOURCE_NAME");
		//验证获得的扩展字段是否正确
		assertEquals("流程名称", process_name);
		assertEquals("com/founder/fix/fixflow/test/engine/api/task/TaskServiceNewTest.bpmn", RESOURCE_NAME);
	}
	
	/**
	 * 测试根据流程变量查询流程实例
	 * @throws InterruptedException 
	 */
	@Deployment(resources = { "com/founder/fix/fixflow/test/engine/api/runtime/ProcessVariablesTest.bpmn"})
	public void testProcessInstanceVariableData(){
		for(int i = 0;i<5;i++){
			//创建一个通用命令
			ExpandTaskCommand expandTaskCommand = new ExpandTaskCommand();
			//设置流程名
			expandTaskCommand.setProcessDefinitionKey("ProcessVariablesTest");
			//设置流程的业务关联键
			expandTaskCommand.setBusinessKey("BK_testStartProcessInstanceByKey");
			//命令类型，可以从流程引擎配置中查询   启动并提交为startandsubmit
			expandTaskCommand.setCommandType("startandsubmit");
			//设置提交人
			expandTaskCommand.setInitiator("1200119390");
			//设置命令的id,需和节点上配置的按钮编号对应，会执行按钮中的脚本。
			expandTaskCommand.setUserCommandId("HandleCommand_2");
			Map<String,Object> variableMap = new HashMap<String,Object>();
			if(i<3){
				variableMap.put("queryVariable", "查询变量1");
			}else{
				variableMap.put("queryVariable", "查询变量2");
			}
			//expandTaskCommand.setVariables(variableMap);
			//执行这个启动并提交的命令，返回启动的流程实例
			ProcessInstance processInstance = (ProcessInstance)taskService.expandTaskComplete(expandTaskCommand, null);
			String processInstanceId = processInstance.getId();
			//验证是否成功启动
			assertNotNull(processInstanceId);
		}
		
		//重置流程实例查询
		ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询ProcessVariablesTest查询变量值等于"查询变量"的流程实例
		List<ProcessInstance> processInstances = processInstanceQuery.processDefinitionKey("ProcessVariablesTest").processInstanceVariableData("查询变量", false).list();
		//验证是否为0
		assertEquals(0, processInstances.size());
		
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询ProcessVariablesTest查询变量值等于"查询变量1"的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("ProcessVariablesTest").processInstanceVariableData("查询变量1", false).list();
		//验证是否为5
		assertEquals(5, processInstances.size());
		
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询ProcessVariablesTest查询变量值 like "查询变量"的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("ProcessVariablesTest").processInstanceVariableData("查询变量", true).list();
		//验证是否为5
		assertEquals(5, processInstances.size());
		
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询ProcessVariablesTest查询变量"queryVariable"值 like "查询变量"的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("ProcessVariablesTest").processInstanceVariableData("queryVariable","查询变量1",false).list();
		//验证是否为5
		assertEquals(5, processInstances.size());
		
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//查询ProcessVariablesTest查询变量"queryVariable"值 like "查询变量"的流程实例
		processInstances = processInstanceQuery.processDefinitionKey("ProcessVariablesTest").processInstanceVariableData("queryVariable","查询变量",true).list();
		//验证是否为5
		assertEquals(5, processInstances.size());
		
		/**********************本例子通过扩展查询的方法获取ProcessVariablesTest流程的查询变量queryVariable =查询变量1 的流程实例***************************/
		//重置流程实例查询
		processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//创建扩展查询
		QueryExpandTo queryExpandTo = new QueryExpandTo();
		//常见扩展查询的参数列表
		List<Object> whereSqlObj = new ArrayList<Object>();
		//添加扩展wheresql语句    (本例子扩展方法查询正在运行的流程实例)
		queryExpandTo.setWhereSql("PROCESSINSTANCE_ID  IN (SELECT PROCESSINSTANCE_ID FROM "+QueryTableUtil.getDefaultTableName("fixflow_run_variable")+" WHERE VARIABLE_KEY = ? AND BIZ_DATA = ?)");
		//增加扩展wheresql的参数
		whereSqlObj.add("queryVariable");
		whereSqlObj.add("查询变量1");
		queryExpandTo.setWhereSqlObj(whereSqlObj);
		//增加扩展查询
		processInstanceQuery.queryExpandTo(queryExpandTo);
		//查询TaskServiceNewTest经过扩展查询后的结果
		processInstanceQuery.processDefinitionKey("ProcessVariablesTest");
		processInstances = processInstanceQuery.list();
		//验证是否为5个
		assertEquals(5, processInstances.size());
	}
	
	

}
