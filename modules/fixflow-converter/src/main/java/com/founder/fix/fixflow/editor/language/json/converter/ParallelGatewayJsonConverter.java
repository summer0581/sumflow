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
import com.founder.fix.fixflow.editor.language.json.converter.ParallelGatewayJsonConverter;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.node.ObjectNode;
import org.eclipse.bpmn2.BaseElement;
import org.eclipse.bpmn2.Bpmn2Factory;
import org.eclipse.bpmn2.FlowElement;
import org.eclipse.bpmn2.GatewayDirection;
import org.eclipse.bpmn2.ParallelGateway;

import com.founder.fix.fixflow.core.impl.bpmn.behavior.ParallelGatewayBehavior;
import com.founder.fix.fixflow.core.impl.util.StringUtil;


public class ParallelGatewayJsonConverter extends BaseBpmnJsonConverter {

  public static void fillTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap,
      Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    
    fillJsonTypes(convertersToBpmnMap);
    fillBpmnTypes(convertersToJsonMap);
  }
  
  public static void fillJsonTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap) {
    convertersToBpmnMap.put(STENCIL_GATEWAY_PARALLEL, ParallelGatewayJsonConverter.class);
  }
  
  public static void fillBpmnTypes(Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    convertersToJsonMap.put(ParallelGatewayBehavior.class, ParallelGatewayJsonConverter.class);
  }
  
  protected String getStencilId(FlowElement flowElement) {
    return STENCIL_GATEWAY_PARALLEL;
  }
  
  protected void convertElementToJson(ObjectNode propertiesNode, FlowElement flowElement) {
	  ParallelGatewayBehavior parallelGatewayBehavior = (ParallelGatewayBehavior)flowElement;
	  setPropertyValue(PROPERTY_GATEWAT_DIRECTION, StringUtil.getString(parallelGatewayBehavior.getGatewayDirection()), propertiesNode);
  }
  
  protected FlowElement convertJsonToElement(JsonNode elementNode, JsonNode modelNode, Map<String, JsonNode> shapeMap) {
    ParallelGateway gateway = Bpmn2Factory.eINSTANCE.createParallelGateway();// ParallelGateway();
    String direction = getPropertyValueAsString(PROPERTY_GATEWAT_DIRECTION, elementNode);
    if(StringUtil.isNotEmpty(direction)){
    	GatewayDirection gatewayDirection = GatewayDirection.getByName(direction);
    	gateway.setGatewayDirection(gatewayDirection);
    }
    return gateway;
  }
}
