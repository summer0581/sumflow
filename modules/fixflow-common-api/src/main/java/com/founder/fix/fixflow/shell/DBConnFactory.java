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
package com.founder.fix.fixflow.shell;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;
import org.springframework.jdbc.datasource.DataSourceUtils;

/**
  * @ClassName: DBConnFactory
  * @author shao
  *
  */
public class DBConnFactory
{
	private DataSource dataSource;
	
	private String transactionName;
	
	/**
	  * createConnection
	
	  * @Title: createConnection
	  * @param @return
	  * @param @throws SQLException    设定文件
	  * @return Connection    返回类型
	  * @throws
	  */
	public Connection createConnection() throws SQLException{
		Connection connection = DataSourceUtils.getConnection(dataSource);
		return connection;
	}
	
	public DBConnection createDBConnection() throws SQLException{
		DBConnection dbconn = new DBConnection();
		Connection connection = DataSourceUtils.getConnection(dataSource);
		dbconn.setConnection(connection);
		dbconn.setDataSource(dataSource);
		return dbconn;
	}
	

	/**
	  * getDataSource
	
	  * @Title: getDataSource
	  * @param @return    设定文件
	  * @return DataSource    返回类型
	  * @throws
	  */
	public DataSource getDataSource() {
		return dataSource;
	}

	/**
	  * setDataSource
	
	  * @Title: setDataSource
	  * @param @param dataSource    设定文件
	  * @return void    返回类型
	  * @throws
	  */
	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	/**
	  * getTransactionName
	
	  * @Title: getTransactionName
	  * @param @return    设定文件
	  * @return String    返回类型
	  * @throws
	  */
	public String getTransactionName() {
		return transactionName;
	}

	/**
	  * setTransactionName
	
	  * @Title: setTransactionName
	  * @param @param transactionName    设定文件
	  * @return void    返回类型
	  * @throws
	  */
	public void setTransactionName(String transactionName) {
		this.transactionName = transactionName;
	}
	
	
}