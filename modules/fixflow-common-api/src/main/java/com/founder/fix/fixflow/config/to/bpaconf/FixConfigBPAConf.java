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
package com.founder.fix.fixflow.config.to.bpaconf;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;

/**
 * @ClassName: FixConfigBPAConf
 * @Description: TODO
 * @author shao
 *
 */
public class FixConfigBPAConf {
	private List<FixConfigBPAAnlysisEngine> analysisEngine;
	
	private Map<String,FixConfigBPAAnlysisEngine> mapAnalysisEngine = new HashMap<String,FixConfigBPAAnlysisEngine>();


	@XmlElements(value = { @XmlElement (name="analysisEngine",type=FixConfigBPAAnlysisEngine.class)})
	public List<FixConfigBPAAnlysisEngine> getAnalysisEngine() {
		return analysisEngine;
	}

	public void setAnalysisEngine(List<FixConfigBPAAnlysisEngine> analysisEngine) {
		this.analysisEngine = analysisEngine;
		for(FixConfigBPAAnlysisEngine tmp:analysisEngine){
			mapAnalysisEngine.put(tmp.getId(), tmp);
		}
	}
	
	public FixConfigBPAAnlysisEngine getEngine(String key){
		return mapAnalysisEngine.get(key);
	}
}
