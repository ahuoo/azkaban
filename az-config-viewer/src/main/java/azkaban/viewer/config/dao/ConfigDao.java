/*
 * Copyright 2017 LinkedIn Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package azkaban.viewer.config.dao;

import azkaban.db.DatabaseOperator;
import azkaban.db.EncodingType;
import azkaban.db.SQLTransaction;
import azkaban.executor.*;
import azkaban.utils.GZIPUtils;
import azkaban.utils.JSONUtils;
import azkaban.utils.Pair;
import azkaban.viewer.config.vo.ExecutionOptions;
import azkaban.viewer.config.vo.JobStatus;
import org.apache.commons.dbutils.ResultSetHandler;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import javax.inject.Inject;
import javax.inject.Singleton;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Singleton
public class ConfigDao {

  private static final Logger logger = Logger.getLogger(ConfigDao.class);
  private final DatabaseOperator dbOperator;

  @Inject
  public ConfigDao(final DatabaseOperator dbOperator) {
    this.dbOperator = dbOperator;
  }


  public List<JobStatus> fetchJobStatus(String searchTerm)  throws ExecutorManagerException {
    try {
      String sql = "SELECT id, lob,source,target, status,error_message,begin_date,end_date,latest_execution_time,execution_options from project_flow_status ";
      if(searchTerm!=null){
        sql = "SELECT id, lob,source,target, status,error_message,begin_date,end_date,latest_execution_time,execution_options from project_flow_status " +
                " where lob like '%"+searchTerm+"%' or source like '%"+searchTerm+"%'  or target like '%"+searchTerm+"%'";
      }
      return this.dbOperator.query(sql, new FetchJobStatus());
    } catch (final SQLException e) {
      throw new ExecutorManagerException("Error fetching job status", e);
    }
  }

    public void addJobStatus(JobStatus jobStatus) throws ExecutorManagerException {
      String sql = "INSERT INTO project_flow_status (lob, source, target, execution_options) values (?,?,?,?)";
      try {
        if(jobStatus.getExecutionOptions()!=null){
          this.dbOperator.update(sql,jobStatus.getLob(), jobStatus.getSource(), jobStatus.getTarget(), jobStatus.getExecutionOptions().toJson());
        }else{
          this.dbOperator.update(sql,jobStatus.getLob(), jobStatus.getSource(), jobStatus.getTarget(), null);
        }

      } catch (SQLException e) {
        throw new ExecutorManagerException("Error adding job status", e);
      }
    }

  public void delJobStatus(String id) throws ExecutorManagerException {
    String sql = "DELETE FROM project_flow_status WHERE id=?";
    try {
      this.dbOperator.update(sql,id);
    } catch (SQLException e) {
      throw new ExecutorManagerException("Error deleting job status", e);
    }
  }

    public static class FetchJobStatus implements ResultSetHandler<List<JobStatus>> {
    @Override
    public List<JobStatus> handle(ResultSet rs) throws SQLException {
      if (!rs.next()) {
        return Collections.emptyList();
      }
      List<JobStatus> list = new ArrayList<JobStatus>();
      do {
        JobStatus jobStatus = new JobStatus();
        jobStatus.setId(rs.getInt(1));
        jobStatus.setLob(rs.getString(2));
        jobStatus.setSource(rs.getString(3));
        jobStatus.setTarget(rs.getString(4));
        jobStatus.setStatus(Status.valueOf(rs.getString(5)));
        jobStatus.setErrorMsg(rs.getString(6));
        jobStatus.setBeginDt(rs.getLong(7));
        jobStatus.setEndDt(rs.getLong(8));
        jobStatus.setExecutionTime(rs.getLong(9));
        jobStatus.setExecutionOptions(ExecutionOptions.fromJson(rs.getString(10)));
        list.add(jobStatus);
      } while (rs.next());

      return list;
    }
  }

}
