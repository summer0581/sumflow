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
 * @author ych
 * @author kenshin
 */
package com.founder.fix.fixflow.editor.language.json.converter;

import java.util.Map;

import com.founder.fix.fixflow.editor.language.json.converter.BaseBpmnJsonConverter;
import com.founder.fix.fixflow.editor.language.json.converter.BusinessRuleTaskJsonConverter;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.node.ObjectNode;
import org.eclipse.bpmn2.BaseElement;
import org.eclipse.bpmn2.Bpmn2Factory;
import org.eclipse.bpmn2.BusinessRuleTask;
import org.eclipse.bpmn2.FlowElement;
import org.eclipse.bpmn2.impl.BusinessRuleTaskImpl;

public class BusinessRuleTaskJsonConverter extends BaseBpmnJsonConverter {

  public static void fillTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap,
      Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    
    fillJsonTypes(convertersToBpmnMap);
    fillBpmnTypes(convertersToJsonMap);
  }
  
  public static void fillJsonTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap) {
    convertersToBpmnMap.put(STENCIL_TASK_BUSINESS_RULE, BusinessRuleTaskJsonConverter.class);
  }
  
  public static void fillBpmnTypes(Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    convertersToJsonMap.put(BusinessRuleTaskImpl.class, BusinessRuleTaskJsonConverter.class);
  }
  
  protected String getStencilId(FlowElement flowElement) {
    return STENCIL_TASK_BUSINESS_RULE;
  }
  
  protected void convertElementToJson(ObjectNode propertiesNode, FlowElement flowElement) {
	  
  }
  
  protected FlowElement convertJsonToElement(JsonNode elementNode, JsonNode modelNode, Map<String, JsonNode> shapeMap) {
    BusinessRuleTask task = Bpmn2Factory.eINSTANCE.createBusinessRuleTask();// BusinessRuleTask();
    /*task.setClassName(getPropertyValueAsString(PROPERTY_RULETASK_CLASS, elementNode));
    task.setInputVariables(getPropertyValueAsList(PROPERTY_RULETASK_VARIABLES_INPUT, elementNode));
    task.setResultVariableName(getPropertyValueAsString(PROPERTY_RULETASK_RESULT, elementNode));
    task.setRuleNames(getPropertyValueAsList(PROPERTY_RULETASK_RULES, elementNode));
    task.setExclude(getPropertyValueAsBoolean(PROPERTY_RULETASK_EXCLUDE, elementNode));*/
    return task;
  }
}
