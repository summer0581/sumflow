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
 * @author kenshin
 */
package com.founder.fix.fixflow.core.impl.model;

import java.util.HashMap;
import java.util.Map;

import com.founder.fix.fixflow.core.query.QueryProperty;




/**
 *
 * 
 * @author kenshin
 */
public class DeploymentQueryProperty implements QueryProperty {

  private static final Map<String, DeploymentQueryProperty> properties = new HashMap<String, DeploymentQueryProperty>();

  public static final DeploymentQueryProperty DEPLOYMENT_ID = new DeploymentQueryProperty("D.ID_");
  public static final DeploymentQueryProperty DEPLOYMENT_NAME = new DeploymentQueryProperty("D.NAME_");
  public static final DeploymentQueryProperty DEPLOY_TIME = new DeploymentQueryProperty("D.DEPLOY_TIME_");
  
  private String name;

  public DeploymentQueryProperty(String name) {
    this.name = name;
    properties.put(name, this);
  }

  public String getName() {
    return name;
  }
  
  public static DeploymentQueryProperty findByName(String propertyName) {
    return properties.get(propertyName);
  }

  
}
