package azkaban.viewer.config;

import java.io.IOException;

import java.util.*;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import azkaban.ServiceProvider;
import azkaban.executor.ExecutableFlow;
import azkaban.executor.ExecutorManagerException;
import azkaban.viewer.config.dao.ConfigDao;
import azkaban.viewer.config.vo.JobStatus;
import org.apache.log4j.Logger;

import azkaban.user.User;
import azkaban.utils.Props;
import azkaban.server.session.Session;
import azkaban.webapp.servlet.LoginAbstractAzkabanServlet;
import azkaban.webapp.servlet.Page;

public class ConfigBrowserServlet extends LoginAbstractAzkabanServlet {

  private static Logger logger = Logger.getLogger(ConfigBrowserServlet.class);

  private Props props;
  private String viewerName;
  private String viewerPath;


  public ConfigBrowserServlet(Props props) {
    this.props = props;
    viewerName = props.getString("viewer.name");
    viewerPath = props.getString("viewer.path");
  }


  @Override
  public void init(ServletConfig config) throws ServletException {
    super.init(config);
    logger.info("Configuration Browser initiated");
  }



  @Override
  protected void handleGet(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
    Page page =  newPage(req, resp, session,"azkaban/viewer/config/velocity/config-list.vm");
    page.add("user", this.getUsername(req, session));
    String searchTerm = null;
    if (hasParam(req, "search")) {
       searchTerm = getParam(req, "searchterm");
        page.add("search_term", searchTerm);
    }
    try{
      final ConfigDao configDao = ServiceProvider.SERVICE_PROVIDER.getInstance(ConfigDao.class);
      List<JobStatus> jobList = configDao.fetchJobStatus(searchTerm);
      page.add("jobList", jobList);
    }catch (Exception e){
      e.printStackTrace();
    }
    page.add("viewerName", viewerName);
    page.render();
  }

  @Override
  protected void handlePost(HttpServletRequest req, HttpServletResponse resp, Session session) throws ServletException, IOException {
    String action=  getParam(req, "action");
    logger.info(action +" was triggered by user: " + this.getUsername(req, session));
    if(action.equals("createNew")){
      JobStatus jobStatus = new JobStatus();
      jobStatus.setLob(getParam(req, "lob"));
      jobStatus.setSource(getParam(req, "source"));
      jobStatus.setTarget(getParam(req, "target"));
      final ConfigDao configDao = ServiceProvider.SERVICE_PROVIDER.getInstance(ConfigDao.class);
      try {
        configDao.addJobStatus(jobStatus);
      } catch (ExecutorManagerException e) {
        e.printStackTrace();
      }
    }
    if(action.equals("delete")){
      String id = getParam(req, "id");
      logger.info(id +" was deleted by user: " + this.getUsername(req, session));
      final ConfigDao configDao = ServiceProvider.SERVICE_PROVIDER.getInstance(ConfigDao.class);
      try {
        configDao.delJobStatus(id);
      } catch (ExecutorManagerException e) {
        e.printStackTrace();
      }

    }
  }

  private String getUsername(HttpServletRequest req, Session session)
          throws ServletException {
    User user = session.getUser();
    String username = user.getUserId();
    return username;
  }
}
