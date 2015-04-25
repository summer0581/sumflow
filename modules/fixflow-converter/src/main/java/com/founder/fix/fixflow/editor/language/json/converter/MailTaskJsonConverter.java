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
import com.founder.fix.fixflow.editor.language.json.converter.MailTaskJsonConverter;
import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.node.ObjectNode;
import org.eclipse.bpmn2.BaseElement;
import org.eclipse.bpmn2.Bpmn2Factory;
import org.eclipse.bpmn2.FlowElement;
import org.eclipse.bpmn2.ServiceTask;

public class MailTaskJsonConverter extends BaseBpmnJsonConverter {

  public static void fillTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap,
      Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    
    fillJsonTypes(convertersToBpmnMap);
    fillBpmnTypes(convertersToJsonMap);
  }
  
  public static void fillJsonTypes(Map<String, Class<? extends BaseBpmnJsonConverter>> convertersToBpmnMap) {
    convertersToBpmnMap.put(STENCIL_TASK_MAIL, MailTaskJsonConverter.class);
  }
  
  public static void fillBpmnTypes(Map<Class<? extends BaseElement>, Class<? extends BaseBpmnJsonConverter>> convertersToJsonMap) {
    // will be handled by ServiceTaskJsonConverter
  }
  
  protected String getStencilId(FlowElement flowElement) {
    return STENCIL_TASK_MAIL;
  }
  
  protected void convertElementToJson(ObjectNode propertiesNode, FlowElement flowElement) {
    // will be handled by ServiceTaskJsonConverter
  }
  
  protected FlowElement convertJsonToElement(JsonNode elementNode, JsonNode modelNode, Map<String, JsonNode> shapeMap) {
  	ServiceTask task = Bpmn2Factory.eINSTANCE.createServiceTask();
  	//task.setType(ServiceTask.MAIL_TASK);
  	/*addField(PROPERTY_MAILTASK_TO, elementNode, task);
  	addField(PROPERTY_MAILTASK_FROM, elementNode, task);
  	addField(PROPERTY_MAILTASK_SUBJECT, elementNode, task);
  	addField(PROPERTY_MAILTASK_CC, elementNode, task);
  	addField(PROPERTY_MAILTASK_BCC, elementNode, task);
  	addField(PROPERTY_MAILTASK_TEXT, elementNode, task);
  	addField(PROPERTY_MAILTASK_HTML, elementNode, task);
  	addField(PROPERTY_MAILTASK_CHARSET, elementNode, task);
    */
    return task;
  }
  /*
  protected void addField(String name, JsonNode elementNode, ServiceTask task) {
    FieldExtension field = new FieldExtension();
    field.setFieldName(name.substring(8));
    String value = getPropertyValueAsString(name, elementNode);
    if (StringUtils.isNotEmpty(value)) {
      if ((value.contains("${") || value.contains("#{")) && value.contains("}")) {
        field.setExpression(value);
      } else {
        field.setStringValue(value);
      }
      task.getFieldExtensions().add(field);
    }
  }*/
}
